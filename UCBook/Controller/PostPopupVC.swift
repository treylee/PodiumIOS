//
//  PostPopupVC.swift
//  UCBook
//
//  Created by Trieveon Cooper on 4/16/18.
//  Copyright © 2018 Trieveon Cooper. All rights reserved.
//

import UIKit
import Firebase


class PostPopupVC : UIViewController,UIPickerViewDelegate, UIPickerViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var priceText =  0
    var list = [String]()
    var courseList = [String]()
    var didSelectCourse = false;
    var didSelectSubject = false;
    var subjectText = ""
    var courseText = ""
    var profileURL = ""
    var photos = [String]()
    @IBOutlet weak var titleText: UITextField!
    
    @IBOutlet weak var commentsTexrt: UITextView!
    @IBOutlet weak var instructorText: UITextField!
    
    @IBOutlet weak var isbnText: UITextField!
    
    @IBOutlet weak var meetingPlaceText: UITextField!
    
    @IBOutlet weak var bookPic: UIImageView!
    
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
        
        bookPic.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: Selector("imageTapped:"))
        //bookPic.addGestureRecognizer(tapRecognizer)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let storageRef = Storage.storage().reference().child("books").child("22").child("bookPic")
        
        // let storageRef = Storage.storage().reference().child("users").child((Auth.auth().currentUser?.uid)!).child("profilePic")
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        bookPic.image = image
        
        // Upload the file to the path "images/rivers.jpg"
        let uploadImage = UIImagePNGRepresentation(image)
        storageRef.putData(uploadImage!, metadata: nil) { (metadata, error) in
            if error != nil {
                print("Couldn't Upload Image", error)
            } else {
                print("Uploaded")
                storageRef.downloadURL(completion: { (url, error) in
                    print("inside")
                    if error != nil {
                        print(error!)
                        return
                    }
                    if url != nil {
                        print("download url:",url!.absoluteString)
                        self.profileURL =  url!.absoluteString
                        self.photos.append(self.profileURL)
                    }
                })
            }
        }
        picker.dismiss(animated: true,completion: nil)
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touching ", touches.first!.description)

        let touch:UITouch = touches.first!
        if touch.view == bookPic {
            print("touching image")
            let controller = UIImagePickerController()
            controller.delegate = self
            controller.allowsEditing = true
            controller.sourceType = .photoLibrary
            present(controller,animated: true,completion: nil)
        }
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
            let values  =
                ["title": titleText.text!,
                 "isbn" : isbnText.text! ,
                 "photos" : self.photos,
                 "meetingPlace": meetingPlaceText.text,
                    "price":tmpPrice] as [String : Any]
            
                var random = arc4random_uniform(21) + 10
            
            
            print("c",subjectText,"s",courseText)
            /* firebase database code
            Database.database().reference().child("books").child(subjectText).child(courseText).child(String(random)).updateChildValues(values)  { (error,ref) in
                if error != nil {
                    print(error)
                    return
                }
                
            } */
            var docData: [String: Any] = [
                "title": titleText.text!,
                "isbn" : isbnText.text! ,
                "photos" : self.photos,
                "meetingPlace": meetingPlaceText.text,
                "price":tmpPrice,
                "comments": commentsTexrt.text
            ]
        
        let db = Firestore.firestore()
        
            print("adding the following")
            var ref = db.collection("books").document("byCourse").collection(courseText).addDocument(data: docData)
            var ref2 = db.collection("books").document("bySubject").collection(subjectText).addDocument(data: docData)
            
            // remove when sold!
            var ref3 = db.collection("books").document("all").collection("recent").addDocument(data: docData)
            
            
            
            for string in photos {
            print("Strigns",string)
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
        /* firebase database query
        Database.database().reference().child("subject").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let enumerator = snapshot.children
            while let restx = enumerator.nextObject() as? DataSnapshot {
                self.list.append(rest.key)
            }
              print(self.list)
            self.subjectPicker.reloadAllComponents()
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
 
 */
        let db = Firestore.firestore()
     
        db.collection("subjects").getDocuments { (snapshot,error) in
            self.list.append("Select Subject")
            for document in snapshot!.documents {
                print("docuement ",document.documentID)
                self.list.append(document.documentID)
                self.subjectPicker.reloadAllComponents()
                
            }
            self.subjectPicker.selectRow(0, inComponent: 0, animated: false)
            
        }
        

        
 }
    
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
        /* firebase database code
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
        }
        */
        //firestore code
        let db = Firestore.firestore()
        
        db.collection("subjects").document(course).getDocument { (document,error) in
            self.courseList.append("Select Course")

            if let city = document.flatMap({
                $0.data().flatMap({ (data) in
                    return data as Dictionary<String,AnyObject>
                })
            }) {
                for (key,value)  in city {
                    self.courseList.append(key as! String)
                }
                self.coursePicker.reloadAllComponents()
                self.coursePicker.isHidden = false
                    self.coursePicker.selectRow(0, inComponent: 0, animated: false)
            } else {
                print("Document does not exist")
            }
        }

        
        
    }
    
    
}
