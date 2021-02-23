import Cocoa
import FlutterMacOS

private let kMessagesChannel = "uni_links/messages"
private let kEventsChannel = "uni_links/events"

var _instance: Any?

public class UniLinksPlugin: NSObject, NSApplicationDelegate, FlutterPlugin, FlutterStreamHandler {
  var eventSink: FlutterEventSink?
  var initialLink: String?

  static let setLatestLinkKey = "latestLink"
  var latestLink = "latestLink"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let instance = UniLinksPlugin.sharedInstance()
    let channel = FlutterMethodChannel(
      name: kMessagesChannel,
      binaryMessenger: registrar.messenger
    )
    registrar.addMethodCallDelegate(instance!, channel: channel)

    let chargingChannel = FlutterEventChannel(
      name: kEventsChannel,
      binaryMessenger: registrar.messenger
    )
    chargingChannel.setStreamHandler(instance)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getInitialLink":
      result(initialLink)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

    public func setLatestLink(_ latestLink: String?) {
        willChangeValue(forKey: UniLinksPlugin.setLatestLinkKey)
        self.latestLink = latestLink ?? "latestLink";
        didChangeValue(forKey: UniLinksPlugin.setLatestLinkKey)

        if (eventSink != nil) {
            eventSink!(latestLink)
        }
    }

  public static func sharedInstance() -> UniLinksPlugin? {
    if _instance == nil {
      _instance = UniLinksPlugin()
    }
    return _instance as? UniLinksPlugin
  }

  private func application(
    _: NSApplication,
    didFinishLaunchingWithOptions launchOptions: [NSObject: Any]? = nil
  ) -> Bool {
    let url = launchOptions as! URL
    initialLink = url.absoluteString
    latestLink = initialLink!
    return true
  }

  func application(
    _: NSApplication,
    open url: URL,
    options _: [NSObject: Any] = [:]
  ) -> Bool {
    latestLink = url.absoluteString
    return true
  }

    private func application(
    _: NSApplication,
    continue userActivity: NSUserActivity,
    restorationHandler _: @escaping ([NSUserActivityRestoring]?) -> Void
  ) -> Bool {
    if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
      latestLink = userActivity.webpageURL!.absoluteString
        print(latestLink)
      if eventSink == nil {
        initialLink = latestLink
      }
      return true
    }
    return false
  }

  public func onListen(
    withArguments _: Any?,
    eventSink: @escaping FlutterEventSink
  ) -> FlutterError? {
    self.eventSink = eventSink
    return nil
  }

  public func onCancel(withArguments _: Any?) -> FlutterError? {
    eventSink = nil
    return nil
  }
}
