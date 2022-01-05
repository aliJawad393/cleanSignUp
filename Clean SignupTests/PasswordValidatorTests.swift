//
//  PasswordValidatorTests.swift
//  Clean SignupTests
//
//  Created by Ali Jawad on 05/08/2021.
//

import XCTest
import Clean_Signup

final class PasswordValidatorTests: XCTestCase {
    
    func test_passwordIncludesUppercaseValidator_failsWithoutMinOneUppercaseLetter() {
        let sut = PasswordIncludesUppercaseValidator()
        
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.missingUppercase)
        assertFailure(sut.validate("[]_?-/*||"), expectedError: PasswordValidationError.missingUppercase)
        assertFailure(sut.validate("123"), expectedError: PasswordValidationError.missingUppercase)
        assertFailure(sut.validate("abc"), expectedError: PasswordValidationError.missingUppercase)
        assertSuccess(sut.validate("Abc"), expectedResult: "Abc")
        assertSuccess(sut.validate("ABc"), expectedResult: "ABc")
    }
    
    func test_passwordIncludesLowercaseValidator_failsWithoutMinOneLowercaseLetter() {
        let sut = PasswordIncludesLowercaseValidator()
        
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.missingLowercase)
        assertFailure(sut.validate("[]_?-/*||"), expectedError: PasswordValidationError.missingLowercase)
        assertFailure(sut.validate("123"), expectedError: PasswordValidationError.missingLowercase)
        assertFailure(sut.validate("ABC"), expectedError: PasswordValidationError.missingLowercase)
        assertSuccess(sut.validate("aBC"), expectedResult: "aBC")
        assertSuccess(sut.validate("abC"), expectedResult: "abC")
    }
    
    func test_passwordIncludesNumbersValidator_failsWithoutMinOneNumber() {
        let sut = PasswordIncludesNumbersValidator()
        
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.missingNumber)
        assertFailure(sut.validate("[]_?-/*||"), expectedError: PasswordValidationError.missingNumber)
        assertFailure(sut.validate("abc"), expectedError: PasswordValidationError.missingNumber)
        assertFailure(sut.validate("ABC"), expectedError: PasswordValidationError.missingNumber)
        assertSuccess(sut.validate("1Ab"), expectedResult: "1Ab")
        assertSuccess(sut.validate("123"), expectedResult: "123")
    }
    
    func test_confirmPasswordMatchValidator_failsIfTwoPasswordsDontExactlyMatch() {
        let sut = ConfirmPasswordMatchValidator(password: "abc")
        
        assertFailure(sut.validate(""), expectedError: PasswordValidationError.mismatch)
        assertFailure(sut.validate("ab"), expectedError: PasswordValidationError.mismatch)
        assertFailure(sut.validate("abd"), expectedError: PasswordValidationError.mismatch)
        assertFailure(sut.validate("abC"), expectedError: PasswordValidationError.mismatch)
        assertSuccess(sut.validate("abc"), expectedResult: "abc")
    }
    
    private func assertFailure(_ result: Result<String, Error>, expectedError: PasswordValidationError) {
        switch result {
        case .failure(let error as PasswordValidationError):
            XCTAssertEqual(error, expectedError)
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
