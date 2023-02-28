abstract class ControllerBase
{
  Future<bool> onServiceStart() async => true;
  Future<bool> onLoginChanged(bool isLogin) async => true;
  Future<bool> onCleanData() async => true;
  Future<bool> onServerState(Map<String, dynamic> state) async => true;
  Future<bool> onDeviceWake() async => true;
}