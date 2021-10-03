//
//  ChatViewController.swift
//  Relatable
//
//  Created by Felix Izarra on 10/2/21.
//

import Foundation
import UIKit
import Photos
import AVKit

class ChatViewController: BaseViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    let messages : [String] = ["A-Message 1","B-message 2", "A-messs 3"]
    

    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textField.delegate = self
        
        
        
        initializeHideKeyboard()
        
        let nib = UINib(nibName: "SenderTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "SenderTableViewCell")
        
        let nib2 = UINib(nibName: "ReceiverTableViewCell", bundle: nil)
        self.tableView.register(nib2, forCellReuseIdentifier: "ReceiverTableViewCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let command = StaticData.convoPieces[indexPath.row].split(separator: "=")
    
        print(command)
        if StaticData.parent {
            if command[0] == "B"
            {
                let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
                if command[1] == "T"
                {
                    cell.message.text = String(command[2])
                }
                else
                {
                    cell.message.text = "[PLAY VIDEO]"
                    cell.url = String(command[2])
                    cell.playBtn.isHidden = false
                    cell.playBtn.isUserInteractionEnabled = true
                    cell.parentView = self
                }
                
                cell.bg.layer.cornerRadius = 10.0
                print("here  better")
               
                return cell
            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
            
            if command[1] == "T"
            {
                cell.message.text = String(command[2])
            }
            else
            {
                cell.message.text = "[PLAY VIDEO]"
                cell.url = String(command[2])
                cell.playBtn.isHidden = false
                cell.playBtn.isUserInteractionEnabled = true
                cell.parentView = self
            }
            
            cell.bg.layer.cornerRadius = 10.0
            print("here  better")
            return cell
        }
        
        if command[0] == "D"
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SenderTableViewCell") as! SenderTableViewCell
            if command[1] == "T"
            {
                cell.message.text = String(command[2])
            }
            else
            {
                cell.message.text = "[PLAY VIDEO]"
                cell.url = String(command[2])
                cell.playBtn.isHidden = false
                cell.playBtn.isUserInteractionEnabled = true
                cell.parentView = self
                
            }
            
            cell.bg.layer.cornerRadius = 10.0
            print("here  better")
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReceiverTableViewCell") as! ReceiverTableViewCell
        
        if command[1] == "T"
        {
            cell.message.text = String(command[2])
        }
        else
        {
            cell.message.text = "[PLAY VIDEO]"
            cell.url = String(command[2])
            cell.playBtn.isHidden = false
            cell.playBtn.isUserInteractionEnabled = true
            cell.parentView = self
        }
        
        cell.bg.layer.cornerRadius = 10.0
        print("here  betters")
        
        
        return cell
        
           
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("ROWS \(StaticData.convoPieces.count)")
        return StaticData.convoPieces.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Row selected \(indexPath.row)")
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -300 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromAllNotifications()
    }
    
    public func playVideo(_ url: String)
    {
        print("Play video at \(url)")

        DispatchQueue.main.async {
            
            let player = AVPlayer(url: URL(fileURLWithPath: url))
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player
                self.present(playerViewController, animated: true) {
                  playerViewController.player?.play()
                }
        }

    }
    
    internal func albumAssetCollection(withTitle title: String) -> PHAssetCollection? {
        let predicate = NSPredicate(format: "localizedTitle = %@", title)
        let options = PHFetchOptions()
        options.predicate = predicate
        let result = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: options)
        if result.count > 0 {
            let _ = result.firstObject
            
            return result.firstObject
        }
        return nil
    }
    
    @IBAction func sendMess(_ sender: Any) {
        print("The user sent this message: \(textField.text)")
        var newInput: String = ""
        if StaticData.parent
        {
            newInput = "-B=T=\(textField.text!)"
        }
        else
        {
            newInput = "-D=T=\(textField.text! )"
        }
        
        StaticData.shared.conversation.append(newInput)
        StaticData.convoPieces = StaticData.shared.conversation.split(separator: "-")
        
        tableView.reloadData()
        textField.text = ""
    }
    
    
    

}

extension ChatViewController {
    
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        //endEditing causes the view (or one of its embedded text fields) to resign the first responder status.
        //In short- Dismiss the active keyboard.
        view.endEditing(true)
    }
}

extension ChatViewController {
    
    func subscribeToNotification(_ notification: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: notification, object: nil)
    }
    
    func unsubscribeFromAllNotifications() {
        NotificationCenter.default.removeObserver(self)
    }

}

extension ChatViewController: UIGestureRecognizerDelegate {

public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if touch.view is UIButton {
        return false
    }
    return true
}
}
