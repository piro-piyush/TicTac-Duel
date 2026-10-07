import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

final joinRoomProvider =
    NotifierProvider.family<JoinRoomNotifier, JoinRoomState, String?>(
      JoinRoomNotifier.new,
    );

class JoinRoomNotifier extends Notifier<JoinRoomState> {
  JoinRoomNotifier(this.roomCode);

  final String? roomCode;

  late final RoomSocketService _roomSocketService;
  late final AppNavigation _navigation;

  late final GlobalKey<FormState> joinFormKey;

  late final TextEditingController playerNameController;
  late final FocusNode playerNameFocusNode;

  late final TextEditingController roomCodeController;
  late final FocusNode roomCodeFocusNode;

  @override
  JoinRoomState build() {
    _roomSocketService = ref.read(roomSocketServiceProvider);
    _navigation = ref.read(appNavigationProvider);

    joinFormKey = GlobalKey<FormState>();

    playerNameController = TextEditingController();
    playerNameFocusNode = FocusNode();

    roomCodeController = TextEditingController(
      text: roomCode?.trim().toUpperCase() ?? '',
    );
    roomCodeFocusNode = FocusNode();

    ref.onDispose(() {
      playerNameController.dispose();
      playerNameFocusNode.dispose();
      roomCodeController.dispose();
      roomCodeFocusNode.dispose();
    });

    return const JoinRoomState();
  }

  void generateRandomName() {
    final name = GameNameUtils.random();

    playerNameController
      ..text = name
      ..selection = TextSelection.collapsed(offset: name.length);

    playerNameFocusNode.requestFocus();
    joinFormKey.currentState?.validate();
  }

  Future<void> pasteRoomCode() async {
    final clipboard = await Clipboard.getData(Clipboard.kTextPlain);
    final code = clipboard?.text?.trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return;
    }

    if (ValidatorUtils.roomCode(code) != null) {
      return;
    }

    roomCodeController
      ..text = code
      ..selection = TextSelection.collapsed(offset: code.length);

    roomCodeFocusNode.requestFocus();
    joinFormKey.currentState?.validate();
  }

  Future<void> joinRoom() async {
    if (state.isJoining) {
      return;
    }

    if (!(joinFormKey.currentState?.validate() ?? false)) {
      return;
    }

    final code = roomCodeController.text.trim().toUpperCase();
    final name = playerNameController.text.trim();

    state = state.copyWith(isJoining: true, clearError: true);

    try {
      await _roomSocketService.connect();

      _roomSocketService.joinRoom(
        roomCode: code,
        name: name,
        onJoined: _handleRoomJoined,
        onError: _handleSocketError,
      );
    } catch (error, stackTrace) {
      _handleJoinError(error, stackTrace);
    }
  }

  void _handleRoomJoined(RoomJoinedResponse response) {
    state = state.copyWith(isJoining: false);

    _clearForm();
    _navigation.pushGame(response.room);
  }

  void _handleSocketError(String message) {
    state = state.copyWith(isJoining: false, errorMessage: message);

    PopupUtils.showError(message);
  }

  void _handleJoinError(Object error, StackTrace stackTrace) {
    final message = error is SocketException
        ? error.message
        : 'Failed to connect to the server.';

    if (error is! SocketException) {
      LoggerUtils.error('JoinRoomNotifier.joinRoom', error, stackTrace);
    }

    state = state.copyWith(isJoining: false, errorMessage: message);

    PopupUtils.showError(message);
  }

  void _clearForm() {
    playerNameController.clear();
    roomCodeController.clear();
    joinFormKey.currentState?.reset();
  }

  void clearError() {
    if (state.errorMessage == null) {
      return;
    }

    state = state.copyWith(clearError: true);
  }
}
