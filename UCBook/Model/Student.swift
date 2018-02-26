//
//  Student.swift
//  UCBook
//
//  Created by Trieveon Cooper on 2/11/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import Foundation
import UIKit

class Student: NSObject {
    var uid: String?
    var name: String?
    var key: String?
    var email: String?
    var role: String?
    var profileImageUrl: String?
    init(dictionary: [String: AnyObject]) {
        self.uid = dictionary["uid"] as? String
        self.name = dictionary["name"] as? String
        self.key = dictionary["key"] as? String
        self.email = dictionary["email"] as? String
        self.profileImageUrl = dictionary["profileImageUrl"] as? String
        self.role = dictionary["role"] as? String
    }
}

