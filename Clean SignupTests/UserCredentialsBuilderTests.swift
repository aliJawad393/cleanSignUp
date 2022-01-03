import XCTest
@testable import Clean_Signup

final class UserCredentialsBuilderTests: XCTestCase {
    
    func test_build_withNoEmail_throwsError() {
        XCTAssertThrowsError(try makeSUT().build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Email"))
        }
    }
    
    func test_setEmail_withEmptyValue_throwsError() {
        let sut = makeSUT()
        
        XCTAssertThrowsError(try sut.setEmail(email: ""))
    }
    
    func test_setEmail_withWrongEmailFormat_throwsError() {
        let sut = makeSUT()
        
        XCTAssertThrowsError(try sut.setEmail(email: "wrongEmailFormat"))
    }
    
    func test_setEmail_withCorrectEmailFormat_DoesntThrowError() {
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.setEmail(email: correctFormatEmail()))
    }
    
    func test_build_withNoPassword_throwsError() {
        let sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Password"))
        }
    }
    
    func test_setPassword_withEmptyValue_throwsError() {
        let sut = makeSUT(email:  correctFormatEmail())
       
        XCTAssertThrowsError(try sut.setPassword(password: "")) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Password"))
        }

    }
    
    func test_setPassword_withSmallerLength_throwsError() {
        let sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "123")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.length(6))
        }
    }
    
    func test_setPassword_withNoUppercaseCharacter_throwsError() {
        let sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "123abc")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.missingUppercase)
        }
    }
    
    func test_setPassword_withNoLowercaseCharacter_throwsError() {
        let sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "123ABC")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.missingLowercase)
        }
    }
    
    func test_setPassword_withoutNumber_throwsError() {
        let sut = makeSUT(email:  correctFormatEmail())
        XCTAssertThrowsError(try sut.setPassword(password: "abcABC")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.missingNumber)
        }
    }
    
    func test_setPassword_withCorrectPasswordFormat_doesnotThrowError() {
        let sut = makeSUT(email:  correctFormatEmail())
        XCTAssertNoThrow(try sut.setPassword(password: correctPassword()))
    }
    
    func test_build_withNoConfirmPassword_throwsError() {
        let sut = makeSUT(email: correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        XCTAssertThrowsError(try sut.build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Confirm Password"))
        }
        
        XCTAssertThrowsError(try sut.setConfirmPassword(password: "")) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Confirm password"))
        }
    }
    
    func test_setConfirmPassword_withEmptyConfirmPassword_throwsError() {
        let sut = makeSUT(email: correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        
        XCTAssertThrowsError(try sut.setConfirmPassword(password: "")) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.empty("Confirm password"))
        }
    }
    
    func test_setConfirmPassword_mismathingWithPassword_throwsError() {
        let sut =  makeSUT(email:  correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        
        XCTAssertThrowsError(try sut.setConfirmPassword(password: "2Abcde")) {
            XCTAssertEqual($0 as? PasswordValidationError, PasswordValidationError.mismatch)
        }
    }
    
    func test_build_withoutAgreeingToTermsAndConditions_throwsError() {
        let sut =  makeSUT(email:  correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        try? sut.setConfirmPassword(password: correctPassword())
        XCTAssertThrowsError(try sut.build()) {
            XCTAssertEqual($0 as? ValidationError, ValidationError.notTicked("Terms & Conditions"))
        }
    }
    
    func test_build_withTickedTrueAndCorrectUserNameAndPasswordFormat_doesNotThrowError() {
        let sut =  makeSUT(email:  correctFormatEmail())
        
        try? sut.setPassword(password: correctPassword())
        try? sut.setConfirmPassword(password: correctPassword())
        sut.setTicked(isTicked: true)
        
        XCTAssertNoThrow(try sut.build())
    }
    
    func test_setName_setsCorrectValue() {
        let sut = makeSUT(email: correctFormatEmail())
        try? sut.setPassword(password: correctPassword())
        try? sut.setConfirmPassword(password: correctPassword())
        sut.setTicked(isTicked: true)
        
        sut.setName(name: "John Doe")
        let userCredentials = try? sut.build()
        
        XCTAssertEqual(userCredentials?.name, "John Doe")
    }
        
    private func makeSUT(email: String? = nil) -> UserCrendentialsBuilder {
        let sut = UserCrendentialsBuilder()
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


