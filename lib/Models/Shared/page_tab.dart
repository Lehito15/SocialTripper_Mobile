class PageTab<T> {
  String name;
  bool Function(T) filterPredicate;

  PageTab(this.name, this.filterPredicate);
}