import SwiftUI

public struct MessageInputView: View {
    private let needAlert: Bool

    @State private var input: String = ""
    @State private var showingAlert: Bool = false

    public init(needAlert: Bool) {
        self.needAlert = needAlert
    }

    // TODO: 投稿機能を作る
    private func postMessage() {
        debugPrint("投稿しました")
        input = ""
    }

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
            Button(action: {
                guard !needAlert else {
                    showingAlert = true
                    return
                }

                postMessage()
            }) {
                Image(systemName: "paperplane")
            }
        }
        .padding()
        .background(Color.white)
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("このメッセージは全員に通知されます。メッセージを投稿しますか？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .default(Text("OK")) {
                    postMessage()
                }
            )
        }
    }
}

struct MessageInputView_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputView(needAlert: false)
    }
}
