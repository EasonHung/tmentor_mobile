// import 'dart:http';
import 'dart:convert';
import 'dart:io';

var _turnCredential;

class IceServers {
  String? _host;
  int? _turnPort;

  Map<String, dynamic> iceServers = {
    'iceServers': [
      {'url': 'stun:stun.l.google.com:19302'},
    ]
  };

  IceServers(String host, int turnPort) {
    this._host = host;
    this._turnPort = turnPort;
  }

  init() {
    this._requestIceServers(this._host!, this._turnPort!);
  }

  Future _requestIceServers(String host, int turnPort) async {
    if(_turnCredential == null) {
      // _turnCredential = await getTurnCredential(host, turnPort);

      iceServers = {
        'iceServers': [
          {'url': 'stun:stun.l.google.com:19302'},
        ]
      };
    }
  }
}

Future<Map> getTurnCredential(String host, int port) async {
  HttpClient client = HttpClient(context: SecurityContext());
  client.badCertificateCallback = (X509Certificate cert, String host, int port) {
    print("get turn cretencial 允許自簽名 => $host : $port");
    return true;
  };

  var url = "https://$host:$port/api/turn?service=turn&username=sample";
  print("turn server url: $url");
  var request = await client.getUrl(Uri.parse(url));
  var response = await request.close();
  var responseBody = await response.transform(Utf8Decoder()).join();
  print("turn server response: $responseBody");
  Map data = JsonDecoder().convert(responseBody);
  return data;
}