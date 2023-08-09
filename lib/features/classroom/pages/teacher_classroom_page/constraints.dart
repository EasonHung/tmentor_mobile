class MyMediaConstraints {
  // static const Map<String, dynamic> MEDIA_CONSTRAINTS = {
  //   "audio": false,
  //   "video": {
  //     "mandatory": {
  //       "minWidth": '1920',
  //
  //       "minHeight": '1080',
  //
  //       "minFrameRate": '30',
  //     },
  //     "facingMode": "user",
  //     "optional": [],
  //   }
  // };
  static const Map<String, dynamic> MEDIA_CONSTRAINTS = {
    "audio": true,
    "video": true
  };

  // PeerConnection constraints
  static const Map<String, dynamic> PC_CONSTRAINTS = {
    'mandatory': {},
    'optional': [
      // is neccesary when connect to web
      {'DtlsSrtpKeyAgreement': true},
    ],
  };

  // SDP constraints
  static const Map<String, dynamic> SDP_CONSTRAINTS = {
    'mandatory': {
      'OfferToReceiveAudio': true,
      'OfferToReceiveVideo': true,
    },
    "optional": [],
  };

}