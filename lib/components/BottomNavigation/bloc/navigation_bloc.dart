import 'package:social_tripper_mobile/components/BottomNavigation/bloc/navigation_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(TabChangedState(0)) {
    on<ChangeTabEvent>((event, emit) {
      emit(TabChangedState(event.index));
    });
  }
}