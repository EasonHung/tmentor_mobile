import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:get/get.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart' as webrtc;

import '../../../../../service/foreground_service.dart';
import '../constraints.dart';

class MyClassroomMediaController extends GetxController {
  Rx<bool> showRemoteMedia = false.obs;
  Rx<bool> screenSharing = false.obs;
  Rx<bool> cameraSwitch = true.obs;
  Rx<bool> microphoneSwitch = true.obs;
  Rx<webrtc.RTCVideoRenderer> remoteStreamRenderer = webrtc.RTCVideoRenderer().obs;
  Rx<webrtc.RTCVideoRenderer> localStreamRenderer = webrtc.RTCVideoRenderer().obs;
  webrtc.MediaStream? localStream;
  webrtc.MediaStream? localDisplayStream;

  @override
  onInit() async {
    super.onInit();
    // initRenderers();
  }

  @override
  void onClose() {
    localStreamRenderer.value.srcObject = null;
    localStreamRenderer.value.dispose();
    remoteStreamRenderer.value.srcObject = null;
    remoteStreamRenderer.value.dispose();
    localStream?.dispose();
    localStream = null;
    localDisplayStream?.dispose();
    localDisplayStream = null;
    super.onClose();
  }

  void startMedia() {
    initRenderers();
  }

  void closeRemoteMedia() {
    showRemoteMedia.value = false;
    remoteStreamRenderer.value.srcObject = null;
  }

  void switchCameraStatus() {
    try{
      cameraSwitch.value = !cameraSwitch.value;
      localStream?.getVideoTracks()[0].enabled = cameraSwitch.value;
    } catch(e) {
      print(e.toString());
    }
  }

  void switchMicroPhoneStatus() {
    try{
      microphoneSwitch.value = !microphoneSwitch.value;
      localStream?.getAudioTracks()[0].enabled = microphoneSwitch.value;
    } catch(e) {
      print(e.toString());
    }
  }

  Future<List<MediaStreamTrack>?> onScreenSharing() async {
    ForegroundService.startService();

    if(localDisplayStream == null) {
      localDisplayStream = await webrtc.navigator.mediaDevices.getDisplayMedia({"video": true, "audio": microphoneSwitch.value});
    }
    localStreamRenderer.value.srcObject = localDisplayStream;

    screenSharing.value = true;
    return localDisplayStream?.getTracks();
  }

  Future<List<MediaStreamTrack>?> onStopScreenSharing() async {
    localDisplayStream?.dispose();
    localDisplayStream = null;

    screenSharing.value = false;
    localStreamRenderer.value.srcObject = localStream;

    ForegroundService.stopService();
    return localStream?.getTracks();
  }

  Future<void> initRenderers() async {
    await localStreamRenderer.value.initialize();
    await remoteStreamRenderer.value.initialize();

    if(localStream == null) {
      localStream = await webrtc.navigator.mediaDevices.getUserMedia(MyMediaConstraints.MEDIA_CONSTRAINTS);
    }

    localStreamRenderer.value.srcObject = localStream;
    localStreamRenderer.value = localStreamRenderer.value;// 讓obx detect到
  }

  List<webrtc.MediaStreamTrack>? getLocalStreamTracks() {
    return localStream?.getTracks();
  }

  void startRemoteVideo(webrtc.MediaStream stream) {
    showRemoteMedia.value = true;
    remoteStreamRenderer.value.srcObject = stream;
    remoteStreamRenderer.value = remoteStreamRenderer.value;
  }
}