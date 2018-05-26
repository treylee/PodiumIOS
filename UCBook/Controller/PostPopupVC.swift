//
//  PostPopupVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 4/16/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase


class PostPopupVC : UIViewController,UIPickerViewDelegate, UIPickerViewDataSource {
    var priceText =  0
    var list = [String]()
    var courseList = [String]()
    var didSelectCourse = false;
    var didSelectSubject = false;
    var subjectText = ""
    var courseText = ""
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var commentsTexrt: UITextView!
    @IBOutlet weak var instructorText: UITextField!
    
    @IBOutlet weak var isbnText: UITextField!
    
    @IBOutlet weak var meetingPlaceText: UITextField!

    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var subjectPicker: UIPickerView!
    
    @IBOutlet weak var coursePicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subjectPicker.dataSource = self
        subjectPicker.delegate = self
        coursePicker.delegate = self
        coursePicker.dataSource = self
        loadSubjects()
        
    }
    override func viewDidLayoutSubviews() {
        addButton.layer.cornerRadius = addButton.frame.size.height/2
        addButton.clipsToBounds = true

    }
    @IBAction func dismissView(_ sender: Any) {
       // delegate?.inputData(data: "sending data")
        dismiss(animated: true, completion: nil)

    }
    @IBAction func priceSlider(_ sender: Any) {
        priceLabel.text = String(Int((sender as! UISlider).value))
        priceText = Int((sender as! UISlider).value)
    }
    
    @IBAction func postClick(_ sender: Any) {
        if titleText.text?.isEmpty == false &&
           isbnText.text?.isEmpty == false &&
           meetingPlaceText.text?.isEmpty == false &&
            priceText != 0 {
            let tmpPrice = String(priceText)
            let values  = ["title": titleText.text!,"isbn" : isbnText.text! , "meetingPlace": meetingPlaceText.text , "price":tmpPrice] as [String : Any]
            
                var random = arc4random_uniform(21) + 10
            
            
            print("c",subjectText,"s",courseText)
            
            Database.database().reference().child("books").child(subjectText).child(courseText).child(String(random)).updateChildValues(values)  { (error,ref) in
                if error != nil {
                    print(error)
                    return
                }
                
            }
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(pickerView.tag,"pickerView tag")
        if pickerView.tag == 15 {
            return list.count
        }
        else {
            return courseList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 15 {
            return list[row]
        }
        else {
            return courseList[row]
        }
    }
    

    func loadSubjects(){
        Database.database().reference().child("subject").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.list.append(rest.key)
            }
              print(self.list)
            self.subjectPicker.reloadAllComponents()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 15 {
            didSelectSubject = true
            print("selected",list[row])
            subjectText = list[row]
            courseList = [String]()
            LoadCourses(course: list[row])
        }else {
            print("selected course")
            didSelectCourse = true
            courseText = courseList[row]
        }
        
    }
    //tag 10 is subject list
    func LoadCourses(course : String){
        Database.database().reference().child("subject").child(course).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.courseList.append(rest.value as! String)
            }
            print("courseList",self.courseList)
            self.coursePicker.reloadAllComponents()
            self.coursePicker.isHidden = false
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }    }
    
    
}
