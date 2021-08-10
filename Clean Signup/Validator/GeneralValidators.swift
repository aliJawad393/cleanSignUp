import Foundation

public struct EmptyValidator: Validator {
    private let title: String
    
    public init(title: String) {
        self.title = title
    }
    
    private init() {
        fatalError("Can't be initialized without required parameters")
    }
    
    public func validate(_ value: String) -> Result<String, Error> {
        return value.isEmpty ? .failure(ValidationError.empty(title)) : .success(value)
    }
}
