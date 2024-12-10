class EntityOption {
  String name;
  Future<void> Function() onClick;

  EntityOption(this.name, this.onClick);
}