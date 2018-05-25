//
//  SeachPopupVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 5/16/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase
class SearchPopupVC : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{

    @IBOutlet weak var searchButton: UIButton!
    var list = ["Subjects"]
    var courseList = ["Courses"]

    
    @IBOutlet weak var classPicker: UIPickerView!
    
    @IBOutlet weak var coursePicker: UIPickerView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchButton.isHidden = true
        searchBar.isTranslucent = true
        searchBar.alpha = 1
        searchBar.backgroundImage = UIImage()
        searchBar.barTintColor = UIColor.clear
        loadSubjects()
        classPicker.isHidden = true
        classPicker.delegate = self
        classPicker.dataSource = self
        coursePicker.delegate = self
        coursePicker.dataSource = self
        coursePicker.isHidden = true
    }
    @IBAction func searchButtonClicked(_ sender: Any) {
        /*
        print("searchButton Clicked")
        let storyBoard: UIStoryboard = UIStoryboard(name: "PostingBoard", bundle: nil)
        
        let vc = storyBoard.instantiateViewController(withIdentifier: "PostVC") as! PostVC
        navigationController?.pushViewController(vc, animated: true)
 */
        
            }

    
    @IBAction func closeSearchPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        print(pickerView.tag,"pickerView tag")
        if pickerView.tag == 10 {
            return list.count
        }
        else {
            return courseList.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 10 {
            return list[row]
        }
        else {
            return courseList[row]
        }
    }
    
    @IBOutlet weak var classPickerButton: UIButton!
    
    @IBAction func selectedButton(_ sender: Any) {
        if classPicker.isHidden == true {
            classPicker.isHidden = false;
        }
    }
    func loadSubjects(){
        Database.database().reference().child("subject").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.list.append(rest.key)
            }
          //  print(self.list)
            self.classPicker.reloadAllComponents()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        classPickerButton.setTitle("Please Select Major", for: .normal
        )
       // print(list[row])
        searchButton.isHidden = false
        LoadCourses(course: list[row])
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
    

