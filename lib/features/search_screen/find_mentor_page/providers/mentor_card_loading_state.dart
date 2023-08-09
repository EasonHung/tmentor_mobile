import 'package:flutter_riverpod/flutter_riverpod.dart';

final mentorCardLoadingProvider = StateProvider.autoDispose<bool>((ref) {
  return true;
});