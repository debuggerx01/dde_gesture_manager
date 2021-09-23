extension StringNotNull on String? {
  bool get notNull => this != null && this != '';
}