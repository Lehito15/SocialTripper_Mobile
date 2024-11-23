abstract class NavigationState {}

class TabChangedState extends NavigationState {
  final int currentIndex;
  TabChangedState(this.currentIndex);
}