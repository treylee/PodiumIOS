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

class Message: NSObject {
    
    var sendingStudent: String?
    var msg: String?
    var timestamp: NSNumber?
    var recievingStudent: String?
    var imageUrl: String?
    var videoUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
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
    
    func chatPartnerId() -> String? {
        return sendingStudent == Auth.auth().currentUser?.uid ? recievingStudent : sendingStudent
    }
    
}
