import Repositories
import SwiftUI

public struct LoginView: View {
    @State private var inputTraqId: String = ""
    @State private var inputPassword: String = ""
    private let authRepository: AuthRepository = .init()

    public init() {}
    public var body: some View {
        VStack(alignment: .center) {
            Text("traQ Clone")
                .font(.largeTitle)
                .bold()

            VStack(spacing: 24) {
                TextField("traQ ID", text: $inputTraqId)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 280)
                SecureField("パスワード", text: $inputPassword)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(maxWidth: 280)
            }
            .frame(height: 200)

            Button(action: {
                let name = inputTraqId
                let password = inputPassword

                inputTraqId = ""
                inputPassword = ""

                authRepository.login(name: name, password: password)
            }) {
                Text("ログイン")
                    .fontWeight(.medium)
                    .frame(minWidth: 100)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(8)
            }

            Button(action: {
                authRepository.logout()
            }) {
                Text("ログアウト")
                    .fontWeight(.medium)
                    .frame(minWidth: 100)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
