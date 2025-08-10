import SwiftUI
import ServiceManagement

class SettingsManager {
  static var instance = SettingsManager()
  
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
