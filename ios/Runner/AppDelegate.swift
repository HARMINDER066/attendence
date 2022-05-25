import UIKit
import Flutter
import GoogleMaps
import Firebase
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    GMSServices.provideAPIKey("AIzaSyC-iu9d0MWudMwtAtnz0MsCfMwlPGIB7MI")
    FirebaseApp.configure() //add this before the code below
    GeneratedPluginRegistrant.register(with: self)
     if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
          }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

}
