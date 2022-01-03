//
//  SignUpViewControllerDelegate.swift
//  Clean Signup
//
//  Created by Ali Jawad on 02/12/2021.
//

import Foundation

protocol SignUpViewControllerDelegate: AnyObject {
    func didTapSignUpButton()
    func didToggleTermsAndConditionCheckbox(value: Bool)
}

final class SignUpViewControllerDelegateImp: SignUpViewControllerDelegate {
    private var builder: CredentialsBuilder
    weak private var controller: SignUpViewController?
    
    init(controller: SignUpViewController, builder: CredentialsBuilder) {
        self.builder = builder
        self.controller = controller
    }
    
    func didTapSignUpButton() {
        do {
            let _ = try builder.build()
            controller?.alert("Success", message: "Entered info was valid")
        } catch(let error) {
            controller?.alert("Error", message: error.localizedDescription)
        }
    }
    
    func didToggleTermsAndConditionCheckbox(value: Bool) {
        builder.setTicked(isTicked: value)
    }
}
