//
//  LoginVC.swift
//  Pickup
//
//  Created by Robert Puryear on 6/25/18.
//  Copyright © 2018 Robert Puryear. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, Alertable{
    
    @IBOutlet weak var emailField: RoundedCornerTextField!
    @IBOutlet weak var passwordField: RoundedCornerTextField!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var authBtn: RoundedShadowButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.bindtoKeyboard()
        emailField.delegate = self
        passwordField.delegate = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTap(sender:)))
        self.view.addGestureRecognizer(tap)
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleScreenTap(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // this is where we create a driver or passenger with information (userData)
    @IBAction func authBtnWasPressed(_ sender: Any) {
        if emailField.text != nil && passwordField.text != nil{
            authBtn.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let email = emailField.text, let password = passwordField.text{
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    if error == nil{
                        // if the user exists
                        if let user = user{
                            // is passenger
                            if self.segmentedControl.selectedSegmentIndex == 0{
                                let userData = ["provider":user.providerID] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            }else{
                                // is driver
                                let userData = ["provider":user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        self.dismiss(animated: true, completion: nil)
                    }else{
                        // if there was an error when signing in
                        if let errorCode = AuthErrorCode(rawValue: error!._code){
                            switch errorCode {
                            case .wrongPassword:
                                self.showAlert("Wrong password. Please try again")
                            default:
                                self.showAlert("Unexpected error occured. Please try again")
                            }
                        }
                        
                        // if the user doesn't exist, create one
                        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                            if error != nil{
                                if let errorCode = AuthErrorCode(rawValue: error!._code){
                                    switch errorCode {
                                    case .invalidEmail:
                                        self.showAlert("Email invalid. Please try again")
                                    case .emailAlreadyInUse:
                                        self.showAlert("Email in use")
                                    default:
                                        self.showAlert("An error occured. Please try again")
                                    }
                                }
                            }else{
                                if let user = user{
                                    // is passenger
                                    if self.segmentedControl.selectedSegmentIndex == 0{
                                        let userData = ["provider":user.providerID] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    }else{
                                        // is driver
                                        let userData = ["provider":user.providerID, "userIsDriver": true, "isPickupModeEnabled": false, "driverIsOnTrip": false] as [String: Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                }   // sign in
            }
        }
    }
}
