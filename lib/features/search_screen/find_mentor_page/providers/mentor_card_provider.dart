import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:swipe_cards/swipe_cards.dart';

final mentorCardListProvider = StateProvider.autoDispose<List<SwipeItem>>((ref) {
  return [];
});

final mentorCardShowBottomBtnProvider = StateProvider.autoDispose<bool>((ref) => true);

final mentorCardEmptyProvider = StateProvider.autoDispose<bool>((ref) => false);

final mentorCardMatchEngineProvider = StateProvider.autoDispose<MatchEngine>((ref){
  return MatchEngine(swipeItems: []);
});

final cardAnimationVariables = CardAnimationVariables();

class CardAnimationVariables {
  double cardPositionDx = 0;
  double cardPositionDy = 0;
  bool fingerUp = true;
  bool cardDragged = false;
}