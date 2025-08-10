import SwiftUI

struct SettingsView: View {
  @State var isAutoStartEnabled = SettingsManager.instance.autoStartEnabled
  @State var clipboardLimit = SettingsManager.instance.clipboardLimit
  @State var previewCharsLimit = SettingsManager.instance.previewCharsLimit
  
  var body: some View {
    VStack {
      HStack {
        Text("Settings")
          .frame(minHeight: 50)
          .font(.system(size: 20))
          .padding(.horizontal)
        Spacer()
        Button("Quit") {
          NSApplication.shared.terminate(nil)
        }
        .padding(.horizontal)
      }
      .padding(.bottom, -25)
      VStack(spacing: 30) {
        HStack {
          Text("Clipboard Limit:")
            .font(.system(size: 16))
          TextField("", value: Binding(
            get: {clipboardLimit},
            set: { val in
              SettingsManager.instance.clipboardLimit = val
              if val >= 1 {
                clipboardLimit = val
              }
            }
          ), formatter: NumberFormatter())
          .font(.system(size: 16))
          .multilineTextAlignment(.center)
          .frame(maxWidth: 60)
        }
        HStack {
          Text("Preview Characters Limit:")
            .font(.system(size: 16))
          TextField("", value: Binding(
            get: {previewCharsLimit},
            set: { val in
              SettingsManager.instance.previewCharsLimit = val
              if val >= 1 {
                previewCharsLimit = val
              }
            }
          ), formatter: NumberFormatter())
          .font(.system(size: 16))
          .multilineTextAlignment(.center)
          .frame(maxWidth: 60)
        }
        HStack {
          Text("Autostart")
            .font(.system(size: 16))
          Toggle(isOn: Binding(
            get: {isAutoStartEnabled},
            set: { val in
              SettingsManager.instance.autoStartEnabled = val
              isAutoStartEnabled = val
            }
          ), label: {})
          .toggleStyle(.switch)
        }
      }
      .frame(maxWidth: .infinity, maxHeight: .infinity)
      .overlay(
        RoundedRectangle(cornerRadius: 10)
          .stroke(Color(nsColor: NSColor.separatorColor), lineWidth: 1)
      )
      .padding(.all)
    }.frame(width: 400, height: 300)
  }
}

class SettingsWindow: ObservableObject {
  private var window: NSWindow?
  
  private func createWindow() {
    let view = SettingsView()
    let window = NSWindow(
      contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
      styleMask: [.titled, .closable],
      backing: .buffered,
      defer: false
    )
    window.title = "ClipBar Settings"
    window.contentView = NSHostingView(rootView: view)
    window.isReleasedWhenClosed = false
    window.level = .floating
    window.center()
    window.makeKeyAndOrderFront(nil)
    NSApp.activate(ignoringOtherApps: true)
    self.window = window
  }
  
  func showWindow() {
    if window == nil {
      createWindow()
    } else {
      if window?.isVisible == false {
        window?.center()
        window?.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
      }
    }
    
  }
}
