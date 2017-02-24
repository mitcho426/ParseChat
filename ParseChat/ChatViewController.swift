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

    let refreshTimeInterval: TimeInterval = 1
    
    @IBOutlet weak var chatMessage: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var messages : [PFObject]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        Timer.scheduledTimer(timeInterval: refreshTimeInterval,
                             target: self,
                             selector: #selector(onTimer),
                             userInfo: nil,
                             repeats: true)
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
    
    @IBAction func chatButtonPressed(_ sender: AnyObject) {
        let gameScore = PFObject(className: "Message")
        gameScore["text"] = chatMessage.text!
        gameScore.saveInBackground {
            (success: Bool, error: Error?) -> Void in
            if (success) {
                self.chatMessage.text = ""
                print("Success: \(gameScore["text"]!)")
            } else {
                print(error?.localizedDescription ?? "error")
            }
        }
    }
    
    func onTimer() {
        let query = PFQuery(className: "Message")
        // Cannot call by byAscending because the limited number of responses API returns
        // Must call byDescending first, then use the reversed method to show most recent message on the bottom
        query.order(byDescending: "createdAt").findObjectsInBackground { (response: [PFObject]?, error: Error?) in
            if let response = response {
                self.messages = response.reversed()
                
                self.tableView.reloadData()
                
                DispatchQueue.main.async {
                    let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            } else {
                print("error: \(error)")
            }
        }
    }
}
