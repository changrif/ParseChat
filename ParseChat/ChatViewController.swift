//
//  ChatViewController.swift
//  ParseChat
//
//  Created by Chandler Griffin on 2/21/17.
//  Copyright © 2017 Chandler Griffin. All rights reserved.
//

import UIKit
import Parse

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageField: UITextField!
    
    var messages: [PFObject]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        
        self.queryMessages()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ChatViewController.onTimer), userInfo: nil, repeats: true)
        messageField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCell") as! MessageCell
        cell.messageLabel.text = message["text"] as! String!
        if let user = message["user"] as? PFUser    {
            cell.triggerUser(user: user)
        }   else    {
            cell.hideUser()
        }
        return cell
    }
    
    func onTimer()  {
        tableView.reloadData()
    }
    
    @IBAction func sendMessage(_ sender: Any) {
        let text = messageField.text!
        messageField.text = ""
        
        if text == ""    {
            displayWarning(message: "Your message is empty.")
        }   else    {
            let message = PFObject(className:"Message")
            message["text"] = text
            message["user"] = PFUser.current()
            message.saveInBackground {
                (success: Bool, error: Error?) in
                if (success) {
                    self.queryMessages()
                } else {
                    print(error?.localizedDescription as Any)
                }
            }
        }
    }
    
    func queryMessages(){
        let query = PFQuery(className:"Message")
        query.addDescendingOrder("createdAt")
            query.includeKey("user")
        query.findObjectsInBackground(block: { (objects: [PFObject]?, error: Error?) in
            self.messages = objects! as [PFObject]
            self.tableView.reloadData()
        })
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
