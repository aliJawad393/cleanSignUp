import Foundation

public enum ValidationError: Error, Equatable {
    case empty(String)
    case invalidFormat(String)
    case notTicked(String)
}

public enum PasswordValidationError: Error, Equatable {
    case length(Int)
    case missingUppercase
    case missingLowercase
    case missingNumber
    case mismatch
}

extension PasswordValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .length(let length):
            return NSLocalizedString("Password must have min \(length) characters", comment: "Error")
        case .missingUppercase:
            return NSLocalizedString("Password must have at least one upper case character", comment: "Error")
        case .missingLowercase:
            return NSLocalizedString("Password must have at least one lower case character", comment: "Error")
        case .missingNumber:
            return NSLocalizedString("Password must have at least one number", comment: "Error")
        case .mismatch:
            return NSLocalizedString("Passwords mismatch", comment: "Error")
        }
    }
}

extension ValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty(let field):
            return NSLocalizedString("\(field) can't be empty", comment: "Error")
        case .invalidFormat(let field):
            return NSLocalizedString("\(field) format is incorrect", comment: "Error")
        case .notTicked(let field):
            return NSLocalizedString("Must agree to \(field)", comment: "Error")

        }
    }
}
