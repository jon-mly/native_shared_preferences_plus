import 'dart:async';

import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'native_shared_preferences_plus_method_channel.dart';

abstract class NativeSharedPreferencesPlusPlatform extends PlatformInterface {
  /// Constructs a NativeSharedPreferencesPlusPlatform.
  NativeSharedPreferencesPlusPlatform() : super(token: _token);

  static final Object _token = Object();

  static NativeSharedPreferencesPlusPlatform _instance = MethodChannelNativeSharedPreferencesPlus();

  /// The default instance of [NativeSharedPreferencesPlusPlatform] to use.
  ///
  /// Defaults to [MethodChannelNativeSharedPreferencesPlus].
  static NativeSharedPreferencesPlusPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NativeSharedPreferencesPlusPlatform] when
  /// they register themselves.
  static set instance(NativeSharedPreferencesPlusPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  /// Sets the [appGroup] to be used on iOS
  Future<void> setIOSAppGroup(String? appGroup);

  /// Removes the value associated with the [key].
  Future<bool> remove(String key);

  /// Stores the [value] associated with the [key].
  ///
  /// The [valueType] must match the type of [value] as follows:
  ///
  /// * Value type "Bool" must be passed if the value is of type `bool`.
  /// * Value type "Double" must be passed if the value is of type `double`.
  /// * Value type "Int" must be passed if the value is of type `int`.
  /// * Value type "String" must be passed if the value is of type `String`.
  /// * Value type "StringList" must be passed if the value is of type `List<String>`.
  Future<bool> setValue(String valueType, String key, Object value);

  /// Removes all keys and values in the store.
  Future<bool> clear();

  /// Returns all key/value pairs persisted in this store.
  Future<Map<String, Object>> getAll();

  /// Returns all key/value pairs persisted in this store.
  Future<Map<String, Object>> getAllFromDictionary(List<String> keys);
}
