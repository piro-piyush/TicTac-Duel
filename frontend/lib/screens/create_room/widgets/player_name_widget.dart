import 'package:tictac_duel/lib.dart';

class PlayerNameWidget extends StatelessWidget {
  const PlayerNameWidget({
    super.key,
    required this._playerNameController,
    required this._playerNameFocusNode,
    required this.onPressed,
    required this.formKey,
  });

  final TextEditingController _playerNameController;

  final FocusNode _playerNameFocusNode;

  final VoidCallback onPressed;
  final GlobalKey<FormState> formKey;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: Dimens.eight,
        children: [
          SectionTitleWidget(title: 'YOUR NAME'),
          GameTextFormFieldWidget(
            controller: _playerNameController,
            focusNode: _playerNameFocusNode,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            validator: ValidatorUtils.gameName,
            hintText: 'ENTER YOUR NAME',
            suffixIcon: IconButton(
              onPressed: onPressed,
              tooltip: 'Random name',
              icon: const Icon(
                Icons.casino_outlined,
                color: Themes.neonPurple,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
