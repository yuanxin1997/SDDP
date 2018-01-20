//
//  RegViewControllerS6.swift
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
import Navajo_Swift

class RegViewControllerS6: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {
    
    // limits access to the source file it is declared in.
    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    let registration = Registration.sharedInstance
    var pService = PersonService()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblPassword: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Initialize
        initForm()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }
    
    override func viewWillLayoutSubviews() {
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
        txtPassword.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
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
        self.view.endEditing(true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // restrict emoji and chinese inputs to textfield (set email textfield delegate to this later)
        return string.canBeConverted(to: String.Encoding.ascii)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        lblEmail.text = ""
        lblPassword.text = ""
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        let password = txtPassword.text ?? ""
        let strength = String(describing: Navajo.strength(ofPassword: password))
        if !txtPassword.hasText {
            lblPassword.text = ""
        } else {
            switch strength {
            case "veryWeak":
                lblPassword.text = "Very weak"
                lblPassword.textColor = Colors.hotRed
            case "weak":
                lblPassword.text = "Weak"
                lblPassword.textColor = Colors.hotRed
            case "reasonable":
                lblPassword.text = "Moderate"
                lblPassword.textColor = Colors.orange
            case "strong":
                lblPassword.text = "Strong"
                lblPassword.textColor = Colors.green
            case "veryStrong":
                lblPassword.text = "Very strong"
                lblPassword.textColor = Colors.green
            default:
                lblPassword.text = "Very weak"
                lblPassword.textColor = Colors.hotRed
            }
        }
    }
    
    @IBAction func doneBtnDidTap(_ sender: Any) {
        
        // Check if field is not empty
        if txtEmail.hasText && txtPassword.hasText {
            
            // Save input to registration singleton
            registration.email = txtEmail.text
            registration.password = txtPassword.text?.md5()
            
            // Instantiate person
            let person = Person(name: registration.name!, email: registration.email!, password: registration.password!, weight: registration.weight!, height: registration.height!, gender: registration.gender!, dob: registration.dob!)
            print(person)
            
            // Reset field to default
            txtEmail.setFieldType(type: .clear)
            txtPassword.setFieldType(type: .clear)
            
            // Check if email format is valid
            if txtEmail.text!.isEmail() {
                
                // Show activity indicator
                self.startAnimating(CGSize(width: 50, height: 50), type: .ballPulseSync, color: Colors.white)
                
                // Check if email is already taken or not
                pService.checkEmail(email: txtEmail.text!, completion: { (result: Int?) in
                    DispatchQueue.global().async {
                        if let result = result {
                            if result == 1 {
                                DispatchQueue.main.async {
                                    self.stopAnimating()
                                    self.lblEmail.text = "Email is taken"
                                    self.txtEmail.setFieldType(type: .error)
                                }
                            } else {
                                print("Can use this email")
                                self.register(person: person)
                            }
                        } else {
                            print("Error encounter: nil value returned")
                        }
                    }
                })
                
                print("Valid email format")
                
            } else {
                lblEmail.text = "Invalid email"
                txtEmail.setFieldType(type: .error)
            }
            
        } else {
            
            if !txtEmail.hasText {
                txtEmail.setFieldType(type: .error)
            }
            
            if !txtPassword.hasText {
                txtPassword.setFieldType(type: .error)
            }
            
        }
    }
    
    func register(person: Person){
        
        // Registering to database and then persist locally
        self.pService.register(person: person, completion: { (result: Int?) in
            DispatchQueue.global().async {
                if let personId = result {
                    KeychainSwift().set(String(personId), forKey: "id")
                    print("printing keychain get \(Int(KeychainSwift().get("id")!)!)")
                    self.storePersonPersistently(person: person)
                    var count = self.registration.illness?.count
                    for illness in self.registration.illness! {
                        self.storeIllnessPersistently(illness: illness)
                        self.pService.addPersonIllness(personId: personId, illnessId: illness.id, completion: { () in
                            count! -= 1
                            print("\(count!) value")
                            if count == 0{
                                print("next")
                                self.storeIndicatorPersistently(personId: personId)
                            }
                        })
                    }
                }
            }
        })
    }
    
    func storePersonPersistently(person: Person){
        MyInfoService().persistMyInfo(person: person)
    }
    
    func storeIllnessPersistently(illness: Illness){
        MyIllnessService().persistMyIllness(illness: illness)
    }
    
    func storeIndicatorPersistently(personId: Int){
        pService.getIllnessIndicator(id: personId, completion: { (result: [Indicator]?) in
            DispatchQueue.main.async() {
                if let indicators = result {
                    for indicator in indicators{
                        MyIndicatorService().persistMyIndicator(indicator: indicator)
                    }
                } else {
                    self.stopAnimating()
                    print("Empty or error")
                }
                self.goToHomePage()
            }
        })
    }
    
    func goToHomePage(){
        self.stopAnimating()
        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "homePage") as! HomeViewController
        let nav:UINavigationController = UINavigationController(rootViewController: homePage);
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = nav
    }
    
}



