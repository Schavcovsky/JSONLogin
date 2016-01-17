//
//  LoginViewController.swift
//  Easy Parking
//
//  Created by Empresas Disruptiva SPA on 01-12-15.
//  Copyright © 2015 Empresas Disruptiva SPA. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet weak var emailTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    
    
    @IBAction func loginBtn(sender: AnyObject)
    {
        let username:NSString = emailTxt.text!
        let password:NSString = passwordTxt.text!
        
        if ( username.isEqualToString("") || password.isEqualToString("") ) {
            
            let alertView:UIAlertView = UIAlertView()
            alertView.title = "Sign in Failed!"
            alertView.message = "Please enter Username and Password"
            alertView.delegate = self
            alertView.addButtonWithTitle("OK")
            alertView.show()
        } else {
            
            do {
                let post:NSString = "&user=\(username)&password=\(password)"
                
                NSLog("PostData: %@",post);
                
                let url:NSURL = NSURL(string:"http://app.easyparking.cl/userGestion.php?funcion=valida_usuario")!
                
                let postData:NSData = post.dataUsingEncoding(NSASCIIStringEncoding)!
                
                let postLength:NSString = String( postData.length )
                
                let request:NSMutableURLRequest = NSMutableURLRequest(URL: url)
                request.HTTPMethod = "POST"
                request.HTTPBody = postData
                request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
                request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                request.setValue("application/json", forHTTPHeaderField: "Accept")
                
                
                var reponseError: NSError?
                var response: NSURLResponse?
                
                var urlData: NSData?
                do {
                    urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
                } catch let error as NSError {
                    reponseError = error
                    urlData = nil
                }
                
                if ( urlData != nil ) {
                    let res = response as! NSHTTPURLResponse!;
                    
                    NSLog("Response code: %ld", res.statusCode);
                    
                    if (res.statusCode >= 200 && res.statusCode < 300)
                    {
                        let dataArray = try NSJSONSerialization.JSONObjectWithData(urlData!, options: .AllowFragments) as? [Dictionary<String, AnyObject>]
                        
                        
                        if let cod = dataArray![0]["cod"] as? NSString {
                            
                        }
                        
                        if let sess = dataArray![0]["sess"] as? String {
                            
                        }
                        
                        if let nombre = dataArray![0]["nombre"] as? String {
                            
                        }
                        
                        //var error: NSError?
                        
                      let jsonData = try! NSJSONSerialization.JSONObjectWithData(urlData!, options: .AllowFragments) as? [[String:AnyObject]] // <-- i have change it to be an aray of dictionary
                      
                      // here you have to downcast the value of 'NSTaggedPointerString' to a doubeleValue
                      // cod is coming as 'NSTaggedPointerString'
                      let codValue = (jsonData!.last!["cod"] as! NSString).doubleValue
                      let cod = Int(codValue)

                        
                        //[jsonData[@"success"] integerValue];
                        
                        NSLog("Success: %ld", cod);
                        
                        if(cod == 1)
                        {
                            NSLog("Login SUCCESS");
                            
                            let prefs:NSUserDefaults = NSUserDefaults.standardUserDefaults()
                            prefs.setObject(username, forKey: "USERNAME")
                            prefs.setInteger(1, forKey: "ISLOGGEDIN")
                            prefs.synchronize()
                            
                            self.dismissViewControllerAnimated(true, completion: nil)
                        } else {
                            var error_msg:NSString
                            
                          // same here check it as array of dictionary
                          if jsonData!.last!["error_message"] as? String != nil {
                            error_msg = jsonData!.last!["error_message"] as! String
                          } else {
                            error_msg = "Unknown Error"
                          }
                          
                          // this how you should present alert in swift
                          // make a func of alertView and pass it here to be more dry 
                          
                          let alertView = UIAlertController(title: "Sign in Failed!", message: "\(error_msg)", preferredStyle: .Alert)
                          alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                          presentViewController(alertView, animated: true, completion: nil)
                        }
                        
                    } else {
                      //newer style
                      let alertView = UIAlertController(title: "Sign in Failed!", message: "Connection Failed", preferredStyle: .Alert)
                      alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                      presentViewController(alertView, animated: true, completion: nil)
                    }
                } else {
                  //newer style
                  var mesg = "Connection Failure"
                  if let error = reponseError {
                    mesg = (error.localizedDescription)
                  }
                  let alertView = UIAlertController(title: "Sign in Failed!", message: mesg, preferredStyle: .Alert)
                  alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
                  presentViewController(alertView, animated: true, completion: nil)
                }
            } catch {
              let alertView = UIAlertController(title: "Sign in Failed!", message: "Server Error", preferredStyle: .Alert)
              alertView.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
              presentViewController(alertView, animated: true, completion: nil)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
