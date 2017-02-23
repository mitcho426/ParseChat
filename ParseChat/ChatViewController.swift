//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Thomas Zhu on 2/22/17.
//  Copyright © 2017 Thomas Zhu. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var chatMessage: UITextField!
    
    var messages : [PFObject]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: "onTimer", userInfo: nil, repeats: true)
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages?.count ?? 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as! messageCell
        
        let message = messages?[indexPath.row]
        let text = message?.value(forKey: "text") as? String
        
        cell.messageLabel.text = text
        
        return cell
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
    
    func onTimer() {
        let query = PFQuery(className:"Message")
        query.findObjectsInBackground { (response: [PFObject]?, error: Error?) in
            if error != nil {
                print("error: \(error)")
            } else {
                //print("response\(response)")
                self.messages = response!
                self.tableView.reloadData()
                
                self.tableViewScrollToBottom(animated: true)
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
