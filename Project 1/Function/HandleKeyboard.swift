//
//  HandleKeyboard.swift
//  Project 1
//
//  Created by SchoolDroid on 12/16/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit

class HandleKeyboard {
    
    var constraint : NSLayoutConstraint = NSLayoutConstraint()
    var sender = UIViewController()
    
    init (object : Any , sender : UIViewController , bottomConstraint : NSLayoutConstraint){
        self.sender = sender
        constraint = bottomConstraint
        NotificationCenter.default.addObserver(object, selector: #selector(handleKeyboardShow(_:)), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(object, selector: #selector(handleKeyboardShow(_:)), name: Notification.Name.UIKeyboardWillHide, object: nil)
        
    }
    
    @objc internal func handleKeyboardShow (_ notification : Notification) -> Void {
        
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]! as! CGRect
            print(keyboardFrame)
            
            let isKeyboardShow = notification.name == Notification.Name.UIKeyboardWillShow
            
            if isKeyboardShow {
                self.constraint.constant = -keyboardFrame.height
                sender.view.layoutIfNeeded()
            }
            else {
                self.constraint.constant = 0
                sender.view.layoutIfNeeded()
            }
        }
        
        return
    }
    
}
