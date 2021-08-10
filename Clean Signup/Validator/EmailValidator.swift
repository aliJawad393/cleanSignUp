import Foundation

public struct EmailFormatValidator: Validator {
    public init(){}
    public func validate(_ value: String) -> Result<String, Error> {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: value) ? .success(value) : .failure(ValidationError.invalidFormat("Email"))
    }
}
