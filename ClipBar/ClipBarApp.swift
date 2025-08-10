import SwiftUI

@main
struct ClipBarApp: App {
  @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
  var body: some Scene {
    Settings {
      SettingsView()
    }
  }
}
