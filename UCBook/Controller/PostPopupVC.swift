//
//  PostPopupVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 4/16/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
protocol sendDataToViewProtocol {
    func inputData(data:String)
}

class PostPopupVC : UIViewController {
    
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var instructorText: UITextField!
    
    @IBOutlet weak var isbnText: UITextField!
    
    @IBOutlet weak var meetingPlaceText: UITextField!
    var delegate:sendDataToViewProtocol? = nil

    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }
    override func viewDidLayoutSubviews() {
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        addButton.clipsToBounds = true

    }
    @IBAction func dismissView(_ sender: Any) {
        delegate?.inputData(data: "sending data")
        dismiss(animated: true, completion: nil)

    }
    @IBAction func priceSlider(_ sender: Any) {
        priceLabel.text = String(Int((sender as! UISlider).value))
    }
}
