import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class NetworkService {
  NetworkService({required this._connectivity});

  final Connectivity _connectivity;

  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  List<ConnectivityResult> _connectionStatus = const [];

  bool? _previousConnectionStatus;

  List<ConnectivityResult> get connectionStatus =>
      List.unmodifiable(_connectionStatus);

  bool get isConnectedValue =>
      _connectionStatus.isNotEmpty &&
      !_connectionStatus.contains(ConnectivityResult.none);

  Future<void> initialize() async {
    if (_connectivitySubscription != null) {
      return;
    }

    try {
      final result = await _connectivity.checkConnectivity();

      _connectionStatus = List.unmodifiable(result);
      _previousConnectionStatus = _hasConnection(result);

      _listen();
    } on PlatformException catch (error, stackTrace) {
      LoggerUtils.error('NetworkService.initialize', error, stackTrace);

      _connectionStatus = const [];
      _previousConnectionStatus = false;

      _listen();
    }
  }

  void _listen() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
      onError: (Object error, StackTrace stackTrace) {
        LoggerUtils.error('NetworkService._listen', error, stackTrace);
      },
    );
  }

  void _updateConnectionStatus(List<ConnectivityResult> result) {
    final connected = _hasConnection(result);

    _connectionStatus = List.unmodifiable(result);

    if (_previousConnectionStatus == connected) {
      return;
    }

    _previousConnectionStatus = connected;

    PopupUtils.showToast(
      connected ? 'Connected to the internet' : 'No internet connection',
    );
  }

  bool _hasConnection(List<ConnectivityResult> result) =>
      result.any((connection) => connection != ConnectivityResult.none);

  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();

      return _hasConnection(result);
    } on PlatformException catch (error, stackTrace) {
      LoggerUtils.error('NetworkService.isConnected', error, stackTrace);

      return false;
    }
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
    _connectivitySubscription = null;
  }
}
