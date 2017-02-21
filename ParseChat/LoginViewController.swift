//
//  ViewController.swift
//  ParseChat
//
//  Created by Chandler Griffin on 2/1/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class LoginViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var delay: Double = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(_ sender: Any) {
        let email = (emailField.text?.lowercased())!
        let password = passwordField.text!
        
        if email.characters.count == 0 {
            displayWarning(message: "Email field is empty.")
            return
        } else if password.characters.count == 0 {
            displayWarning(message: "Password field is empty.")
            return
        }   else    {
            PFUser.logInWithUsername(inBackground: email, password: password) { (user: PFUser?, error: Error?) in
                if(user != nil)  {
                    self.displayMessage(message: "Signing in...")
                    self.emptyFields()
                    self.delay(delay: self.delay)   {
                        self.performSegue(withIdentifier: "chatSegue", sender: nil)
                        self.endHUD()
                    }
                }   else    {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    @IBAction func onSignUp(_ sender: Any) {
        let email = (emailField.text?.lowercased())!
        let password = passwordField.text!
        
        if email.characters.count == 0 {
            displayWarning(message: "Email field is empty.")
            return
        } else if password.characters.count == 0 {
            displayWarning(message: "Password field is empty.")
            return
        }   else    {
            let newUser = PFUser()
            newUser.username = email
            newUser.password = password
            
            newUser.signUpInBackground { (success: Bool, error: Error?) in
                if(success) {
                    self.displayMessage(message: "Signing up...")
                    self.emptyFields()
                    self.delay(delay: self.delay)   {
                        self.performSegue(withIdentifier: "chatSegue", sender: nil)
                        self.endHUD()
                    }
                }   else    {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    func emptyFields()  {
        emailField.text = ""
        passwordField.text = ""
    }
    
    func displayMessage(message: String?)   {
        //Start Loading with MBProgressHUD
        let loadingNotification = MBProgressHUD.showAdded(to: self.view, animated: true)
        loadingNotification.mode = MBProgressHUDMode.indeterminate
        loadingNotification.label.text = message!
    }
    
    
    
    func displayWarning(message: String?)   {
        let alertController = UIAlertController(title: "Not so fast", message: message, preferredStyle: .alert)
        // create an OK action
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            // handle response here.
        }
        // add the OK action to the alert controller
        alertController.addAction(OKAction)
        
        present(alertController, animated: true) {
            // optional code for what happens after the alert controller has finished presenting
        }
    }
    
    func delay(delay:Double, closure:@escaping ()->())    {
        let mainQueue = DispatchQueue.main
        let deadline = DispatchTime.now() + delay
        mainQueue.asyncAfter(deadline: deadline){
            closure()
        }
    }
    
    func endHUD()   {
            MBProgressHUD.hideAllHUDs(for: self.view, animated: true)
    }

}

