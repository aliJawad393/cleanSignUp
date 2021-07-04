import Foundation
public struct UserCredentials {
    let name: String
    let email: String
    let password: String
    
    public init(name: String, email: String, password: String) {
        self.name = name
        self.email = email
        self.password = password
    }
}
