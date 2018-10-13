//
//  Book.swift
//  UCBook
//
//  Created by Trieveon Cooper on 5/26/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class Book: NSObject{
     var isbn: String?
     var meetingPlace: String?
     var price: String?
     var photos: NSArray?
     var title: String?
     var isExpanded = false
    init?(dictionary: [String: Any]) {
        
        self.isbn = dictionary["isbn"] as? String
        self.meetingPlace = dictionary["meetingPlace"] as? String
        self.price = dictionary["price"] as? String
        self.photos = dictionary["photos"] as? NSArray
        self.title = dictionary["title"] as? String
        
  }
}
