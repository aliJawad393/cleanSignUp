//
//  CredentialsBuilderImplementations.swift
//  Clean SignupTests
//
//  Created by Ali Jawad on 30/11/2021.
//

import Foundation
@testable import Clean_Signup

class DummyCredentialsBuilder: CredentialsBuilder {
    func setName(name: String) {}
    
    func setEmail(email: String) throws {}
    
    func setPassword(password: String) throws {}
    
    func setConfirmPassword(password: String) throws {}
    
    func setTicked(isTicked: Bool) {}
    
    func build() throws -> UserCredentials {
        return UserCredentials(name: "", email: "", password: "")
    }
}


class SpyCredentialsBuilder: CredentialsBuilder {
    var name: String = ""
    var email: String = ""
    var password: String = ""
    var confirmPassword: String = ""
    var isTicked = false
    
    func setName(name: String) {
        self.name = name
    }
    
    func setEmail(email: String) throws {
        self.email = email
    }
    
    func setPassword(password: String) throws {
        self.password = password
    }
    
    func setConfirmPassword(password: String) throws {
        self.confirmPassword = password
    }
    
    func setTicked(isTicked: Bool) {
        self.isTicked = isTicked
    }
    
    func build() throws -> UserCredentials {
        return UserCredentials(name: name, email: email, password: password)
    }
}


fileprivate enum DummyValidationError: Error {
    case format
}


class FakeCredentialsBuilderForError: CredentialsBuilder {
    // Builder always throws errpr
 

    func setName(name: String) {
    }
    
    func setEmail(email: String) throws {
        throw DummyValidationError.format
    }
    
    func setPassword(password: String) throws {
        throw DummyValidationError.format
    }
    
    func setConfirmPassword(password: String) throws {
        throw DummyValidationError.format
    }
    
    func setTicked(isTicked: Bool) {}
    
    func build() throws -> UserCredentials {
        throw DummyValidationError.format
    }
}

extension DummyValidationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .format:
            return NSLocalizedString("Incorrect Format", comment: "Error")
        
        }
    }
}
