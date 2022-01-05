//
//  ViewControllerFactory.swift
//  Clean Signup
//
//  Created by Ali Jawad on 02/12/2021.
//

import Foundation
import UIKit



final class iOSViewControllerFactory {
    func createSignupViewController(builder: CredentialsBuilder) -> UIViewController {
        let controller =  SignUpViewController()
        controller.textFieldUserNameDelegate = TextFieldDelegate(nextResponser: controller.textFieldEmail, endEditingBlock: {text in
            builder.setName(name: text)
        })
        
        controller.textFieldEmailDelegate = TextFieldDelegate(nextResponser: controller.textFieldPassword, endEditingBlock: {text in
            do {
                try builder.setEmail(email: text)
            } catch let error {
                controller.alert("Validation Error", message: error.localizedDescription)
            }
        })
        
        controller.textFieldPasswordDelegate = TextFieldDelegate(nextResponser: controller.textFieldConfirmPassword, endEditingBlock: {text in
            do {
                try builder.setPassword(password: text)
            } catch let error {
                controller.alert("Validation Error", message: error.localizedDescription)
            }
        })
        
        controller.textFieldConfirmPasswordDelegate = TextFieldDelegate(nextResponser: nil, endEditingBlock: {text in
            do {
                try builder.setConfirmPassword(password: text)
            } catch let error {
                controller.alert("Validation Error", message: error.localizedDescription)
            }
        })
        
        controller.delegate = SignUpViewControllerDelegateImp(controller: controller, builder: builder)
        
        return controller
    }
}
