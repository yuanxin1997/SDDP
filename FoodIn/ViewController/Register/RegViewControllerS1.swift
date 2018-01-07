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

    // limits access to the source file it is declared in.
    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    let registration = Registration.sharedInstance
    
    @IBOutlet weak var txtName: UITextField!
    
    fileprivate var returnKeyHandler : IQKeyboardReturnKeyHandler!
    override func viewDidLoad() {
        super.viewDidLoad()
        txtName.delegate = self
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler.lastTextFieldReturnKeyType = .done
    } 

    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        registration.name = txtName.text
        print(registration.name)
    }
    
    override func viewWillLayoutSubviews() {
        txtName.setBottomBorder(borderColor: Colors.lightgrey)
        txtName.textAlignment = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let allowedCharacters = CharacterSet.letters
        let characterSet = CharacterSet(charactersIn: string)
        return allowedCharacters.isSuperset(of: characterSet)
    }

}
