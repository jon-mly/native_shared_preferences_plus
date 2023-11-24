import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'native_shared_preferences_plus_platform_interface.dart';

/// An implementation of [NativeSharedPreferencesPlusPlatform] that uses method channels.
class MethodChannelNativeSharedPreferencesPlus
    extends NativeSharedPreferencesPlusPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('native_shared_preferences_plus');

  @override
  Future<void> setIOSAppGroup(String? appGroup) async {
    await methodChannel.invokeMethod<String>(
      'setAppGroup',
      <String, dynamic>{"appGroup": appGroup},
    );
  }

  @override
  Future<bool> remove(String key) async {
    return (await methodChannel.invokeMethod<bool>(
      'remove',
      <String, dynamic>{'key': key},
    ))!;
  }

  @override
  Future<bool> setValue(String valueType, String key, Object value) async {
    return (await methodChannel.invokeMethod<bool>(
      'set$valueType',
      <String, dynamic>{'key': key, 'value': value},
    ))!;
  }

  @override
  Future<bool> clear() async {
    return (await methodChannel.invokeMethod<bool>('clear'))!;
  }

  @override
  Future<Map<String, Object>> getAll() async {
    final Map<String, Object>? preferences =
        await methodChannel.invokeMapMethod<String, Object>('getAll');

    if (preferences == null) return <String, Object>{};
    return preferences;
  }

  @override
  Future<Map<String, Object>> getAllFromDictionary(List<String> keys) async {
    final Map<String, Object>? preferences =
        await methodChannel.invokeMapMethod<String, Object>(
      'getAllFromDictionary',
      <String, Object>{'keys': keys},
    );

    if (preferences == null) return <String, Object>{};

    return preferences;
  }
}
