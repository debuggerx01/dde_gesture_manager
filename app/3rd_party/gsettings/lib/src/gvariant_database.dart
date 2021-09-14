import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dbus/dbus.dart';

import 'gvariant_binary_codec.dart';

class GVariantDatabase {
  final String path;

  GVariantDatabase(this.path);

  Future<List<String>> list({String? dir, String? type}) async {
    var root = await _loadRootTable();
    return root.list(dir: dir, type: type);
  }

  Future<DBusValue?> lookup(String key) async {
    var root = await _loadRootTable();
    return root.lookup(key);
  }

  Future<GVariantDatabaseTable?> lookupTable(String key) async {
    var root = await _loadRootTable();
    return root.lookupTable(key);
  }

  Future<GVariantDatabaseTable> _loadRootTable() async {
    var rawData = await File(path).readAsBytes();
    var data = ByteData.view(rawData.buffer);

    // Check for correct signature and detect endianess.
    var signature0 = data.getUint32(0, Endian.little);
    var signature1 = data.getUint32(4, Endian.little);
    var version = data.getUint32(8, Endian.little);
    Endian endian;
    if (signature0 == 1918981703 && signature1 == 1953390953 && version == 0) {
      endian = Endian.little;
      /*} else if (signature0 == && signature1 == && version == 0) {
         endian = Endian.big;*/
    } else {
      throw ('Invalid signature');
    }

    var rootStart = data.getUint32(16, endian);
    var rootEnd = data.getUint32(20, endian);
    return GVariantDatabaseTable(
        ByteData.sublistView(data, rootStart, rootEnd), data, endian);
  }
}

class GVariantDatabaseTable {
  final ByteData data;
  final ByteData fullData;
  final Endian endian;
  late final int _nBloomWords;
  //late final int _bloomOffset; // FIXME
  late final int _nBuckets;
  late final int _bucketOffset;
  late final int _nHashItems;
  late final int _hashOffset;

  GVariantDatabaseTable(this.data, this.fullData, this.endian) {
    var offset = 0;
    _nBloomWords = data.getUint32(offset + 0, endian) & 0x3ffffff;
    _nBuckets = data.getUint32(offset + 4, endian);
    offset += 8;
    //_bloomOffset = offset; // FIXME
    offset += _nBloomWords * 4;
    _bucketOffset = offset;
    offset += _nBuckets * 4;
    _hashOffset = offset;

    _nHashItems = (data.lengthInBytes - _hashOffset) ~/ 24;
  }

  List<String> list({String? dir, String? type}) {
    var dirHash = dir != null ? _hashKey(dir) : 0;
    var children = <String>[];

    for (var i = 0; i < _nHashItems; i++) {
      var parent = _getParent(i);
      if (type != null && _getType(i) != type) {
        continue;
      }
      if (dir != null) {
        if (parent == 0xffffffff || _getHash(parent) != dirHash) {
          continue;
        }
      } else {
        if (parent != 0xffffffff) {
          continue;
        }
      }
      children.add(_getKey(i));
    }

    return children;
  }

  DBusValue? lookup(String key) {
    var value = _lookup(key, type: 'v');
    if (value == null) {
      return null;
    }
    var codec = GVariantBinaryCodec();
    return (codec.decode('v', value, endian: endian) as DBusVariant).value;
  }

  GVariantDatabaseTable? lookupTable(String key) {
    var value = _lookup(key, type: 'H');
    if (value == null) {
      return null;
    }
    return GVariantDatabaseTable(value, fullData, endian);
  }

  ByteData? _lookup(String key, {required String type}) {
    var hash = _hashKey(key);
    var bucket = hash % _nBuckets;
    var start = data.getUint32(_bucketOffset + bucket * 4, endian);
    var end = bucket + 1 < _nBuckets
        ? data.getUint32(_bucketOffset + (bucket + 1) * 4, endian)
        : _nHashItems;
    start = 0;
    end = _nHashItems;

    for (var i = start; i < end; i++) {
      if (_getHash(i) == hash &&
          _getKey(i, recurse: true) == key &&
          _getType(i) == type) {
        return _getValue(i);
      }
    }

    return null;
  }

  /// Gets the hash for a table key.
  int _hashKey(String key) {
    var hashValue = 5381;
    for (var o in utf8.encode(key)) {
      // Use bytes as signed 8 bit numbers.
      if (o >= 128) {
        o -= 256;
      }
      hashValue = (hashValue * 33 + o) & 0xffffffff;
    }
    return hashValue;
  }

  int _getHash(int index) {
    return data.getUint32(_getHashItemOffset(index) + 0, endian);
  }

  int _getParent(int index) {
    return data.getUint32(_getHashItemOffset(index) + 4, endian);
  }

  /// Gets the key name for a hash item.
  String _getKey(int index, {bool recurse = false}) {
    var parent = recurse ? _getParent(index) : 0xffffffff;
    var parentKey =
        parent != 0xffffffff ? _getKey(parent, recurse: recurse) : '';

    var offset = _getHashItemOffset(index);
    var keyStart = data.getUint32(offset + 8, endian);
    var keySize = data.getUint16(offset + 12, endian);
    return parentKey + utf8.decode(data.buffer.asUint8List(keyStart, keySize));
  }

  String _getType(int index) {
    return ascii.decode([data.getUint8(_getHashItemOffset(index) + 14)]);
  }

  ByteData _getValue(int index) {
    var offset = _getHashItemOffset(index);

    var valueStart = data.getUint32(offset + 16, endian);
    var valueEnd = data.getUint32(offset + 20, endian);
    return ByteData.sublistView(fullData, valueStart, valueEnd);
  }

  int _getHashItemOffset(int index) {
    return _hashOffset + index * 24;
  }
}
