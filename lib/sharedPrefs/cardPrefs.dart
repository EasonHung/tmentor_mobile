import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../vo/mentor_item.dart';

class CardPrefs {
  static const RETAIN_CARD_PREFIX = "retain-card-";
  static const CARD_FILTER_FIELD = "card-filter-field-";
  static const CARD_FILTER_GENDER = "card-filter-gender-";

  static Future<List<MentorItem>> getRetainCards(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    List<String>? prefs = pref.getStringList(RETAIN_CARD_PREFIX + userId);
    return (prefs ?? []).map((str) => MentorItem.fromJson(jsonDecode(str))).toList();
  }

  static Future<List<MentorItem>> deleteRetainCardsByIndex(String userId, int index) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String>? cardsStrList = pref.getStringList(RETAIN_CARD_PREFIX + userId);
    if (cardsStrList == null) return [];

    cardsStrList.removeAt(index);
    pref.setStringList(RETAIN_CARD_PREFIX + userId, cardsStrList);
    return cardsStrList.map((cardStr) => MentorItem.fromJson(jsonDecode(cardStr))).toList();
  }

  static Future<void> putRetainCard(String userId, MentorItem card) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    List<String> remainCardList = pref.getStringList(RETAIN_CARD_PREFIX + userId) ?? [];

    for (String remainCardStr in remainCardList) {
      // 看不出來這個for loop 有何意義
      Map<String, dynamic> remainCardMap = jsonDecode(remainCardStr);
      if (remainCardMap['userId'] == card.userId) return;
    }

    remainCardList.add(jsonEncode(card));
    pref.setStringList(RETAIN_CARD_PREFIX + userId, remainCardList);
  }

  static Future<void> putFilterFields(String userId, List<String> fields) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(CARD_FILTER_FIELD + userId, fields);
  }

  static Future<List<String>> getFilterFields(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(CARD_FILTER_FIELD + userId) ?? [];
  }

  static Future<void> putFilterGender(String userId, List<String> gender) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setStringList(CARD_FILTER_GENDER + userId, gender);
  }

  static Future<List<String>> getFilterGender(String userId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    return pref.getStringList(CARD_FILTER_GENDER + userId) ?? [];
  }
}
