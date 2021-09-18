extension SoutExtension on Object? {
  void sout() {
    switch (this.runtimeType) {
      case String:
        return print(this);
      case Null:
        return print(null);
      default:
        return print(this.toString());
    }
  }
}
