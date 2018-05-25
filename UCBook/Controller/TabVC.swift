//
//  TabVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 4/2/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit

class TabVC: UITabBarController {
    
    override func viewDidLoad() {
        self.selectedIndex = 1
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
    }
  
    
    @objc func swiped(_ gesture: UISwipeGestureRecognizer) {
        print("got a swipe",gesture.direction)
        if gesture.direction == .left {
            if (self.selectedIndex) <= 2 { // set your total tabs here
                self.selectedIndex += 1
            }
        } else if gesture.direction == .right {
            if (self.selectedIndex) >= 0 {
                self.selectedIndex -= 1
            }
        }
    }
}
