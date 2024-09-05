import UIKit
import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    if #available(iOS 10.0, *) {
  UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
}
    GMSServices.provideAPIKey("AIzaSyB1ykQSVopyd-TB_6Mj9WtUi1hts3R8iX8")
    // GMSServices.provideAPIKey("AIzaSyBk3Ob5sh98M3Elqi9_WDfKpeYfEY8MBwI")
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func applicationDidBecomeActive(_ application: UIApplication) {
  application.applicationIconBadgeNumber = 0;
}
}