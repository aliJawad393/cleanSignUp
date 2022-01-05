import Foundation

protocol CredentialsBuilder {
    func setName(name: String)
    func setEmail(email: String) throws
    func setPassword(password: String) throws
    func setConfirmPassword(password: String) throws
    func setTicked(isTicked: Bool)
    func build() throws -> UserCredentials
}

class UserCrendentialsBuilder: CredentialsBuilder {
    private var name: String = ""
    private var email: String = ""
    private var password: String = ""
    private var confirmPassword: String = ""
    private var isTicked: Bool = false
    
    func setName(name: String) {
        self.name = name
    }
    
    func setEmail(email: String) throws {
        let result = CompositeValidator(validators: [EmptyValidator(title: "Email"),EmailFormatValidator()]).validate(email)
        switch result {
        case .success(_):
            self.email = email
        case .failure(let error):
            throw error
        }
    }
    
    func setPassword(password: String) throws {
        let result = CompositeValidator(validators: [EmptyValidator(title: "Password"), PasswordLengthValidator(minLength: 6), PasswordIncludesUppercaseValidator(), PasswordIncludesLowercaseValidator(), PasswordIncludesNumbersValidator()]).validate(password)
        switch result {
            case .success(_):
                self.password = password
            case .failure(let error):
                throw error
        }
    }
    
    func setConfirmPassword(password: String) throws {
        let result = CompositeValidator(validators: [EmptyValidator(title: "Confirm password"), ConfirmPasswordMatchValidator(password: self.password)]).validate(password)
        switch result {
            case .success(_):
                self.confirmPassword = password
            case .failure(let error):
                throw error
        }
    }
    
    func setTicked(isTicked: Bool) {
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
