import SwiftUI
import ServiceManagement

class SettingsManager {
  static var instance = SettingsManager()
  
  var statusBarItemReference: NSStatusItem?
  
  var autoStartEnabled: Bool {
    didSet {
      UserDefaults.standard.set(autoStartEnabled, forKey: "autoStartEnabled")
      do {
        if autoStartEnabled {
          try SMAppService.mainApp.register()
        } else {
          try SMAppService.mainApp.unregister()
        }
      } catch {}
    }
  }
  
  var privacyMode: Bool {
    didSet {
      UserDefaults.standard.set(privacyMode, forKey: "privacyMode")
      guard let statusBarItem = statusBarItemReference else { return }
      let nsImageName = privacyMode ? "MenuBarIconPrivate" : "MenuBarIcon"
      statusBarItem.button?.image = NSImage(named: nsImageName)
    }
  }
  
  var clipboardLimit: Int {
    didSet {
      if clipboardLimit >= 1 {
        UserDefaults.standard.set(clipboardLimit, forKey: "clipboardLimit")
      }
    }
  }
  
  var previewCharsLimit: Int {
    didSet {
      if previewCharsLimit >= 1 {
        UserDefaults.standard.set(previewCharsLimit, forKey: "previewCharsLimit")
      }
    }
  }
  
  init() {
    autoStartEnabled = UserDefaults.standard.bool(forKey: "autoStartEnabled")
    privacyMode = UserDefaults.standard.bool(forKey: "privacyMode")
    clipboardLimit = UserDefaults.standard.integer(forKey: "clipboardLimit")
    previewCharsLimit = UserDefaults.standard.integer(forKey: "previewCharsLimit")
    
    if clipboardLimit < 1 {
      clipboardLimit = 1
    }
    
    if previewCharsLimit < 1 {
      previewCharsLimit = 1
    }
  }
}
