extension SoutExtension on Object? {
  void sout() {
    switch (this.runtimeType) {
      case String:
        return print(this);
      case Null:
        return print(null);
      case List:
        return print('[${(this as List).join(', ')}]');
      default:
        return print(this.toString());
    }
  }
}
