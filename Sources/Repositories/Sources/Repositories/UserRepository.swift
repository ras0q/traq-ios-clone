import SwiftUI
import Traq

public protocol UserRepository {
    func fetchUsers(options: FetchUsersOptions?, completion: @escaping ((_ data: [TraqAPI.User]) -> Void))
}

public struct FetchUsersOptions {
    let includeSuspended: Bool?
    let name: String?

    public init(includeSuspended: Bool? = nil, name: String? = nil) {
        self.includeSuspended = includeSuspended
        self.name = name
    }
}

public final class UserRepositoryImpl: UserRepository {
    private var users: [TraqAPI.User] = []
    private var userDictionary: [UUID: TraqAPI.User] = [:]
    private typealias API = TraqAPI.UserAPI

    public init() {}

    public func fetchUsers(options: FetchUsersOptions?, completion: @escaping ((_ data: [TraqAPI.User]) -> Void)) {
        API.getUsers(includeSuspended: options?.includeSuspended, name: options?.name) { [self] response, error in
            guard error == nil else {
                print(error!)
                return
            }

            guard let response = response else {
                print("response is nil")
                return
            }

            self.users = response

            users.forEach { user in
                self.userDictionary[user.id] = user
            }

            completion(response)
        }
    }
}
