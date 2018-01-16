//
//  ArtikelBaru.swift
//  Project 1
//
//  Created by SchoolDroid on 12/12/17.
//  Copyright © 2017 SchoolDroid. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@objc protocol ArtikelBaruDelegate {
    @objc optional func getReturn(judul : String , keyword : String , tanggal : String)
    @objc optional func getEdit(judul : String , keyword : String , tanggal : String)
}


class ArtikelBaru : UIViewController, UITextFieldDelegate, UITextViewDelegate {
    
    var delegate : ArtikelBaruDelegate?
    
    @IBOutlet weak var judulTextView: UITextView!
    @IBOutlet weak var keywordTextField: UITextField!
    @IBOutlet weak var tanggalTextField: UITextField!
    
    var isJudulComplete = false
    var isKeywordComplete = false
    
    let datePicker = UIDatePicker()
    
    var judulToEdit = String()
    var keywordToEdit = String()
    var tanggalToEdit = String()
    
    var isEdit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        
        judulTextView.delegate = self
        tanggalTextField.delegate = self
        keywordTextField.delegate = self
        
        initializeTanggalTextField()
        createDatePicker()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simpan", style: .plain, target: self, action: #selector(post))
        
        configureTextView()
        
        checkCompletion()
        
        if isEdit {
            setEdit()
        }
        
    }
    
    //MARK: - IBACTION
   
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - OVERRIDE
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        
        let date = formatter.string(from: datePicker.date)
        tanggalTextField.text = date
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == keywordTextField{
            if keywordTextField.text == "" {
                keywordTextField.text = "#"
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == keywordTextField {
            if string == " " {
                keywordTextField.text = keywordTextField.text! + " #"
                return false
            }
            
            if string == "" {
                // HAPUS
                if keywordTextField.text!.count != 1 {
                    keywordTextField.text = String(keywordTextField.text!.dropLast())
                    
                    if keywordTextField.text!.last == " " {
                        keywordTextField.text = String(keywordTextField.text!.dropLast())
                    }
                }
                
                return false
            }
            
            if keywordTextField.text!.count > 0 {
                isKeywordComplete = true
            } else {
                isKeywordComplete = false
            }
        }
        
        
        checkCompletion()
        
        return true
    }
    
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == judulTextView {
            
            if judulTextView.text!.count > 0 {
                isJudulComplete = true
            }
            else {
                isJudulComplete = false
            }
            
        }
        
        checkCompletion()
    }
    
    //MARK: - FUNCTION
    
    func initializeTanggalTextField () {
        
        let date = Date()
        let formatter = DateFormatter()
        
        formatter.dateFormat = "dd-MM-yyyy"
        
        let today = formatter.string(from: date)
        
        tanggalTextField.text = today
        
    }
    
    @objc func post (){
        let judul = judulTextView.text!
        let keyword = keywordTextField.text!
        let tanggal = tanggalTextField.text!
        
        if isEdit {
            delegate?.getEdit!(judul: judul, keyword: keyword, tanggal: tanggal)
        } else {
            delegate?.getReturn!(judul: judul, keyword: keyword, tanggal: tanggal)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func configureTextView () {
        let borderColor = UIColor.init(red: 204.0/255.0, green: 204.0/255.0, blue: 204.0/255.0, alpha: 0.7)
        judulTextView.layer.borderColor = borderColor.cgColor;
        judulTextView.layer.borderWidth = 1.0;
        judulTextView.layer.cornerRadius = 5.0;
    }
    
    func createDatePicker (){
        datePicker.datePickerMode = .date
        datePicker.locale = Locale(identifier: "id")
        tanggalTextField.inputView = datePicker
    }
    
    func checkCompletion () {
        
        if isJudulComplete && isKeywordComplete {
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
        else {
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
        
    }
    
    func setEdit () {
        
        navigationItem.title = "Sunting Artikel"
        
        judulTextView.text = judulToEdit
        keywordTextField.text = keywordToEdit
        tanggalTextField.text = tanggalToEdit
        
        isJudulComplete = true
        isKeywordComplete = true
        
    }
    
}
