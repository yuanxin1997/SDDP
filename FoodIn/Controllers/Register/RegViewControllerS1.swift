//
//  RegViewControllerS1.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RegViewControllerS1: UIViewController, UITextFieldDelegate {

    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    let registration = Registration.sharedInstance
    
    @IBOutlet weak var txtName: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize
        initForm()
    } 

    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }

    override func viewWillLayoutSubviews() {
        // Customize text field to show only bottom border
        txtName.setFieldType(type: .clear)
        txtName.textAlignment = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hide keyboard when touches any where on the screen
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Limit to only letters
        // No numbers
        // No emoji
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }
    
    func initForm(){
        txtName.delegate = self
        
        // Setup return type
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler.lastTextFieldReturnKeyType = .done
    }
    
    @IBAction func nextBtnDidTap(_ sender: Any) {
        
        // Check if field is not empty
        if txtName.hasText {
            
            // Save input to registration singleton
            registration.name = txtName.text
            print(registration.name)
            
            // Reset field to default
            txtName.setFieldType(type: .clear)
            
            // Proceed to next page
            performSegue(withIdentifier: "showRegS2", sender: nil)
            
        } else {
            txtName.setFieldType(type: .error)
        }
    }

}
