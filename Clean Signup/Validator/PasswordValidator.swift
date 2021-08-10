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

public struct PasswordIncludesUppercaseValidator: Validator {
    public init(){}
    public func validate(_ value: String) -> Result<String, Error> {
        return value.rangeOfCharacter(from: NSCharacterSet.uppercaseLetters) != nil ?
            .success(value) :
            .failure(PasswordValidationError.missingUppercase)
    }
}

public struct PasswordIncludesLowercaseValidator: Validator {
    public init(){}
    public func validate(_ value: String) -> Result<String, Error> {
        return value.rangeOfCharacter(from: NSCharacterSet.lowercaseLetters) != nil ?
            .success(value) :
            .failure(PasswordValidationError.missingLowercase)
    }
}

public struct PasswordIncludesNumbersValidator: Validator {
    public init(){}
    public func validate(_ value: String) -> Result<String, Error> {
        return value.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil ?
            .success(value) :
            .failure(PasswordValidationError.missingNumber)
    }
}

public struct ConfirmPasswordMatchValidator: Validator {
    private let password: String
    
    public init(password: String) {
        self.password = password
    }
    
    public func validate(_ value: String) -> Result<String, Error> {
        return value == password ? .success(value) : .failure(PasswordValidationError.mismatch)
    }
}
