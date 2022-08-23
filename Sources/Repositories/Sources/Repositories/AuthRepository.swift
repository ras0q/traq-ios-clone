import SwiftUI
import Traq

public protocol AuthRepository {
    func login(name: String, password: String)
    func logout()
}

public final class AuthRepositoryImpl: AuthRepository {
    public init() {}

    public func login(name: String, password: String) {
        let request = TraqAPI.PostLoginRequest(name: name, password: password)
        TraqAPI.AuthenticationAPI.login(postLoginRequest: request) { response, error in
            guard error == nil else {
                print(error!)
                return
            }

            debugPrint(response.debugDescription)
            debugPrint("login!")
        }
    }

    public func logout() {
        TraqAPI.AuthenticationAPI.logout { response, error in
            guard error == nil else {
                print(error!)
                return
            }

            debugPrint(response.debugDescription)
            debugPrint("logout!")
        }
    }
}
