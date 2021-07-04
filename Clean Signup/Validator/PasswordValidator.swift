import Foundation

struct PasswordLengthValidator: Validator {
    private let minLength: Int
    
    init(minLength: Int) {
        self.minLength = minLength
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    func validate(_ value: String) -> Result<String, Error> {
        return value.count >= minLength ? .success(value) : .failure(PasswordValidationError.length(minLength))
    }
}

struct PasswordIncludesUppercaseValidator: Validator {
    func validate(_ value: String) -> Result<String, Error> {
        return value.rangeOfCharacter(from: NSCharacterSet.uppercaseLetters) != nil ?
            .success(value) :
            .failure(PasswordValidationError.missingUppercase)
    }
}

struct PasswordIncludesLowercaseValidator: Validator {
    func validate(_ value: String) -> Result<String, Error> {
        return value.rangeOfCharacter(from: NSCharacterSet.lowercaseLetters) != nil ?
            .success(value) :
            .failure(PasswordValidationError.missingLowercase)
    }
}

struct PasswordIncludesNumbersValidator: Validator {
    func validate(_ value: String) -> Result<String, Error> {
        return value.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil ?
            .success(value) :
            .failure(PasswordValidationError.missingNumber)
    }
}

struct ConfirmPasswordMatchValidator: Validator {
    private let password: String
    
    init(password: String) {
        self.password = password
    }
    
    func validate(_ value: String) -> Result<String, Error> {
        return value == password ? .success(value) : .failure(PasswordValidationError.mismatch)
    }
}
