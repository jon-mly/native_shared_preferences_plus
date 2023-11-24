import Flutter
import UIKit

public class NativeSharedPreferencesPlusPlugin: NSObject, FlutterPlugin {
  private var appGroup: String?

  init(appGroup: String?) {
      self.appGroup = appGroup
  }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "native_shared_preferences_plus", binaryMessenger: registrar.messenger())
    let instance = NativeSharedPreferencesPlusPlugin(appGroup: nil)
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    let method = call.method
    let arguments = call.arguments as? [String: Any] ?? [:]

    switch method {
    case "setAppGroup":
        appGroup = arguments["appGroup"] as? String
        result(true)
    case "getAll":
        result(Self.getAllPrefs())
    case "setBool":
        let key = arguments["key"] as? String ?? ""
        let value = arguments["value"] as? Bool ?? false
        getUserDefaults()?.set(value, forKey: key)
        result(true)
    case "setInt":
        let key = arguments["key"] as? String ?? ""
        let value = arguments["value"] as? Int ?? 0
        getUserDefaults()?.set(value, forKey: key)
        result(true)
    case "setDouble":
        let key = arguments["key"] as? String ?? ""
        let value = arguments["value"] as? Double ?? 0.0
        getUserDefaults()?.set(value, forKey: key)
        result(true)
    case "setString":
        let key = arguments["key"] as? String ?? ""
        let value = arguments["value"] as? String ?? ""
        getUserDefaults()?.set(value, forKey: key)
        result(true)
    case "setStringList":
        let key = arguments["key"] as? String ?? ""
        let value = arguments["value"] as? [String] ?? []
        getUserDefaults()?.set(value, forKey: key)
        result(true)
    case "remove":
        let key = arguments["key"] as? String ?? ""
        getUserDefaults()?.removeObject(forKey: key)
        result(true)
    case "clear":
        let defaults = getUserDefaults()
        for key in Self.getAllPrefs().keys {
            defaults?.removeObject(forKey: key)
        }
        result(true)
    default:
        result(FlutterMethodNotImplemented)
    }
  }

  // MARK: - Private UserDefaults getter

  private func getUserDefaults() -> UserDefaults? {
      if let appGroup = appGroup {
        return UserDefaults(suiteName: appGroup)
      }
      return UserDefaults.standard
  }

  // MARK: - Private Static Methods

  private static func getAllPrefs() -> [String: Any] {
      guard let appDomain = Bundle.main.bundleIdentifier else { return [:] }
      guard let prefs = UserDefaults.standard.persistentDomain(forName: appDomain) else { return [:] }

      var filteredPrefs = [String: Any]()
      for (key, value) in prefs {
          if let dateValue = value as? Date {
              filteredPrefs[key] = dateToMilliseconds(dateValue)
          } else {
              filteredPrefs[key] = value
          }
      }
      return filteredPrefs
  }

  private static func dateToMilliseconds(_ date: Date) -> Int64 {
      return Int64(date.timeIntervalSince1970 * 1000)
  }
}
