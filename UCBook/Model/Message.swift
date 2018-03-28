//
//  Message.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/11/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit
import Firebase

// has to be objc key value compliance belongs to C in swift 4o2
class Message: NSObject {
    
    @objc var fromID: String?
    @objc var msg: String?
    @objc var timeStamp: NSNumber?
    @objc var toID: String?
    
    /*
    init(dictionary: [String: Any]) {
        self.sendingStudent = dictionary["sendingStudent"] as? String
        self.msg = dictionary["msg"] as? String
        self.recievingStudent = dictionary["recievingStudent"] as? String
        self.timestamp = dictionary["timestamp"] as? NSNumber
        self.imageUrl = dictionary["imageUrl"] as? String
        self.videoUrl = dictionary["videoUrl"] as? String
        self.imageWidth = dictionary["imageWidth"] as? NSNumber
        self.imageHeight = dictionary["imageHeight"] as? NSNumber
    }
    */
    func chatPartnerId() -> String? {
        
        if fromID ==  Auth.auth().currentUser?.uid {
            return toID
        } else {
            return fromID
        }
    }
 
}
