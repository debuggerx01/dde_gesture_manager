import 'package:dbus/dbus.dart';

class GVariantTextCodec {
  GVariantTextCodec();

  /// Encode a value using GVariant text format.
  String encode(DBusValue value) {
    var buffer = StringBuffer();
    _encode(buffer, value);
    return buffer.toString();
  }

  /// Parse a single GVariant value. [type] is expected to be a valid single type.
  DBusValue decode(String type, String data) {
    var buffer = _DecodeBuffer(data);
    var value = _decode(type, buffer);
    buffer.consumeWhitespace();
    if (!buffer.isEmpty) {
      throw "Unexpected data after encoded GVariant: '${buffer.data.substring(buffer.offset)}'";
    }
    return value;
  }

  void _encode(StringBuffer buffer, DBusValue value) {
    if (value is DBusBoolean) {
      buffer.write(value.value ? 'true' : 'false');
    } else if (value is DBusByte) {
      buffer.write('0x' + value.value.toRadixString(16).padLeft(2, '0'));
    } else if (value is DBusInt16) {
      buffer.write(value.value.toString());
    } else if (value is DBusUint16) {
      buffer.write(value.value.toString());
    } else if (value is DBusInt32) {
      buffer.write(value.value.toString());
    } else if (value is DBusUint32) {
      buffer.write(value.value.toString());
    } else if (value is DBusInt64) {
      buffer.write(value.value.toString());
    } else if (value is DBusUint64) {
      buffer.write(value.value.toString());
    } else if (value is DBusDouble) {
      buffer.write(value.value.toString());
    } else if (value is DBusObjectPath) {
      buffer.write('objectpath ');
      _writeString(buffer, value.value);
    } else if (value is DBusSignature) {
      buffer.write('signature ');
      _writeString(buffer, value.value);
    } else if (value is DBusString) {
      _writeString(buffer, value.value);
    } else if (value is DBusVariant) {
      buffer.write('<');
      _encode(buffer, value.value);
      buffer.write('>');
    } else if (value is DBusMaybe) {
      if (value.value != null) {
        var childBuffer = StringBuffer();
        _encode(childBuffer, value.value!);
        var childText = childBuffer.toString();
        if (childText.endsWith('nothing')) {
          buffer.write('just ');
        }
        buffer.write(childText);
      } else {
        buffer.write('nothing');
      }
    } else if (value is DBusStruct) {
      buffer.write('(');
      for (var child in value.children) {
        if (child != value.children.first) {
          buffer.write(', ');
        }
        _encode(buffer, child);
      }
      buffer.write(')');
    } else if (value is DBusArray) {
      buffer.write('[');
      for (var child in value.children) {
        if (child != value.children.first) {
          buffer.write(', ');
        }
        _encode(buffer, child);
      }
      buffer.write(']');
    } else if (value is DBusDict) {
      buffer.write('{');
      var first = true;
      for (var entry in value.children.entries) {
        if (!first) {
          buffer.write(', ');
        }
        first = false;
        _encode(buffer, entry.key);
        buffer.write(': ');
        _encode(buffer, entry.value);
      }
      buffer.write('}');
    } else {
      throw ("Unsupported DBus type: '$value'");
    }
  }

  void _writeString(StringBuffer buffer, String value) {
    var quote = value.contains("'") ? '"' : "'";
    buffer.write(quote);
    for (var rune in value.runes) {
      switch (rune) {
        case 7: // bell
          buffer.write(r'\a');
          break;
        case 8: // backspace
          buffer.write(r'\b');
          break;
        case 9: // tab
          buffer.write(r'\t');
          break;
        case 10: // newline
          buffer.write(r'\n');
          break;
        case 11: // vertical tab
          buffer.write(r'\v');
          break;
        case 12: // form feed
          buffer.write(r'\f');
          break;
        case 13: // carriage return
          buffer.write(r'\r');
          break;
        case 34: // double quote
          buffer.write(quote == '"' ? r'\"' : '"');
          break;
        case 39: // single quote
          buffer.write(quote == "'" ? r"\'" : "'");
          break;
        case 92: // backslash
          buffer.write(r'\\');
          break;
        default:
          // There's not a dart method to check if a character is "printable", so we use:
          //     00 -      1f - C0 control
          //     7f           - delete
          //     80 -      9f - C1 control
          //   e000 -    f8ff - private use
          //   fff0 -    ffff - specials
          //  1ff80 -   1ffff - unassigned
          //  2ff80 -   2ffff - unassigned
          //  3ff80 -   3ffff - unassigned
          //  4ff80 -   4ffff - unassigned
          //  5ff80 -   5ffff - unassigned
          //  6ff80 -   6ffff - unassigned
          //  7ff80 -   7ffff - unassigned
          //  8ff80 -   8ffff - unassigned
          //  9ff80 -   9ffff - unassigned
          //  aff80 -   affff - unassigned
          //  bff80 -   bffff - unassigned
          //  cff80 -   cffff - unassigned
          //  dff80 -   dffff - unassigned
          //  eff80 -   effff - unassigned
          //  f0000 -   fffff - supplementary private use area A
          // 100000 -  10fffd - supplementary private use area B
          if (rune <= 0x1f ||
              (rune >= 0x7f && rune <= 0x9f) ||
              (rune >= 0xe000 && rune <= 0xf8ff) ||
              (rune >= 0xfff0 && rune <= 0xffff) ||
              (rune >= 0x1ff80 && rune <= 0x1ffff) ||
              (rune >= 0x2ff80 && rune <= 0x2ffff) ||
              (rune >= 0x3ff80 && rune <= 0x3ffff) ||
              (rune >= 0x4ff80 && rune <= 0x4ffff) ||
              (rune >= 0x5ff80 && rune <= 0x5ffff) ||
              (rune >= 0x6ff80 && rune <= 0x6ffff) ||
              (rune >= 0x7ff80 && rune <= 0x7ffff) ||
              (rune >= 0x8ff80 && rune <= 0x8ffff) ||
              (rune >= 0x9ff80 && rune <= 0x9ffff) ||
              (rune >= 0xaff80 && rune <= 0xaffff) ||
              (rune >= 0xbff80 && rune <= 0xbffff) ||
              (rune >= 0xcff80 && rune <= 0xcffff) ||
              (rune >= 0xdff80 && rune <= 0xdffff) ||
              (rune >= 0xeff80 && rune <= 0xeffff) ||
              (rune >= 0x100000 && rune <= 0x10fffd)) {
            int padding;
            String prefix;
            if (rune <= 0xffff) {
              padding = 4;
              prefix = 'u';
            } else {
              padding = 8;
              prefix = 'U';
            }
            var hex = rune.toRadixString(16).padLeft(padding, '0');
            buffer.write('\\$prefix$hex');
          } else {
            buffer.writeCharCode(rune);
          }
      }
    }
    buffer.write(quote);
  }

  DBusValue _decode(String type, _DecodeBuffer buffer) {
    buffer.consumeWhitespace();

    // struct
    if (type.startsWith('(')) {
      return _decodeStruct(type, buffer);
    }

    // array / dict
    if (type.startsWith('a')) {
      if (type.startsWith('a{')) {
        return _decodeDict(type, buffer);
      } else {
        return _decodeArray(type, buffer);
      }
    }

    // maybe
    if (type.startsWith('m')) {
      var childType = type.substring(1);
      DBusValue? value;
      if (!buffer.consume('nothing')) {
        value = _decode(childType, buffer);
      }
      return DBusMaybe(DBusSignature(childType), value);
    }

    switch (type) {
      case 'b': // boolean
        bool value;
        if (buffer.consume('true')) {
          value = true;
        } else if (buffer.consume('false')) {
          value = false;
        } else {
          throw 'Invalid boolean encoding';
        }
        return DBusBoolean(value);
      case 'y': // byte
        return DBusByte(_decodeInteger(buffer));
      case 'n': // int16
        return DBusInt16(_decodeInteger(buffer));
      case 'q': // uint16
        return DBusUint16(_decodeInteger(buffer));
      case 'i': // int32
        return DBusInt32(_decodeInteger(buffer));
      case 'u': // uint32
        return DBusUint32(_decodeInteger(buffer));
      case 'x': // int64
        return DBusInt64(_decodeInteger(buffer));
      case 't': // uint64
        return DBusUint64(_decodeInteger(buffer));
      case 'd': // double
        return DBusDouble(_decodeDouble(buffer));
      case 's': // string
        return DBusString(_decodeString(buffer));
      case 'o': // object path
        if (!buffer.consume('objectpath ')) {
          throw 'Invalid object path encoding';
        }
        return DBusObjectPath(_decodeString(buffer));
      case 'g': // signature
        if (!buffer.consume('signature ')) {
          throw 'Invalid signature encoding';
        }
        return DBusSignature(_decodeString(buffer));
      default:
        throw ("Unsupported GVariant type: '$type'");
    }
  }

  int _decodeInteger(_DecodeBuffer buffer) {
    var end = buffer.offset;
    if (buffer.data.startsWith('-')) {
      end++;
    } else if (buffer.data.startsWith('0x')) {
      end += 2;
    }
    while (end < buffer.data.length &&
        '0123456789abcdefABCDEF'.contains(buffer.data[end])) {
      end++;
    }

    var value = int.parse(buffer.data.substring(buffer.offset, end));
    buffer.offset = end;
    return value;
  }

  double _decodeDouble(_DecodeBuffer buffer) {
    var end = buffer.offset;
    if (buffer.data.startsWith('-', end)) {
      end++;
    }
    while (
        end < buffer.data.length && '0123456789'.contains(buffer.data[end])) {
      end++;
    }
    if (buffer.data.startsWith('.', end)) {
      end++;
    }
    while (
        end < buffer.data.length && '0123456789'.contains(buffer.data[end])) {
      end++;
    }

    var value = double.parse(buffer.data.substring(buffer.offset, end));
    buffer.offset = end;
    return value;
  }

  String _decodeString(_DecodeBuffer buffer) {
    var output = StringBuffer();
    if (buffer.isEmpty) {
      throw 'No data for string';
    }
    var quote = buffer.data[buffer.offset];
    if (quote != "'" && quote != '"') {
      throw 'Missing start quote on string';
    }
    var end = buffer.offset + 1;
    while (end < buffer.data.length) {
      var c = buffer.data[end];
      end++;
      if (c == quote) {
        buffer.offset = end;
        return output.toString();
      } else if (c == r'\') {
        if (end == buffer.data.length - 1) {
          throw 'Escape character at end of string';
        }
        var escapeChar = buffer.data[end];
        end++;
        switch (escapeChar) {
          case 'a': // bell
            output.writeCharCode(7);
            break;
          case 'b': // backspace
            output.writeCharCode(8);
            break;
          case 't': // tab
            output.writeCharCode(9);
            break;
          case 'n': // newline
            output.writeCharCode(10);
            break;
          case 'v': // vertical tab
            output.writeCharCode(11);
            break;
          case 'f': // form feed
            output.writeCharCode(12);
            break;
          case 'r': // carriage return
            output.writeCharCode(13);
            break;
          case 'u':
            if (end + 4 > buffer.data.length) {
              throw ('Not enough space for unicode character');
            }
            output.writeCharCode(
                int.parse(buffer.data.substring(end, end + 4), radix: 16));
            end += 4;
            break;
          case 'U':
            if (end + 8 > buffer.data.length) {
              throw ('Not enough space for unicode character');
            }
            output.writeCharCode(
                int.parse(buffer.data.substring(end, end + 8), radix: 16));
            end += 8;
            break;
          case '"':
          case "'":
          case r'\':
          default:
            output.write(escapeChar);
            break;
        }
      } else {
        output.write(c);
      }
    }

    throw 'Missing end quote on string';
  }

  DBusStruct _decodeStruct(String type, _DecodeBuffer buffer) {
    if (!buffer.consume('(')) {
      throw 'Missing start of struct';
    }
    var signature = DBusSignature(type.substring(1, type.length - 1));
    var children = <DBusValue>[];
    var first = true;
    for (var childSignature in signature.split()) {
      if (!first && !buffer.consume(',')) {
        throw ('Missing comma between struct elements');
      }
      first = false;
      buffer.consumeWhitespace();
      children.add(_decode(childSignature.value, buffer));
    }
    if (!buffer.consume(')')) {
      throw 'Missing end of struct';
    }
    return DBusStruct(children);
  }

  DBusArray _decodeArray(String type, _DecodeBuffer buffer) {
    if (!buffer.consume('[')) {
      throw 'Missing start of array';
    }
    var childType = type.substring(1);
    var children = <DBusValue>[];
    var first = true;
    while (!buffer.isEmpty) {
      if (buffer.consume(']')) {
        return DBusArray(DBusSignature(childType), children);
      }

      if (!first && !buffer.consume(',')) {
        throw ('Missing comma between array elements');
      }
      first = false;
      buffer.consumeWhitespace();
      children.add(_decode(childType, buffer));
    }
    throw 'Missing end of array';
  }

  DBusDict _decodeDict(String type, _DecodeBuffer buffer) {
    var signatures = DBusSignature(type.substring(2, type.length - 1)).split();
    var keyType = signatures[0].value;
    var valueType = signatures[1].value;
    if (!buffer.consume('{')) {
      throw 'Missing start of dict';
    }
    var children = <DBusValue, DBusValue>{};
    var first = true;
    while (!buffer.isEmpty) {
      if (buffer.consume('}')) {
        return DBusDict(
            DBusSignature(keyType), DBusSignature(valueType), children);
      }

      if (!first && !buffer.consume(',')) {
        throw ('Missing comma between dict elements');
      }
      first = false;
      buffer.consumeWhitespace();

      var key = _decode(keyType, buffer);
      buffer.consumeWhitespace();
      if (!first && !buffer.consume(':')) {
        throw ('Missing colon between dict key and value');
      }
      buffer.consumeWhitespace();
      var value = _decode(valueType, buffer);

      children[key] = value;
    }
    throw 'Missing end of dict';
  }
}

class _DecodeBuffer {
  String data;
  int offset = 0;

  _DecodeBuffer(this.data);

  bool get isEmpty => offset >= data.length;

  void consumeWhitespace() {
    while (offset < data.length && data.startsWith(' ', offset)) {
      offset++;
    }
  }

  bool consume(String value) {
    if (!data.startsWith(value, offset)) {
      return false;
    }

    offset += value.length;
    return true;
  }
}
