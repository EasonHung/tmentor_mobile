
import 'dart:io';

import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

class NetworkUtil {
  static Future<bool> hasConnectedToNetwork() async {
    return InternetConnectionChecker().hasConnection;
  }

  static Future<String> downloadFileAndGetPath(String fileName, String url) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/fileName';
    final response = await http.get(Uri.parse(url));
    final file = File(filePath);

    await file.writeAsBytes(response.bodyBytes);
    return filePath;
  }
}