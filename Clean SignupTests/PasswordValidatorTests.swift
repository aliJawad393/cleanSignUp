//
//  PasswordValidatorTests.swift
//  Clean SignupTests
//
//  Created by Ali Jawad on 05/08/2021.
//

import XCTest
import Clean_Signup

class PasswordValidatorTests: XCTestCase {
    
    func test_validator_passwordIncludesUpperCase() {
        let sut = PasswordIncludesUppercaseValidator()
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.missingUppercase)
        assertFailure(sut.validate("[]_?-/*||"), expectedError: PasswordValidationError.missingUppercase)
        assertFailure(sut.validate("123"), expectedError: PasswordValidationError.missingUppercase)
        assertFailure(sut.validate("abc"), expectedError: PasswordValidationError.missingUppercase)
        assertSuccess(sut.validate("Abc"), expectedResult: "Abc")
    }
    
    func test_validator_passwordIncludesLowerCase() {
        let sut = PasswordIncludesLowercaseValidator()
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.missingLowercase)
        assertFailure(sut.validate("[]_?-/*||"), expectedError: PasswordValidationError.missingLowercase)
        assertFailure(sut.validate("123"), expectedError: PasswordValidationError.missingLowercase)
        assertFailure(sut.validate("ABC"), expectedError: PasswordValidationError.missingLowercase)
        assertSuccess(sut.validate("aBC"), expectedResult: "aBC")
    }
    
    func test_validator_passwordIncludesNumber() {
        let sut = PasswordIncludesNumbersValidator()
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.missingNumber)
        assertFailure(sut.validate("[]_?-/*||"), expectedError: PasswordValidationError.missingNumber)
        assertFailure(sut.validate("abc"), expectedError: PasswordValidationError.missingNumber)
        assertFailure(sut.validate("ABC"), expectedError: PasswordValidationError.missingNumber)
        assertSuccess(sut.validate("123"), expectedResult: "123")
    }
    
    func test_validator_passwordMatchesConfirmPassword() {
        let sut = ConfirmPasswordMatchValidator(password: "123")
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.mismatch)
        assertFailure(sut.validate("12"), expectedError: PasswordValidationError.mismatch)
        assertFailure(sut.validate("124"), expectedError: PasswordValidationError.mismatch)
        assertSuccess(sut.validate("123"), expectedResult: "123")
    }
    
    private func assertFailure(_ result: Result<String, Error>, expectedError: PasswordValidationError) {
        switch result {
        case .failure(let error as PasswordValidationError):
            XCTAssertEqual(expectedError, error)
        case .success(let value):
            XCTFail("Expected to be a failure but got a success with \(value)")
        default:
            XCTFail("Did not get expected error: \(expectedError)")
        }
    }
    
    private func assertSuccess(_ result: Result<String, Error>, expectedResult: String) {
        switch result {
        case .failure(let error as PasswordValidationError):
            XCTFail("Expected to be a success but got a failure with \(error)")
        case .success(let value):
            XCTAssertEqual(value, expectedResult)
        default:
            XCTFail("Expected to be success but got failure")
        }
    }
}
