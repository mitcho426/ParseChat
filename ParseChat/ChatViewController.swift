//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Thomas Zhu on 2/22/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController {

    @IBOutlet weak var chatMessage: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func chatButtonPressed(_ sender: AnyObject) {
        let gameScore = PFObject(className:"Message")
        gameScore["text"] = chatMessage.text!
        gameScore.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                print("Success: \(gameScore["text"])")
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
