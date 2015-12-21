//
//  ViewController.swift
//  Donate
//
//  Created by Ziad TAMIM on 6/7/15.
//  Copyright (c) 2015 TAMIN LAB. All rights reserved.
//

import UIKit
import Stripe

class ViewController: UITableViewController,UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cardNumberTextField: UITextField!
    @IBOutlet weak var expireDateTextField: UITextField!
    @IBOutlet weak var cvcTextField: UITextField!
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet var textFields: [UITextField]!
    
    // MARK: - Text field delegate 
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        
        return true
    }
    
    
    // MARK: Actions
    
    @IBAction func donate(sender: AnyObject) {
        
        // Initiate the card
        let stripeParams = STPCardParams()
        
        // expiration date must not be empty
        if self.expireDateTextField.text?.isEmpty == false {
            // split the exp date to extra month/year
            
            let expirationDate = self.expireDateTextField.text?.componentsSeparatedByString("/")
            let expMonth = UInt(expirationDate![0])
            let expYear = UInt(expirationDate![1])
            
            
            // Send the card info to Stripe to get the token
            stripeParams.number =  self.cardNumberTextField.text
            stripeParams.cvc = self.cvcTextField.text
            stripeParams.expMonth = expMonth!
            stripeParams.expYear = expYear!

        }
        
        do {
            
        
            try stripeParams.validateCardReturningError()
        } catch _{
            self.spinner.startAnimating()
            print("card validation error...")
        }
        
        STPAPIClient.sharedClient().createTokenWithCard(stripeParams) { (token, error) -> Void in
            if error != nil {
                print("error creating token server side")
            }
            
            
            // TODO: - post StripeToken!!!!
            //self.postStripeToken(token!)
            
        }
    
    }
    
    
    /*
    
    func postStripeToken(token: STPToken) {
        
        let URL = "http://localhost/donate/payment.php"
        let params = ["stripeToken": token.tokenId ,
            "amount": Int(self.amountTextField.text!),
            "currency": "usd",
            "description": self.emailTextField.text]
        
        let manager = AFHTTPRequestOperationManager()
        manager.POST(URL, parameters: params, success: { (operation, responseObject) -> Void in
            
            if let response = responseObject as? [String: String] {
                UIAlertView(title: response["status"],
                    message: response["message"],
                    delegate: nil,
                    cancelButtonTitle: "OK").show()
            }
            
            }) { (operation, error) -> Void in
                self.handleError(error!)
        }
    }
    
    */
    

}

