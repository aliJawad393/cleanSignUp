//
//  ValidatorTests.swift
//  Clean SignupTests
//
//  Created by Ali Jawad on 03/08/2021.
//

import XCTest
import Clean_Signup

class ValidatorTests: XCTestCase {
    func test_validator_string_empty(){
        assertFailure(EmptyValidator(title: "empty-test").validate(""), expectedError: ValidationError.empty("empty-test"))
    }
    
    func test_validator_emailFormator() {
        let sut = EmailFormatValidator()
        
        assertFailure(sut.validate(""), expectedError: ValidationError.invalidFormat("Email"))
        assertFailure(sut.validate("invalidEmail"), expectedError: ValidationError.invalidFormat("Email"))
        assertFailure(sut.validate("invalid@email"), expectedError: ValidationError.invalidFormat("Email"))
        assertFailure(sut.validate("invalid.email"), expectedError: ValidationError.invalidFormat("Email"))
        assertSuccess(sut.validate("valid@email.com"), expectedResult: "valid@email.com")
    }
    
    
    private func assertFailure(_ result: Result<String, Error>, expectedError: ValidationError) {
        switch result {
        case .failure(let error as ValidationError):
            XCTAssertEqual(error, expectedError)
        case .success(let value):
            XCTFail("Expected to be a failure but got a success with \(value)")
        default:
            XCTFail("Did not get expected error: \(expectedError)")
        }
    }
    
    private func assertSuccess(_ result: Result<String, Error>, expectedResult: String) {
        switch result {
        case .failure(let error as ValidationError):
            XCTFail("Expected to be a success but got a failure with \(error)")
        case .success(let value):
            XCTAssertEqual(value, expectedResult)
        default:
            XCTFail("Expected to be success but got failure")
        }
    }
}


