//
//  RegisterViewController.swift
//  login
//
//  Created by Sharath Koochana on 9/5/16.
//  Copyright © 2016 tim. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {
    
    var message : String = ""
    
    @IBOutlet weak var nameTxt: UITextField!
    @IBOutlet weak var userNameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var confirmPasswordTxt: UITextField!
    
    
    @IBAction func onRegiter(sender: AnyObject) {
        
        let name = nameTxt.text
        let userName = userNameTxt.text
        let password = passwordTxt.text
        let confirmPassword = confirmPasswordTxt.text
        
        // Check for empty feilds
        
        if ( name!.isEmpty || userName!.isEmpty || password!.isEmpty || confirmPassword!.isEmpty)
        {
            // Diplay alert
            displayAlertMessage( "All fields are mandatory")
            return
            
        }
        
        // Check if user passwords matches
        if ( password != confirmPassword )
            
        {
            // Diplay alert
            displayAlertMessage( "Passwords do not match")
            return
        }
        
        // Save user data
        
        let parameters = ["username":userName!, "password":password!,"name":name!] as Dictionary<String, String>
        let request = NSMutableURLRequest(URL: NSURL(string: "http://67.205.133.173/userauthentication/public/index.php/api/v1/auth/register")!)
        
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        //Note : Add the corresponding "Content-Type" and "Accept" header. In this example I had used the application/json.
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let task = session.dataTaskWithRequest(request) { data, response, error in
            guard data != nil else {
                print("no data found: \(error)")
                return
            }
            
            do {
                if let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print("Response: \(json)")
                    
                    self.message  = json["message"] as! NSString as String
                    self.displayAlertMessage ( self.message )
                    
                    
                } else {
                    let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)// No error thrown, but not NSDictionary
                    print("Error could not parse JSON: \(jsonStr)")
                }
            } catch let parseError {
                print(parseError)// Log the error thrown by `JSONObjectWithData`
                let jsonStr = NSString(data: data!, encoding: NSUTF8StringEncoding)
                print("Error could not parse JSON: '\(jsonStr)'")
            }
        }
        
        task.resume()
        
    }
    
    func displayAlertMessage(message: String){
        
        dispatch_async(dispatch_get_main_queue()) {
            let myAlert = UIAlertController(title:"Alert", message: message, preferredStyle: UIAlertControllerStyle.Alert);
            
            let okAction = UIAlertAction(title:"Ok", style:UIAlertActionStyle.Default){ action in
                // self.dismissViewControllerAnimated(true, completion:nil);
            }
            
            myAlert.addAction(okAction);
            self.presentViewController(myAlert, animated:true, completion:nil);
            
            
            self.nameTxt.text = ""
            self.userNameTxt.text = ""
            self.passwordTxt.text = ""
            self.confirmPasswordTxt.text = ""
            
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
