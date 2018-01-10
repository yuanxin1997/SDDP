//
//  RegViewControllerS4.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

class RegViewControllerS4: UIViewController {

    // limits access to the source file it is declared in.
    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    let registration = Registration.sharedInstance
    
    @IBOutlet weak var txtWeight: UITextField!
    @IBOutlet weak var txtHeight: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtWeight.keyboardType = .decimalPad
        txtHeight.keyboardType = .decimalPad
        
        txtWeight.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(nextAction), doneAction: #selector(self.nextAction(_:)), shouldShowPlaceholder: true)
        txtHeight.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(nextAction), doneAction: #selector(self.nextAction(_:)), shouldShowPlaceholder: true)
        
        txtWeight.keyboardToolbar.previousBarButton.isEnabled = false;
        txtWeight.keyboardToolbar.nextBarButton.isEnabled = true;
        txtHeight.keyboardToolbar.previousBarButton.isEnabled = true;
        txtHeight.keyboardToolbar.nextBarButton.isEnabled = false;
        
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler.lastTextFieldReturnKeyType = .done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        registration.weight = Double(txtWeight.text!)
        registration.height = Double(txtHeight.text!)
        print(registration.weight)
        print(registration.height)
    }
    
    override func viewWillLayoutSubviews() {
        txtWeight.setBottomBorder(borderColor: Colors.lightgrey)
        txtWeight.textAlignment = .center
        
        txtHeight.setBottomBorder(borderColor: Colors.lightgrey)
        txtHeight.textAlignment = .center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func previousAction(_ sender : UITextField!) {
        
        if (txtHeight.isFirstResponder)
        {
            txtWeight.becomeFirstResponder()
        }
    }
    
    @objc func nextAction(_ sender : UITextField!) {
        
        if (txtWeight.isFirstResponder)
        {
            txtHeight.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
