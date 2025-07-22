import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SubScreen {
  none,
  weightRecord,
  camera,
  manualMealEntry,
  exerciseEntry,
}

class NavigationState {
  final int mainIndex;
  final SubScreen subScreen;
  final VoidCallback? onSubmit;
  
  NavigationState({
    required this.mainIndex,
    required this.subScreen,
    this.onSubmit,
  });
  
  NavigationState copyWith({
    int? mainIndex,
    SubScreen? subScreen,
    VoidCallback? onSubmit,
  }) {
    return NavigationState(
      mainIndex: mainIndex ?? this.mainIndex,
      subScreen: subScreen ?? this.subScreen,
      onSubmit: onSubmit ?? this.onSubmit,
    );
  }
}

class NavigationNotifier extends StateNotifier<NavigationState> {
  NavigationNotifier() : super(NavigationState(mainIndex: 0, subScreen: SubScreen.none));
  
  void setMainIndex(int index) {
    state = state.copyWith(mainIndex: index, subScreen: SubScreen.none);
  }
  
  void setSubScreen(SubScreen screen, {VoidCallback? onSubmit}) {
    state = state.copyWith(subScreen: screen, onSubmit: onSubmit);
  }
  
  void clearSubScreen() {
    state = state.copyWith(subScreen: SubScreen.none, onSubmit: null);
  }
}

final navigationProvider = StateNotifierProvider<NavigationNotifier, NavigationState>((ref) {
  return NavigationNotifier();
});