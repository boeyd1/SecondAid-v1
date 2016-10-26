//
//  PasswordPrompt.swift
//  SecondAid
//
//  Created by Desmond Boey on 14/7/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit

class PasswordPrompt {
//    let viewController : SOSViewController?
//    //let viewControllerTextObject : AnyObject?
//    
//    init(vC: SOSViewController){
//     viewController = vC
//    }
    
    weak var delegate : PasswordPromptDelegate?
    
    func createPrompt () -> UIAlertController{
        //create alert view controller
        
        let promptForPassword = UIAlertController(title: "User verification", message: "Please enter the last 4 characters of your password: ", preferredStyle: .Alert)
        
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil)
        
        promptForPassword.addAction(cancel)
        
        let confirm = UIAlertAction(title: "Confirm", style: UIAlertActionStyle.Default, handler: {(action) -> Void in
            
            if let textField = promptForPassword.textFields?.first {
                self.delegate?.passwordSubmitted(textField.text!)
            }
            
        })
        promptForPassword.addAction(confirm)
        
        promptForPassword.addTextFieldWithConfigurationHandler({(textField) -> Void in
            textField.placeholder = "Password"
            textField.secureTextEntry = true
        })
        
        return promptForPassword
    }
}

// class keyword is necessary to limit the adoption of the protocol to classes only. also allows it to be a weak reference

// typically would put the sender class in the parameter too
protocol PasswordPromptDelegate : class{
    func passwordSubmitted(inputPassword: String)
}
