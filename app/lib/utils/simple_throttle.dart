import 'dart:collection';

import 'package:collection/collection.dart';

class _SimpleThrottleNode {
  int funcHashCode;
  int timestamp;

  _SimpleThrottleNode(this.funcHashCode, this.timestamp);
}

typedef void _VoidFunc();

final _simpleThrottleQueue = Queue();

/// Usage: If you have a function : test(int n) => n;
/// you can use SimpleThrottle.throttledFunc(test)?.call(1) to make it throttled
/// this will return function's return value if last call time over the timeout
/// otherwise this will return null.
/// If your function is a 'void function()', you can use SimpleThrottle.invoke(func) to call it throttled,
/// and you can get a throttled function by SimpleThrottle.bind(func) if you do not call it immediately.
class SimpleThrottle {
  static T? throttledFunc<T extends Function>(T func,
      {String? funcKey, Duration timeout = const Duration(seconds: 1)}) {
    var node = _simpleThrottleQueue.firstWhereOrNull((element) => element.funcHashCode == (funcKey ?? func).hashCode);
    if (node != null) {
      if (DateTime.now().millisecondsSinceEpoch - node.timestamp < timeout.inMilliseconds)
        return null;
      else
        node.timestamp = DateTime.now().millisecondsSinceEpoch;
    } else {
      _simpleThrottleQueue.add(_SimpleThrottleNode((funcKey ?? func).hashCode, DateTime.now().millisecondsSinceEpoch));
      while (_simpleThrottleQueue.length > 16) {
        _simpleThrottleQueue.removeFirst();
      }
    }
    return func;
  }

  static void invoke(_VoidFunc func, {String? funcKey, Duration timeout = const Duration(seconds: 1)}) =>
      throttledFunc(func, timeout: timeout, funcKey: funcKey)?.call();

  static _VoidFunc bind(_VoidFunc func, {String? funcKey, Duration timeout = const Duration(seconds: 1)}) =>
      () => invoke(func, timeout: timeout, funcKey: funcKey);
}
