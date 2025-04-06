import UIKit
import Flutter
// 네이버 소셜 로그인 세팅 추가
import NaverThirdPartyLogin

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // # region start 네이버 소셜 로그인 세팅 추가 
    NaverThirdPartyLoginConnection.getSharedInstance()?.isNaverAppOauthEnable = true
    NaverThirdPartyLoginConnection.getSharedInstance()?.isInAppOauthEnable = true

    let thirdConn = NaverThirdPartyLoginConnection.getSharedInstance()
    thirdConn?.serviceUrlScheme = "haedalScheme"
    thirdConn?.consumerKey = "AQgp6F2PyQ7pZHvWbuI2"
    thirdConn?.consumerSecret = "srDMneLjbU"
    thirdConn?.appName = "haedal"
    // # region end 네이버 소셜 로그인 세팅 추가 

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
