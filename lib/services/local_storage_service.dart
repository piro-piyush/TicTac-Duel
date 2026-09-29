import 'package:tictac_duel/lib.dart';

class LocalStorageService {
  const LocalStorageService({required this._storage});

  final FlutterSecureStorage _storage;

  static final _iOSOptions = IOSOptions(
    accessibility: KeychainAccessibility.first_unlock,
  );

  static final _androidOptions = AndroidOptions(
    storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
  );

  Future<String?> getString(String key) async {
    try {
      return await _storage.read(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to get string: $key', error, stackTrace);
      return null;
    }
  }

  Future<bool> setString(String key, String value) async {
    try {
      await _storage.write(
        key: key,
        value: value,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to set string: $key', error, stackTrace);
      return false;
    }
  }

  Future<bool?> getBool(String key) async {
    try {
      final value = await _storage.read(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );

      if (value == null) {
        return null;
      }

      return value.toLowerCase() == 'true';
    } catch (error, stackTrace) {
      LoggerUtils.error(
        'Failed to get bool: $key',
        error,
        stackTrace,
      );
      return null;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      await _storage.write(
        key: key,
        value: value.toString(),
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to set bool: $key', error, stackTrace);
      return false;
    }
  }

  Future<int?> getInt(String key) async {
    try {
      final value = await _storage.read(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      return value == null ? null : int.tryParse(value);
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to get int: $key', error, stackTrace);
      return null;
    }
  }

  Future<bool> setInt(String key, int value) async {
    try {
      await _storage.write(
        key: key,
        value: value.toString(),
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to set int: $key', error, stackTrace);
      return false;
    }
  }

  Future<bool> remove(String key) async {
    try {
      await _storage.delete(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      return true;
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to remove: $key', error, stackTrace);
      return false;
    }
  }

  Future<bool> containsKey(String key) async {
    try {
      final value = await _storage.containsKey(
        key: key,
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
      return value;
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to check key: $key', error, stackTrace);
      return false;
    }
  }

  Future<void> clear() async {
    try {
      await _storage.deleteAll(
        iOptions: _iOSOptions,
        aOptions: _androidOptions,
      );
    } catch (error, stackTrace) {
      LoggerUtils.error('Failed to clear local storage', error, stackTrace);
    }
  }
}
