import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mentor_app_flutter/vo/post_item.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../../../../apiManager/evaluationApiManager.dart';
import '../../../../apiManager/userApiManager.dart';
import '../../../../sharedPrefs/cardPrefs.dart';
import '../../../../sharedPrefs/userPrefs.dart';
import '../../../../vo/mentor_item.dart';
import '../providers/mentor_card_loading_state.dart';
import '../providers/mentor_card_provider.dart';

class MentorCardController {
  WidgetRef ref;
  int page = 0;
  List<String>? selectedFields;
  List<String>? selectedGender;

  MentorCardController(this.ref);

  Future<void> getMentorItemsFromServer() async {
    ref.read(mentorCardLoadingProvider.notifier).state = true;

    if (page == 0) {
      ref.read(mentorCardListProvider.notifier).state = [];
    }
    String? userId = await UserPrefs.getUserId();
    if(userId == null) {
      return;
    }

    selectedFields = (await CardPrefs.getFilterFields(userId!));
    selectedGender = (await CardPrefs.getFilterGender(userId));

    List<MentorItem> responseDataList =
    await userApiManager.getUserCardsWithFilter(page, selectedFields!, selectedGender!);


    for (int i = 0; i < responseDataList.length; i++) {
      dynamic postInfo = await evaluationApiManager.getUserPosts(responseDataList[i].userId!, 0);
      if (postInfo == null || postInfo["posts"].length == 0) continue;
      responseDataList[i].postCount = postInfo["totalCount"];
      responseDataList[i].evaluationScore =
      postInfo["averageScore"] is int ? postInfo["averageScore"].toDouble : postInfo["averageScore"];
      responseDataList[i].postList = (postInfo["posts"] as List).map((value) => EvaluationItem.fromJson(value)).cast<EvaluationItem>().toList();
    }

    ref.read(mentorCardLoadingProvider.notifier).state = false;
    checkEmptyByResponseList(responseDataList);
    addToSwipeItem(responseDataList);
  }

  Future<void> addToSwipeItem(List<MentorItem> mentorItemList) async {
    String? userId = await UserPrefs.getUserId();
    List<SwipeItem> swipeItemList = ref.read(mentorCardListProvider);

    for (int i = 0; i < mentorItemList.length; i++) {
      swipeItemList.add(SwipeItem(
          content: mentorItemList[i],
          likeAction: () {
            Future.delayed(const Duration(milliseconds: 1000), () async {
              swipeItemList.removeAt(0);
              checkEmpty(swipeItemList);
              await CardPrefs.putRetainCard(userId!, mentorItemList[i]);
              ref.watch(mentorCardMatchEngineProvider.notifier).state = MatchEngine(swipeItems: swipeItemList);
              print("保留");
            });
            // Future.delayed(const Duration(seconds: 1), () => swipeItemList.removeAt(i));
          },
          nopeAction: () {
            Future.delayed(const Duration(milliseconds: 1000), () {
              swipeItemList.removeAt(0);
              checkEmpty(swipeItemList);
              ref.watch(mentorCardMatchEngineProvider.notifier).state = MatchEngine(swipeItems: swipeItemList);
              print("丟棄");
            });
          },
          superlikeAction: () async {},
          onSlideUpdate: (region) async {
            if (cardAnimationVariables.fingerUp) return;
            cardAnimationVariables.cardDragged = true;
          }
        )
      );
    }

    ref.watch(mentorCardListProvider.notifier).state = swipeItemList;
    ref.watch(mentorCardMatchEngineProvider.notifier).state = MatchEngine(swipeItems: swipeItemList);
  }

  void checkEmpty(List<SwipeItem> cardList) {
    if(cardList.isEmpty) {
      ref.read(mentorCardEmptyProvider.notifier).state = true;
    } else {
      ref.read(mentorCardEmptyProvider.notifier).state = false;
    }
  }

  void checkEmptyByResponseList(List<MentorItem> cardList) {
    if(cardList.isEmpty) {
      ref.read(mentorCardEmptyProvider.notifier).state = true;
    } else {
      ref.read(mentorCardEmptyProvider.notifier).state = false;
    }
  }

  Future<void> changeCards() async {
    String? userId = await UserPrefs.getUserId();
    selectedFields = await CardPrefs.getFilterFields(userId!);
    selectedGender = await CardPrefs.getFilterGender(userId);

    List<MentorItem> responseDataList =
    await userApiManager.getUserCardsWithFilter(page, selectedFields!, selectedGender!);

    for (int i = 0; i < responseDataList.length; i++) {
      dynamic postInfo = await evaluationApiManager.getUserPosts(responseDataList[i].userId!, 0);
      if (postInfo == null || postInfo["posts"].length == 0) continue;
      responseDataList[i].postCount = postInfo["totalCount"];
      responseDataList[i].evaluationScore = postInfo["averageScore"];
      responseDataList[i].postList = (postInfo["posts"] as List).map((value) => EvaluationItem.fromJson(value)).toList();
    }

    ref.read(mentorCardListProvider.notifier).state.clear();
    checkEmptyByResponseList(responseDataList);
    addToSwipeItem(responseDataList);
  }
}