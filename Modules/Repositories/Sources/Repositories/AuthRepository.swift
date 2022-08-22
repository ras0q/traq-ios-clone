import OpenAPIClient
import SwiftUI

public final class AuthRepositories {
    public init() {}

    public func login(name: String, password: String) {
        let request = PostLoginRequest(name: name, password: password)
        AuthenticationAPI.login(postLoginRequest: request) { response, error in
            guard error == nil else {
                print(error!)
                return
            }

            debugPrint(response.debugDescription)
            debugPrint("login!")
        }
    }

    public func logout() {
        AuthenticationAPI.logout { response, error in
            guard error == nil else {
                print(error!)
                return
            }

            debugPrint(response.debugDescription)
            debugPrint("logout!")
        }
    }
}
