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

class RegViewControllerS6: UIViewController, UITextFieldDelegate, NVActivityIndicatorViewable {

    // limits access to the source file it is declared in.
    fileprivate var returnHandler : IQKeyboardReturnKeyHandler!
    let registration = Registration.sharedInstance
    var pService = PersonService()
    
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtEmail.delegate = self
        txtEmail.keyboardType = .emailAddress
        txtPassword.keyboardType = .asciiCapable
        txtPassword.isSecureTextEntry = true
        
        txtEmail.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(nextAction), doneAction: #selector(self.nextAction(_:)), shouldShowPlaceholder: true)
        txtPassword.addPreviousNextDoneOnKeyboardWithTarget(self, previousAction: #selector(self.previousAction(_:)), nextAction: #selector(nextAction), doneAction: #selector(self.nextAction(_:)), shouldShowPlaceholder: true)
        
        txtEmail.keyboardToolbar.previousBarButton.isEnabled = false;
        txtEmail.keyboardToolbar.nextBarButton.isEnabled = true;
        txtPassword.keyboardToolbar.previousBarButton.isEnabled = true;
        txtPassword.keyboardToolbar.nextBarButton.isEnabled = false;
        
        returnHandler = IQKeyboardReturnKeyHandler(controller: self)
        returnHandler.lastTextFieldReturnKeyType = .done
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCustomNavStatusBar(setting: [.showNavBar, .greyNavTitle]);
    }
    
    override func viewWillLayoutSubviews() {
        txtEmail.setBottomBorder(borderColor: Colors.lightgrey)
        txtEmail.textAlignment = .center
        
        txtPassword.setBottomBorder(borderColor: Colors.lightgrey)
        txtPassword.textAlignment = .center
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    
    @IBAction func didTapDoneBtn(_ sender: Any) {
        registration.email = txtEmail.text
        registration.password = txtPassword.text?.md5()
        let person = Person(name: registration.name!, email: registration.email!, password: registration.password!, weight: registration.weight!, height: registration.height!, gender: registration.gender!, dob: registration.dob!)
        print(person)
        startAnimating(CGSize(width: 50, height: 50), type: .ballPulseSync, color: Colors.white)
        pService.register(person: person, completion: { (result: Int?) in
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


