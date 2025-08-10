import SwiftUI

struct ContentView: View {
  @EnvironmentObject var clipboard: Clipboard
  @EnvironmentObject var settingsWindow: SettingsWindow
  
  private func textWrap(text: String) -> String {
    if text.count > SettingsManager.instance.previewCharsLimit {
      return String(text.prefix(SettingsManager.instance.previewCharsLimit)) + " ..."
    } else {
      return text
    }
  }
  
  var body: some View {
    VStack(alignment: .leading, spacing: 0) {
      HStack {
        Text("Clipboard's content:")
          .frame(maxHeight: .infinity)
          .padding(.horizontal)
        Spacer()
        Button(action: {
          settingsWindow.showWindow()
        }) {
          Image(systemName: "gear")
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 25)
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal)
        .buttonStyle(PlainButtonStyle())
      }
      .frame(maxWidth: .infinity, maxHeight: 40)
      Divider()
      if clipboard.data.count > 0, !clipboard.isStringAvailable {
        HStack {
          Text("Copied a non-text element")
          Spacer()
          Button("Copy last text") {
            clipboard.copy(index: 0)
          }
          .buttonStyle(CustomButton())
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        Divider()
      }
      
      ScrollView {
        VStack(spacing: 0) {
          if clipboard.data.count <= 0 {
            Text("Clipboard is empty").padding()
          }
            
          ForEach(0..<clipboard.data.count, id: \.self) { index in
            HStack {
              Text("\(textWrap(text: clipboard.data[index]))")
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(x: 20)
                .padding(.vertical)
                .padding(.trailing, 40)
                .textSelection(.enabled)
                .overlay(
                  RoundedRectangle(cornerRadius: 10)
                    .stroke(Color(nsColor: NSColor.separatorColor), lineWidth: 1)
                )
              Spacer()
              VStack {
                Button("C") {
                  clipboard.copy(index: index)
                }
                .buttonStyle(CustomButton())
                
                if clipboard.data.count > 1 {
                  Button("X") {
                    clipboard.remove(index: index)
                  }
                  .buttonStyle(CustomButton())
                }
              }
              .frame(maxHeight: .infinity)
              .padding(.horizontal, 4)
            }
            .frame(maxWidth: .infinity, minHeight: 55)
            .padding(.horizontal, 10)
            .padding(.vertical, 7)
          }
        }
        .frame(maxWidth: .infinity)
      }
    }
    .frame(width: 400, height: 300)
  }
}

private struct CustomButton: ButtonStyle {
  func makeBody(configuration: Configuration) -> some View {
    configuration.label
      .buttonStyle(PlainButtonStyle())
      .padding(.horizontal, 6)
      .padding(.vertical, 2)
      .background(Color(nsColor: NSColor.separatorColor))
      .clipShape(RoundedRectangle(cornerRadius: 5))
  }
}
