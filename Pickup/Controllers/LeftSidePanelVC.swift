//
//  LeftSidePanelVC.swift
//  Pickup
//
//  Created by Robert Puryear on 6/24/18.
//  Copyright © 2018 Robert Puryear. All rights reserved.
//

import UIKit
import Firebase

class LeftSidePanelVC: UIViewController {

    @IBOutlet weak var userEmailLabel: UILabel!
    @IBOutlet weak var userAccountTypeLabel: UILabel!
    @IBOutlet weak var userImageView: RoundImageView!
    @IBOutlet weak var loginLogoutLabel: UIButton!
    @IBOutlet weak var pickupModeLabel: UILabel!
    @IBOutlet weak var pickupModeSwitch: UISwitch!
    
    let appDelegate = AppDelegate.getAppDelegate()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // switch is off by default
        pickupModeSwitch.isOn = false
        pickupModeSwitch.isHidden = true
        pickupModeLabel.isHidden = true
        
        // get user details
        observePassengersAndDrivers()
        
        // if user is not logged in
        if Auth.auth().currentUser == nil{
            self.userEmailLabel.text = ""
            self.userAccountTypeLabel.text = ""
            self.userImageView.isHidden = true
            self.loginLogoutLabel.setTitle("Sign Up / Login", for: .normal)
        }else{
            // if user is logged in
            self.userEmailLabel.text = Auth.auth().currentUser?.email
            self.userAccountTypeLabel.text = ""
            self.userImageView.isHidden = false
            self.loginLogoutLabel.setTitle("Logout", for: .normal)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }


    @IBAction func signUpLoginBtnWasPressed(_ sender: Any) {
        // is user is signed out
        if Auth.auth().currentUser == nil{
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as? LoginVC
            present(loginVC!, animated: true, completion: nil)
        }else{
            do {
                try Auth.auth().signOut()
                self.userEmailLabel.text = ""
                self.userAccountTypeLabel.text = ""
                self.userImageView.isHidden = true
                self.pickupModeLabel.isHidden = true
                self.pickupModeSwitch.isHidden = true
                self.loginLogoutLabel.setTitle("Sign Up / Login", for: .normal)
            } catch (let error) {
                print(error)
            }
        }
        
    }
    
    @IBAction func switchWasToggled(_ sender: Any) {
        if pickupModeSwitch.isOn{
            self.pickupModeLabel.text = "Pickup Mode Enabled"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["isPickupModeEnabled":true])
        }else{
            self.pickupModeLabel.text = "Pickup Mode Disabled"
            appDelegate.MenuContainerVC.toggleLeftPanel()
            DataService.instance.REF_DRIVERS.child((Auth.auth().currentUser?.uid)!).updateChildValues(["isPickupModeEnabled":false])
        }
    }
    
    
    func observePassengersAndDrivers(){
        // check for user details
        DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
            // get all of the children and objects within the child for the user
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                // looking for current user's id
                for snap in snapshot{
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLabel.text = "PASSENGER"
                    }
                }
            }
        })
        // check for driver details
        DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value, with: { (snapshot) in
            // get all of the children and objects within the child for the user
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                // get details about driver
                for snap in snapshot{
                    if snap.key == Auth.auth().currentUser?.uid{
                        self.userAccountTypeLabel.text = "DRIVER"
                        self.pickupModeSwitch.isHidden = false
                        // get the value for isPickupModeEnabled
                        let switchStatus = snap.childSnapshot(forPath: "isPickupModeEnabled").value as! Bool
                        self.pickupModeSwitch.isOn = switchStatus
                        self.pickupModeLabel.isHidden = false
                    }
                }
            }
        })

    }



}

















