import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class NetworkService extends GetxController {

  final Connectivity _connectivity;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final RxList<ConnectivityResult> _connectionStatus =
      <ConnectivityResult>[].obs;

  bool _initialized = false;
  bool? _previousConnectionStatus;

  new({required this._connectivity});

  List<ConnectivityResult> get connectionStatus => _connectionStatus;

  bool get isConnectedValue =>
      _connectionStatus.isNotEmpty &&
      !_connectionStatus.contains(ConnectivityResult.none);

  @override
  void onInit() {
    super.onInit();

    _initialize();
  }

  Future<void> _initialize() async {
    try {
      final result = await _connectivity.checkConnectivity();

      _connectionStatus.value = result;
      _previousConnectionStatus = _hasConnection(result);
      _initialized = true;

      _listen();
    } on PlatformException catch (_) {
      _connectionStatus.clear();
      _previousConnectionStatus = false;
      _initialized = true;

      _listen();
    }
  }

  void _listen() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final connected = _hasConnection(result);

    _connectionStatus.value = result;

    if (!_initialized) {
      _previousConnectionStatus = connected;
      return;
    }

    if (_previousConnectionStatus == connected) {
      return;
    }

    _previousConnectionStatus = connected;

    if (connected) {
      PopupUtils.showToast('Connected to the internet');
    } else {
      PopupUtils.showToast('No internet connection');
    }
  }

  bool _hasConnection(List<ConnectivityResult> result) {
    return result.any((connection) => connection != ConnectivityResult.none);
  }

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();

      return _hasConnection(result);
    } on PlatformException catch (_) {
      return false;
    }
  }

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
