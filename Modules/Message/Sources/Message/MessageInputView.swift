import SwiftUI

public struct MessageInputView: View {
    @State private var input: String = ""

    public init() {}

    public var body: some View {
        HStack {
            Button(action: {}) {
                Image(systemName: "plus.circle")
            }
            VStack {
                TextEditor(text: $input)
                    .frame(height: 40)
            }
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 1)
            )
            Button(action: {}) {
                Image(systemName: "face.smiling")
            }
            Button(action: {}) {
                Image(systemName: "paperplane")
            }
        }
        .padding()
        .background(Color.white)
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView()
    }
}
