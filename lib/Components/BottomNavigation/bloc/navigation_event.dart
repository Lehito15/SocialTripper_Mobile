abstract class NavigationEvent {}

class ChangeTabEvent extends NavigationEvent {
  final int index;
  ChangeTabEvent(this.index);
}