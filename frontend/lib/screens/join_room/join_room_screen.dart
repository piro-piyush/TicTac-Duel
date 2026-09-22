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
  final _playerNameController = TextEditingController();
  final _playerNameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _roomCodeController.dispose();
    _playerNameController.dispose();

    _focusNode.dispose();
    _playerNameFocusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NeonBackgroundWidget(
      needScroll: false,
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

  void _generateRandomName() {
    _playerNameController.text = GameNameUtils.random();

    _playerNameController.selection = TextSelection.collapsed(
      offset: _playerNameController.text.length,
    );

    _playerNameFocusNode.requestFocus();

    _formKey.currentState?.validate();

    setState(() {});
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: Dimens.defaultPadding,
      child: Column(
        spacing: 28,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          JoinRoomHeaderWidget(),
          Form(
            key: _formKey,
            child: Column(
              spacing: 20,
              children: [_buildPlayerNameField(), _buildRoomCodeField()],
            ),
          ),
          JoinRoomHintWidget(),
          _buildDivider(),
          _buildCreateRoomButton(),
        ],
      ),
    );
  }

  Widget _buildPlayerNameField() {
    return TextFormField(
      controller: _playerNameController,
      focusNode: _playerNameFocusNode,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      maxLength: 20,
      validator: ValidatorUtils.gameName,
      onFieldSubmitted: (_) {
        _focusNode.requestFocus();
      },
      style: const TextStyle(
        color: Themes.textPrimary,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      decoration: _buildInputDecoration(
        hintText: 'ENTER YOUR NAME',
        focusedColor: Themes.neonPurple,
        suffixIcon: IconButton(
          onPressed: _generateRandomName,
          tooltip: 'Random name',
          icon: const Icon(
            Icons.casino_outlined,
            color: Themes.neonPurple,
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildRoomCodeField() {
    return TextFormField(
      controller: _roomCodeController,
      focusNode: _focusNode,
      autofocus: true,
      textCapitalization: TextCapitalization.characters,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      maxLength: 8,
      validator: ValidatorUtils.roomCode,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')),
      ],
      onChanged: (value) {
        final formatted = value.toUpperCase();

        if (formatted != value) {
          _roomCodeController.value = _roomCodeController.value.copyWith(
            text: formatted,
            selection: TextSelection.collapsed(offset: formatted.length),
          );
        }
      },
      onFieldSubmitted: (_) => _joinRoom(),
      style: const TextStyle(
        color: Themes.textPrimary,
        fontSize: 23,
        fontWeight: FontWeight.w800,
        letterSpacing: 5,
      ),
      decoration: _buildInputDecoration(
        hintText: 'ENTER CODE',
        focusedColor: Themes.neonCyan,
        suffixIcon: IconButton(
          onPressed: _pasteCode,
          icon: const Icon(
            Icons.content_paste_rounded,
            color: Themes.neonCyan,
            size: 20,
          ),
        ),
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    required Color focusedColor,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      counterText: '',
      hintText: hintText,
      hintStyle: TextStyle(
        color: Themes.textSecondary.withValues(alpha: 0.4),
        fontSize: 13,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.5,
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Themes.card,
      border: _buildInputBorder(),
      enabledBorder: _buildInputBorder(),
      focusedBorder: _buildInputBorder(color: focusedColor, width: 1.5),
      errorBorder: _buildInputBorder(color: Themes.neonPink),
      focusedErrorBorder: _buildInputBorder(color: Themes.neonPink, width: 1.5),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
    );
  }

  OutlineInputBorder _buildInputBorder({Color? color, double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: color ?? Themes.border, width: width),
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
        onPressed: _joinRoom,
      ),
    );
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
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final playerName = _playerNameController.text.trim();
    final roomCode = _roomCodeController.text.trim().toUpperCase();

    RoomSocketService.instance.joinRoom(
      playerName: playerName,
      roomCode: roomCode,
    );
  }
}
