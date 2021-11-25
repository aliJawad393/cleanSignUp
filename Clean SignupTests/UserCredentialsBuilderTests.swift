import XCTest
@testable import Clean_Signup

class UserCredentialsBuilderTests: XCTestCase {

    func test_emailIsMandatory() {
        XCTAssertThrowsError(try makeSUT().build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Email"))
        }
    }
    
    func test_emailCantSetEmpty() {
        var sut = makeSUT()
        XCTAssertThrowsError(try sut.setEmail(email: ""))
    }
    
    func test_emailFormatIsCorrect() {
        var sut = makeSUT()
        XCTAssertThrowsError(try sut.setEmail(email: "wrongEmailFormat"))
        XCTAssertNoThrow(try sut.setEmail(email: correctFormatEmail()))
    }
    
    func test_passwordIsMandatory() {
        var sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Password"))
        }
        
        XCTAssertThrowsError(try sut.setPassword(password: "")) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Password"))
        }

    }
    
    func test_minPasswordLength() {
        var sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "123")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.length(6))
        }
    }
    
    func test_passwordIncludesUpperCase() {
        var sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "123abc")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.missingUppercase)
        }
    }
    
    func test_passwordIncludesLowerCase() {
        var sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "123ABC")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.missingLowercase)
        }
    }
    
    func test_passwordIncludesNumber() {
        var sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "abcABC")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.missingNumber)
        }
    }
    
    func test_correctPasswordDoesNotThrow() {
        var sut = makeSUT(email:  correctFormatEmail())
        XCTAssertNoThrow(try sut.setPassword(password: correctPassword()))
    }
    
    func test_confirmPasswordIsMandatory() {
        var sut = makeSUT(email: correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        XCTAssertThrowsError(try sut.build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Confirm Password"))
        }
        
        XCTAssertThrowsError(try sut.setConfirmPassword(password: "")) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Confirm password"))
        }
    }
    
    func test_confirmPasswordMatchesPassword() {
        var sut =  makeSUT(email:  correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        
        XCTAssertThrowsError(try sut.setConfirmPassword(password: "2Abcde")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.mismatch)
        }
    }
    
    func test_tick_termsAndCondition_isMandatory() {
        var sut =  makeSUT(email:  correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        try? sut.setConfirmPassword(password: correctPassword())
        XCTAssertThrowsError(try sut.build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.notTicked("Terms & Conditions"))
        }
    }
    
    func test_correctFormInput_doesNotThrow() {
        var sut =  makeSUT(email:  correctFormatEmail())
        
        try? sut.setPassword(password: correctPassword())
        try? sut.setConfirmPassword(password: correctPassword())
        sut.setTicked(isTicked: true)
        
        XCTAssertNoThrow(try sut.build())
    }
        
    private func makeSUT(email: String? = nil) -> UserCrendentialsBuilder {
        var sut = UserCrendentialsBuilder()
        if let email = email {
            try? sut.setEmail(email: email)
        }
        return sut
    }
    
    private func correctFormatEmail() -> String{
        return "rightFormat@gmail.com"
    }
    
    private func correctPassword() -> String {
        return "1Abcdef"
    }
    
}


