import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tictac_duel/lib.dart';

class JoinRoomScreen extends StatefulWidget {
  const JoinRoomScreen({super.key});

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  final _roomCodeController = TextEditingController();
  final _focusNode = FocusNode();

  String? get _roomCodeError {
    return ValidatorUtils.roomCode(_roomCodeController.text);
  }

  bool get _canJoin {
    return _roomCodeError == null;
  }

  @override
  void dispose() {
    _roomCodeController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: NeonBackgroundWidget(
        child: SafeArea(
          child: Column(
            children: [
              _buildAppBar(),

              Expanded(
                child: Stack(children: [_buildContent(), _buildJoinButton()]),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SizedBox(
      height: kToolbarHeight,
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_rounded,
              color: Themes.textPrimary,
            ),
          ),
          const Expanded(
            child: Text(
              'JOIN ROOM',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Themes.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 3,
              ),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 100),
      child: Column(
        spacing: 28,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          _buildRoomCodeCard(),
          _buildHint(),
          _buildDivider(),
          _buildCreateRoomButton(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      spacing: 12,
      children: [
        _buildHeaderIcon(),

        const Text(
          'FIND YOUR',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 4,
          ),
        ),

        const Text(
          'DUEL',
          style: TextStyle(
            color: Themes.textPrimary,
            fontSize: 34,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            height: 0.9,
          ),
        ),

        const Text(
          'Enter the room code shared by your friend.',
          textAlign: TextAlign.center,
          style: TextStyle(color: Themes.textSecondary, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildHeaderIcon() {
    return Container(
      width: 76,
      height: 76,
      decoration: BoxDecoration(
        color: Themes.neonPurple.withValues(alpha: 0.07),
        shape: BoxShape.circle,
        border: Border.all(color: Themes.neonPurple.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: Themes.neonPurple.withValues(alpha: 0.10),
            blurRadius: 28,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.login_rounded,
        color: Themes.neonPurple,
        size: 34,
      ),
    );
  }

  Widget _buildRoomCodeCard() {
    final isValid = _canJoin;
    final hasText = _roomCodeController.text.isNotEmpty;

    final borderColor = isValid
        ? Themes.neonCyan.withValues(alpha: 0.7)
        : hasText
        ? Themes.neonPink.withValues(alpha: 0.5)
        : Themes.border;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Themes.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor, width: isValid ? 1.4 : 1),
        boxShadow: isValid
            ? [
                BoxShadow(
                  color: Themes.neonCyan.withValues(alpha: 0.08),
                  blurRadius: 24,
                ),
              ]
            : null,
      ),
      child: Column(
        spacing: 12,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ROOM CODE',
            style: TextStyle(
              color: Themes.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),

          TextField(
            controller: _roomCodeController,
            focusNode: _focusNode,
            autofocus: true,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.done,
            keyboardType: TextInputType.text,
            maxLength: 8,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
            ],
            style: const TextStyle(
              color: Themes.textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w800,
              letterSpacing: 5,
            ),
            decoration: InputDecoration(
              counterText: '',
              hintText: 'ENTER CODE',
              hintStyle: TextStyle(
                color: Themes.textSecondary.withValues(alpha: 0.4),
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.5,
              ),
              suffixIcon: IconButton(
                onPressed: _pasteCode,
                tooltip: 'Paste room code',
                icon: const Icon(
                  Icons.content_paste_rounded,
                  color: Themes.neonCyan,
                  size: 20,
                ),
              ),
              filled: true,
              fillColor: Themes.card,
              border: _buildInputBorder(),
              enabledBorder: _buildInputBorder(),
              focusedBorder: _buildInputBorder(
                color: Themes.neonCyan,
                width: 1.5,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 17,
              ),
            ),
            onChanged: _onRoomCodeChanged,
            onSubmitted: (_) {
              if (_canJoin) {
                _joinRoom();
              }
            },
          ),
        ],
      ),
    );
  }

  OutlineInputBorder _buildInputBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color ?? Themes.border, width: width),
    );
  }

  Widget _buildHint() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 8,
      children: [
        const Icon(
          Icons.info_outline_rounded,
          color: Themes.textSecondary,
          size: 15,
        ),
        Text(
          'Use the 6–8 character code from your friend',
          style: TextStyle(
            color: Themes.textSecondary.withValues(alpha: 0.8),
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Row(
      spacing: 14,
      children: [
        Expanded(child: Container(height: 1, color: Themes.border)),
        const Text(
          'OR',
          style: TextStyle(
            color: Themes.textSecondary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
        Expanded(child: Container(height: 1, color: Themes.border)),
      ],
    );
  }

  Widget _buildCreateRoomButton() {
    return NeonOutlinedButtonWidget(
      label: 'CREATE YOUR OWN ROOM',
      icon: Icons.add_rounded,
      color: Themes.neonPurple,
      onPressed: Routes.replaceCreateRoom,
    );
  }

  Widget _buildJoinButton() {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 12,
      child: NeonElevatedButton(
        label: 'JOIN DUEL',
        icon: Icons.sports_esports_rounded,
        onPressed: _canJoin ? _joinRoom : null,
      ),
    );
  }

  void _onRoomCodeChanged(String value) {
    final formatted = value.toUpperCase();

    if (formatted != value) {
      _roomCodeController.value = _roomCodeController.value.copyWith(
        text: formatted,
        selection: TextSelection.collapsed(offset: formatted.length),
      );
    }

    setState(() {});
  }

  Future<void> _pasteCode() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final code = data?.text?.trim().toUpperCase();

    if (code == null || code.isEmpty) {
      return;
    }

    _roomCodeController.text = code.length > 8 ? code.substring(0, 8) : code;

    _focusNode.requestFocus();
    setState(() {});
  }

  void _joinRoom() {
    final roomCode = _roomCodeController.text.trim().toUpperCase();

    if (ValidatorUtils.roomCode(roomCode) != null) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Joining room $roomCode...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
