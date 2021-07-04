import Foundation

protocol Validator {
    func validate(_ value: String) -> Result<String, Error>
}

struct CompositeValidator: Validator {
    private let validators: [Validator]
    
    init(validators: [Validator]) {
        self.validators = validators
    }
    
    private init() {
        fatalError("Can't be initialzed without required parameters")
    }
    
    func validate(_ value: String) -> Result<String, Error> {
        let results: [Result<String, Error>] = validators.map {$0.validate(value)}
        let errors = results.filter {
            if case .failure = $0 {
                return true
            } else {
                return false
            }
        }
        return errors.first ?? .success(value)
    }
}
