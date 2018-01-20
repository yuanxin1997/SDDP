//
//  SignInViewController.swift
//  FoodIn
//
//  Created by Yuanxin Li on 4/1/18.
//  Copyright © 2018 Yuanxin Li. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import CryptoSwift
import KeychainSwift
import NVActivityIndicatorView

class SignInViewController: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    let pService = PersonService()
    let dispatchGroup = DispatchGroup()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    @IBOutlet weak var signInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize
        initForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Customize Navigation bar and Status bar
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle])
    }
    
    override func viewWillLayoutSubviews() {
        // Customize text field to show only bottom border
        txtEmail.setFieldType(type: .clear)
        txtEmail.textAlignment = .center
        
        txtPassword.setFieldType(type: .clear)
        txtPassword.textAlignment = .center
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initForm() {
        txtEmail.delegate = self
        
        // Set up keyboard type
        txtEmail.keyboardType = .emailAddress
        txtPassword.keyboardType = .asciiCapable
        
        // Hide password entry
        txtPassword.isSecureTextEntry = true
        
        // Setup the movement from current text field to the next and previous text field
        txtEmail.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(nextAction), doneAction: #selector(self.nextAction(_:)), shouldShowPlaceholder: true)
        txtPassword.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(nextAction), doneAction: #selector(self.nextAction(_:)), shouldShowPlaceholder: true)
        
        txtEmail.keyboardToolbar.previousBarButton.isEnabled = false;
        txtEmail.keyboardToolbar.nextBarButton.isEnabled = true;
        txtPassword.keyboardToolbar.previousBarButton.isEnabled = true;
        txtPassword.keyboardToolbar.nextBarButton.isEnabled = false;
        
        // Setup return type
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler.lastTextFieldReturnKeyType = .done
        
        // Default labels
        lblEmail.textColor = Colors.hotRed
        lblPassword.textColor = Colors.hotRed
        lblEmail.text = ""
        lblPassword.text = ""
    }
    
    @objc func previousAction(_ sender : UITextField!) {
        if (txtPassword.isFirstResponder)
        {
            txtEmail.becomeFirstResponder()
        }
    }
    
    @objc func nextAction(_ sender : UITextField!) {
        if (txtEmail.isFirstResponder)
        {
            txtPassword.becomeFirstResponder()
        } else {
            self.view.endEditing(true)
        }
    }
    
    @objc func doneAction(_ sender : UITextField!) {
        // Hide keyboard when return button is pressed
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Hide keyboard when touches any where on the screen
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Restrict emoji and chinese inputs to textfield (set email textfield delegate to this later)
        return string.canBeConverted(to: String.Encoding.ascii)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblEmail.text = ""
        lblPassword.text = ""
    }

    @IBAction func didPressDoneBtn(_ sender: Any) {
        
        // Check if field is not empty
        if txtEmail.hasText && txtPassword.hasText {

            // Reset field to default
            txtEmail.setFieldType(type: .clear)
            txtPassword.setFieldType(type: .clear)
            
            // Hash the password and login
            login(email: txtEmail.text!, password: txtPassword.text!.md5())
            
        } else {
            
            if !txtEmail.hasText {
                txtEmail.setFieldType(type: .error)
            }
            
            if !txtPassword.hasText {
                txtPassword.setFieldType(type: .error)
            }
            
        }
        
    }
    
    func login(email: String, password: String) {
        
        // Show activity indicator
        startAnimating(CGSize(width: 50, height: 50), type: .ballPulseSync, color: Colors.white)
        
        // Check login credentials with database
        pService.login(email: email, password: password, completion: { (result: Int?) in
            DispatchQueue.global().async {
                if let personId = result {
                    if personId == 0 {
                        DispatchQueue.main.async {
                            self.stopAnimating()
                            self.lblEmail.text = "Re-enter"
                            self.txtEmail.setFieldType(type: .error)
                            self.lblPassword.text = "Re-enter"
                            self.txtPassword.setFieldType(type: .error)
                        }
                    } else {
                        // Store the person id in keychain
                        KeychainSwift().set(String(personId), forKey: "id")
                        
                        // Persists the data received locally
                        self.storePersonPersistently(personId: personId)
                        self.dispatchGroup.wait()
                        self.storeIllnessPersistently(personId: personId)
                        self.dispatchGroup.wait()
                        self.storeIndicatorPersistently(personId: personId)
                        
                        // Go to home page after persisting the data
                        self.dispatchGroup.notify(queue: DispatchQueue.main) {
                            // Enable 3D touch feature after sign in
                            Touch3D().enableQuickAction()
                            self.goToHomePage()
                        }
                    }
                } else {
                    self.stopAnimating()
                    print("Empty or error")
                }
            }
        })
    }
    
    // Person data to be persist
    func storePersonPersistently(personId: Int) {
        dispatchGroup.enter()
        pService.getPersonDetails(id: personId, completion: { (result: Person?) in
            DispatchQueue.global().async(group: self.dispatchGroup) {
                if let person = result {
                    MyInfoService().persistMyInfo(person: person)
                }
                self.dispatchGroup.leave()
            }
        })
    }
    
    // Illness data to be persist
    func storeIllnessPersistently(personId: Int) {
        dispatchGroup.enter()
        pService.getPersonIllness(id: personId, completion: { (result: [Illness]?) in
            DispatchQueue.global().async(group: self.dispatchGroup) {
                if let illnesses = result {
                    for illness in illnesses{
                        MyIllnessService().persistMyIllness(illness: illness)
                    }
                }
                self.dispatchGroup.leave()
            }
        })
    }
    
    // Indicator data to be persists
    func storeIndicatorPersistently(personId: Int) {
        dispatchGroup.enter()
        pService.getIllnessIndicator(id: personId, completion: { (result: [Indicator]?) in
            DispatchQueue.global().async(group: self.dispatchGroup) {
                if let indicators = result {
                    for indicator in indicators{
                        MyIndicatorService().persistMyIndicator(indicator: indicator)
                    }
                }
                self.dispatchGroup.leave()
            }
        })
    }
    
    // Change rootview to HomePage
    func goToHomePage(){
        self.stopAnimating()
        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "homePage") as! HomeViewController
        let nav:UINavigationController = UINavigationController(rootViewController: homePage);
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = nav
    }
    
}
