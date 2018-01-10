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
    @IBOutlet weak var signInButton: UIButton!
    
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
    

    @IBAction func didPressDoneBtn(_ sender: Any) {
        print(txtEmail.text!)
        print(txtPassword.text!.md5())
        startAnimating(CGSize(width: 50, height: 50), type: .ballPulseSync, color: Colors.white)
        pService.login(email: txtEmail.text!, password: txtPassword.text!.md5(), completion: { (result: Int?) in
            DispatchQueue.global().async {
                if let personId = result {
                    KeychainSwift().set(String(personId), forKey: "id")
                    print("printing keychain get \(Int(KeychainSwift().get("id")!)!)")
                    self.storePersonPersistently(personId: personId)
                    self.dispatchGroup.wait()
                    self.storeIllnessPersistently(personId: personId)
                    self.dispatchGroup.wait()
                    self.storeIndicatorPersistently(personId: personId)
                    self.dispatchGroup.notify(queue: DispatchQueue.main) {
                        Touch3D().enableQuickAction()
                        self.goToHomePage()
                    }
                }
            }
        })
    }
    
    func storePersonPersistently(personId: Int){
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
    
    func storeIllnessPersistently(personId: Int){
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
    
    func storeIndicatorPersistently(personId: Int){
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
    
    func goToHomePage(){
        self.stopAnimating()
        let homePage = self.storyboard?.instantiateViewController(withIdentifier: "homePage") as! HomeViewController
        let nav:UINavigationController = UINavigationController(rootViewController: homePage);
        let appDelegate = UIApplication.shared.delegate
        appDelegate?.window??.rootViewController = nav
    }
    
}
