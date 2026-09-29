import 'package:tictac_duel/lib.dart';

class GameTextFormFieldWidget extends StatelessWidget {
  const GameTextFormFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.hintText,
    required this.validator,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction = TextInputAction.done,
    this.maxLength,
    this.keyboardType,
    this.suffixIcon,
    this.onChanged,
    this.onFieldSubmitted,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String hintText;
  final String? Function(String?)? validator;

  final TextCapitalization textCapitalization;
  final TextInputAction textInputAction;
  final int? maxLength;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      keyboardType: keyboardType,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      style: textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        hintStyle: textTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary.withValues(alpha: 0.4),
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: AppColors.card,
        border: _buildInputBorder(),
        enabledBorder: _buildInputBorder(),
        focusedBorder: _buildInputBorder(color: AppColors.neonPurple, width: 1.5),
        errorBorder: _buildInputBorder(color: AppColors.neonPink),
        focusedErrorBorder: _buildInputBorder(
          color: AppColors.neonPink,
          width: 1.5,
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: Dimens.eighteen,
          vertical: Dimens.sixteen,
        ),
      ),
    );
  }

  OutlineInputBorder _buildInputBorder({
    Color color = AppColors.border,
    double width = 1,
  }) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(Dimens.radiusMd),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
