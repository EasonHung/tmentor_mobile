import 'package:mentor_app_flutter/objectbox.g.dart';

class ObjectBox {
  static Store? store;

  static Future<Store> getStore() async {
    if (store == null) {
      store = await openStore();
    }
    return store!;
  }
}
