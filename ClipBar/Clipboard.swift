import SwiftUI

class Clipboard: ObservableObject {
  @Published var data: Array<String> = []
  @Published var isStringAvailable = true
  
  private var pasteboard = NSPasteboard.general
  
  func observePasteboard() {
    Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
      if let currContent = self.pasteboard.string(forType: .string) {
        if !self.isStringAvailable {
          self.isStringAvailable = true
        }
        if !self.data.contains(currContent) {
          self.data.insert(currContent, at: 0)
          if self.data.count > SettingsManager.instance.clipboardLimit {
            self.remove(index: self.data.count - 1)
          }
        }
      }
      else if self.isStringAvailable {
        self.isStringAvailable = false
      }
    }
  }
  
  func copy(index: Int) {
    let value = self.data[index]
    update(val: value)
    if index > 0 {
      remove(index: index);
      data.insert(value, at: 0)
    }
  }
  
  func remove(index: Int) {
    if index == 0, self.data.count > 1 {
      update(val: self.data[1])
    }
    data.remove(at: index)
  }
  
  private func update(val: String) {
    pasteboard.clearContents()
    pasteboard.setString(val, forType: .string)
  }
}
