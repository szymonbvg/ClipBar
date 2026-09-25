import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
  var popover: NSPopover!
  var statusBarItem: NSStatusItem!
  
  var clipboard = Clipboard()
  var settingsWindow = SettingsWindow()
  
  func applicationDidFinishLaunching(_ aNotification: Notification) {
    let contentView = ContentView()
      .environmentObject(clipboard)
      .environmentObject(settingsWindow)
    
    let popover = NSPopover()
    popover.contentSize = NSSize(width: 400, height: 300)
    popover.behavior = .transient
    popover.animates = false
    popover.contentViewController = NSHostingController(rootView: contentView)
    self.popover = popover
    
    let statusBar = NSStatusBar.system
    statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
    statusBarItem.button?.action = #selector(togglePopover(_:))
    let icon = SettingsManager.instance.privacyMode ? "MenuBarIconPrivate" : "MenuBarIcon"
    statusBarItem.button?.image = NSImage(named: icon)
    
    SettingsManager.instance.statusBarItemReference = statusBarItem
    
    clipboard.observePasteboard()
  }
  
  @objc func togglePopover(_ sender: AnyObject?) {
    NSApp.activate(ignoringOtherApps: true)
    
    if let button = self.statusBarItem.button {
      if self.popover.isShown {
        self.popover.performClose(sender)
      }
      else {
        self.popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
      }
    }
  }
  
  func applicationWillResignActive(_ notification: Notification) {
    self.popover.performClose(nil)
  }
}
