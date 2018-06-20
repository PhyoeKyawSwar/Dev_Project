//
//  Firebase_Constant.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 26/11/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct Firebase_Constant
{
    struct refs
    {
        static let databaseRoot = Database.database().reference()
        static let databasechat = databaseRoot.child("chat")
        static let databaseprivate = databaseRoot.child("private_chat")
        static let databasegroup = databaseRoot.child("chat/group_chat")
        static let databaseuser = databaseRoot.child("users")
        
       // let databaseChats  = databaseRoot.child(chatName)
        
    }
    
    
}

