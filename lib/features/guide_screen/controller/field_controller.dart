
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class FieldController extends GetxController {
  List<String> fieldsOptions = ["家教", "資訊", "設計", "商業/管理", "行銷/企劃", "運動/營養", "多媒體", "藝術", "人文", "其他"];
  RxList<bool> fieldsChecks = [false, false, false, false, false, false, false, false, false, false].obs;
  List<String> selectedField = [];

  void addSelectField(String field) {
    selectedField.add(field);
  }

  void removeSelectField(String field) {
    selectedField.removeWhere((element) => element == field);
  }

  bool checkSelectedFieldLength() {
    return selectedField.length < 3;
  }
}