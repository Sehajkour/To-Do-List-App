import Flutter
import UIKit
import UserNotifications  // Import UserNotifications for notification handling

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
        if let error = error {
          print("Error requesting notifications authorization: \(error.localizedDescription)")
        }
      }
      UNUserNotificationCenter.current().delegate = self
    } else {
      // Fallback on earlier versions
      let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
