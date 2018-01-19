//
//  EditIsiBerita.swift
//  INFO DISDIK
//
//  Created by SchoolDroid on 1/16/18.
//  Copyright © 2018 SchoolDroid. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let SelesaiEdit = Notification.Name("SelesaiEdit")
}

class EditIsiBerita: UIViewController {
   
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    var currentIsiBerita = IsiBerita()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        handleTextView()
        handleKeyboard()
    }
    
    
    @IBAction func closeBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func simpanBtn(_ sender: Any) {
        textView.resignFirstResponder()
        currentIsiBerita.berita = textView.text
        let _ = IsiBeritaLite().simpanData(idIsi: currentIsiBerita.idIsi!, idBerita: currentIsiBerita.idBerita!, berita: currentIsiBerita.berita!, foto: currentIsiBerita.foto!, fileUrl: currentIsiBerita.fileUrl!)
      //  NotificationCenter.default.post(name: .SelesaiEdit, object: self)
        self.dismiss(animated: true, completion: nil)
    }
   
    @IBAction func resetBtn(_ sender: Any) {
        textView.text = currentIsiBerita.berita
    }
    
    
    //MARK:- FUNCTION
    
    func handleTextView() {
        let borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.7)
        textView.layer.borderColor = borderColor.cgColor;
        textView.layer.borderWidth = 1.0;
        textView.layer.cornerRadius = 5.0;
        textView.backgroundColor = UIColor.clear
        textView.text = currentIsiBerita.berita
    }
    
    
    func handleKeyboard (){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardShow), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    
    @objc func handleKeyboardShow (notification : NSNotification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey]! as! CGRect
            
            let isKeyboardShow = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            if isKeyboardShow {
                self.bottomConstraint.constant = keyboardFrame.height + 10
                self.view.layoutIfNeeded()
            }
            else {
                navigationItem.leftBarButtonItem = nil
                self.bottomConstraint.constant = 40
                self.view.layoutIfNeeded()
            }
        }
    }
    
    
}
