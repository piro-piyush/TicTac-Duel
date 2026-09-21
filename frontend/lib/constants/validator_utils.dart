class ValidatorUtils {
  ValidatorUtils._();

  // ---------------------------------------------------------------------------
  // Game
  // ---------------------------------------------------------------------------

  static String? roomCode(String? value) {
    final code = value?.trim() ?? '';

    if (code.isEmpty) {
      return 'Enter a room code';
    }

    if (!RegExp(r'^[A-Z0-9]{6,8}$').hasMatch(code.toUpperCase())) {
      return 'Enter a valid room code';
    }

    return null;
  }

  static String? gameName(String? value) {
    final name = value?.trim() ?? '';

    if (name.isEmpty) {
      return 'Enter a game name';
    }

    if (name.length < 3) {
      return 'Game name must be at least 3 characters';
    }

    if (name.length > 30) {
      return 'Game name must be 30 characters or less';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // UUID
  // ---------------------------------------------------------------------------

  static String? uuid(String? value) {
    final id = value?.trim() ?? '';

    if (id.isEmpty) {
      return 'UUID is required';
    }

    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-'
      r'[0-9a-fA-F]{4}-'
      r'[1-5][0-9a-fA-F]{3}-'
      r'[89abAB][0-9a-fA-F]{3}-'
      r'[0-9a-fA-F]{12}$',
    );

    if (!uuidRegex.hasMatch(id)) {
      return 'Enter a valid UUID';
    }

    return null;
  }

  // ---------------------------------------------------------------------------
  // Common
  // ---------------------------------------------------------------------------

  static String? required(String? value, {String fieldName = 'This field'}) {
    if (value?.trim().isEmpty ?? true) {
      return '$fieldName is required';
    }

    return null;
  }
}
