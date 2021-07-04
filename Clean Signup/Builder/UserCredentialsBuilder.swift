import Foundation

protocol CredentialsBuilder {
    mutating func setName(name: String)
    mutating func setEmail(email: String) throws
    mutating func setPassword(password: String) throws
    mutating func setConfirmPassword(password: String) throws
    mutating func setTicked(isTicked: Bool)
    func build() throws -> UserCredentials
}

struct UserCrendentialsBuilder: CredentialsBuilder {
    private var name: String = ""
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    private var isTicked: Bool = false
    
    mutating func setName(name: String) {
        self.name = name
    }
    
    mutating func setEmail(email: String) throws {
        let result = CompositeValidator(validators: [EmptyValidator(title: "Email"),EmailFormatValidator()]).validate(email)
        switch result {
        case .success(_):
            self.email = email
        case .failure(let error):
            throw error
        }
    }
    
    mutating func setPassword(password: String) throws {
        let result = CompositeValidator(validators: [EmptyValidator(title: "Password"), PasswordLengthValidator(minLength: 6), PasswordIncludesUppercaseValidator(), PasswordIncludesLowercaseValidator(), PasswordIncludesNumbersValidator()]).validate(password)
        switch result {
            case .success(_):
                self.password = password
            case .failure(let error):
                throw error
        }
    }
    
    mutating func setConfirmPassword(password: String) throws {
        let result = CompositeValidator(validators: [EmptyValidator(title: "Confirm password"), ConfirmPasswordMatchValidator(password: self.password)]).validate(password)
        switch result {
            case .success(_):
                self.confirmPassword = password
            case .failure(let error):
                throw error
        }
    }
    
    mutating func setTicked(isTicked: Bool) {
        self.isTicked = isTicked
    }
    
    func build() throws -> UserCredentials{
        
        for result in [EmptyValidator(title: "Email").validate(email), EmptyValidator(title: "Password").validate(password), EmptyValidator(title: "Confirm Password").validate(confirmPassword)] {
            switch result {
                case .failure(let error):
                    throw error
            default:
                continue
            }
        }
        
        guard isTicked  else {
            throw ValidationError.notTicked("Terms & Conditions")
        }
        
        return UserCredentials(name: name, email: email, password: password)
    }
}
