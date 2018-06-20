//
//  ChatViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 26/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import JSQMessagesViewController
import Firebase
import FirebaseDatabase

class ChatViewController: JSQMessagesViewController {

    var ref: DatabaseReference!
    
    
    var messages = [JSQMessage]()
    var userDict = User()
    var conversationPath = String()
    var receiveConversationPath = String()
    var receiver_id = String()
    var receiver_name = String()
    lazy var outgoingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }()
    
    lazy var incomingBubble: JSQMessagesBubbleImage = {
        return JSQMessagesBubbleImageFactory()!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        ref = Database.database().reference()
        
        senderId = "\(UserDefaults.standard.value(forKey: "USER_ID") as! Int)"
        print("Sender by userdefault","\(UserDefaults.standard.value(forKey: "USER_ID") as! Int)")
        senderDisplayName = "\(UserDefaults.standard.value(forKey: "USER_NAME") as! String)"
        receiver_id = "\(userDict.id)"
        print("Receiver",receiver_id)
        receiver_name = userDict.name
        
        title = "Chat: \(senderDisplayName!)"
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showDisplayNameDialog))
        tapGesture.numberOfTapsRequired = 1
        
        navigationController?.navigationBar.addGestureRecognizer(tapGesture)
        
        inputToolbar.contentView.leftBarButtonItem = nil
        collectionView.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        // Do any additional setup after loading the view.
        
        receiver_id = "\(userDict.id)"
        senderId = "\(UserDefaults.standard.value(forKey: "USER_ID") as! Int)"
        
        let query = Firebase_Constant.refs.databaseprivate.queryLimited(toLast: 100)
        
        _ = query.observe(.childAdded, with: { [weak self] snapshot in
            
            if  let data        = snapshot.value as? [String: String],
                let id          = data["sender_id"],
                let name        = data["name"],
                let text        = data["text"],
                let receiver     = data["receiver_id"],
                !text.isEmpty
            {
               self?.getMessage(idx: id, receiver: receiver, text: text, name: name)
            }
        })
    }
    
    
    func getMessage(idx : String , receiver : String ,text : String ,name : String)
    {
        print("sender ",  self.senderId, self.receiver_id)
        
        if (idx == self.senderId || idx == self.receiver_id) && (receiver == self.receiver_id || receiver == self.senderId)
        {
            if let message = JSQMessage(senderId: idx, displayName: name, text: text)
            {
                //self?.messages.append(message)
                self.messages.append(message)
                self.finishReceivingMessage()
               // self?.finishReceivingMessage()
            }
        }
        
    }
    
    @objc func showDisplayNameDialog()
    {
        let defaults = UserDefaults.standard
        
        let alert = UIAlertController(title: "Your Display Name", message: "Before you can chat, please choose a display name. Others will see this name when you send chat messages. You can change your display name again by tapping the navigation bar.", preferredStyle: .alert)
        
        alert.addTextField { textField in
            
            if let name = defaults.string(forKey: "jsq_name")
            {
                textField.text = name
            }
            else
            {
                let names = ["Ford", "Arthur", "Zaphod", "Trillian", "Slartibartfast", "Humma Kavula", "Deep Thought"]
                textField.text = names[Int(arc4random_uniform(UInt32(names.count)))]
            }
        }
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak self, weak alert] _ in
            
            if let textField = alert?.textFields?[0], !textField.text!.isEmpty {
                
                self?.senderDisplayName = textField.text
                
                self?.title = "Chat: \(self!.senderDisplayName!)"
                
                defaults.set(textField.text, forKey: "jsq_name")
                defaults.synchronize()
            }
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData!
    {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        print("message count",messages.count)
        
        return messages.count
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource!
    {
        print("message text sender id and receiver id",messages[indexPath.item].senderId , messages[indexPath.item].text , receiver_id)
        return messages[indexPath.item].senderId == senderId ? outgoingBubble : incomingBubble
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource!
    {
        return nil
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAt indexPath: IndexPath!) -> NSAttributedString!
    {
        return messages[indexPath.item].senderId == senderId ? nil : NSAttributedString(string: messages[indexPath.item].senderDisplayName)
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAt indexPath: IndexPath!) -> CGFloat
    {
        return messages[indexPath.item].senderId == senderId ? 0 : 15
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!)
    {
        
        //let ref = self.ref.child("users").child("\(senderDisplayName)_\(senderId)")
        
        //let ref_obj = Firebase_Constant.refs.databaseChats.child("\(senderDisplayName as! String)_\(senderId as! String)")
        
       // print("Receive path ",receiveConversationPath)
       /* if receiveConversationPath != ""
        {
            let ref_obj = Firebase_Constant.refs.databaseChats.child(receiveConversationPath)
            let ref_child = ref_obj.childByAutoId()
            
            let message = ["sender_id": senderId, "name": senderDisplayName, "text": text , "path" : receiveConversationPath]
            
            ref_child.setValue(message)
            
            finishSendingMessage()
        }
        else
        {*/
            let ref_obj = Firebase_Constant.refs.databaseprivate.child("123")           // let ref_child = ref_obj.childByAutoId()
            
        let message = ["sender_id": senderId, "name": senderDisplayName, "text": text ,"receiver_id" : "\(receiver_id )"]
            
            ref_obj.setValue(message)
            
            finishSendingMessage()
       // }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
