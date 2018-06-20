//
//  WriteReviewViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 30/3/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit
import HCSStarRatingView
import PKHUD
class WriteReviewViewController: UIViewController , UITextViewDelegate ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate  {

    @IBOutlet weak var btnClose: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var txtReview: UITextView!
    @IBOutlet weak var imgCollection: UICollectionView!
    @IBOutlet weak var btnDone: UIButton!
    @IBOutlet weak var ratingView: HCSStarRatingView!
    var shop_id = Int()
    var menu_id = Int()
    var is_from_shop = Bool()
    var image_array = [UIImage]()
    override func viewDidLoad() {
        super.viewDidLoad()

        txtReview.layer.cornerRadius = 5
        txtReview.layer.borderColor = BOTTOM_COLOR.withAlphaComponent(0.5).cgColor
        txtReview.layer.borderWidth = 0.5
        txtReview.clipsToBounds = true
        
        txtReview.text = "Write Review"
        txtReview.textColor = UIColor.lightGray
        txtReview.delegate = self
        
        self.addDoneButtonOnKeyboard()
        
         imgCollection.register(UINib(nibName: "ReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewCollectionViewCell")
        
        imgCollection.delegate = self
        imgCollection.dataSource = self
        imgCollection.reloadData()
        
        
        // Do any additional setup after loading the view.
    }
    
    func addDoneButtonOnKeyboard(){
        
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        doneToolbar.barStyle = UIBarStyle.default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(self.doneButtonAction))
        
        var items = [UIBarButtonItem]()
        items.insert(flexSpace, at: 0)
        items.insert(done, at: 1)
        
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.txtReview.inputAccessoryView = doneToolbar
        
    }
    func doneButtonAction()
    {
        
        self.view.endEditing(true)
       
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onClickDone(_ sender: Any) {
        self.WriteReview()
    }
    
    @IBAction func onClickClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func WriteReview()
    {
        //shops/1/reviews
        /*
         "description": "This is very very good",
         "rating": 5,
         "images": [
         
         ]
         */
        HUD.show(.systemActivity)
        var url_string = ""
        var image_string_array = [String]()
        var params = [String : Any]()
        if is_from_shop == true
        {
            url_string = "shops/\(self.shop_id)/reviews"
            
            
        }
        else
        {
           url_string = "shops/\(self.shop_id)/sub_menus/\(self.menu_id)/reviews"
        }
        
        for image in image_array
        {
            let imageString = convertImageToBase64(image: image)
            image_string_array.append(imageString)
            
        }
        
        params = ["description" : txtReview.text , "rating" : Int(ratingView.value) , "images" : image_string_array]
        APIFunction.sharedInstance.url_string = url_string
        APIFunction.sharedInstance.apiFunction(method: url_string, parameter: params, methodType: "POST") { (data, status) in
            if status == 201
            {
                print("DATA :::::",data)
            }
            
            OperationQueue.main.addOperation {
                
                HUD.hide()
            }
        }
        
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == "Write Review" {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            DispatchQueue.main.async {
                textView.text = "Write Review"
            }
        }
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let newImage = image.resizeImage(image: image, targetSize: CGSize(width: 100, height: 100))
       
        if image_array.count < 3
        {
            image_array.append(newImage)
            imgCollection.delegate = self
            imgCollection.dataSource = self
            imgCollection.reloadData()
            
        }
       dismiss(animated:true, completion: nil)
    }
    
}
extension WriteReviewViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if image_array.count > 0
        {
            return image_array.count + 1
        }
        else
        {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewCollectionViewCell", for: indexPath) as! ReviewCollectionViewCell
        if image_array.count == 0
        {
             cell.imgAdd.image = #imageLiteral(resourceName: "add_image")
             cell.imgAdd.isHidden = false
            cell.imgReview.isHidden = true
        }
        else
        {
            if indexPath.item == image_array.count
            {
                cell.imgAdd.image = #imageLiteral(resourceName: "add_image")
                cell.imgAdd.isHidden = false
                cell.imgReview.isHidden = true
            }
            else
            {
                cell.imgReview.image = image_array[indexPath.item]
                cell.imgAdd.isHidden = true
                cell.imgReview.isHidden = false
                
            }
            
        }
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == image_array.count
        {
            let alert = UIAlertController(title: "Choose Photo", message: "", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {
                action in
                
                if UIImagePickerController.isSourceTypeAvailable(.camera)
                {
                    var imagePicker = UIImagePickerController()
                    imagePicker.delegate = self
                    imagePicker.sourceType = .camera
                    imagePicker.allowsEditing = true
                    self.present(imagePicker, animated: true, completion: nil)
                }
            }))
            alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: {
                action in
                
                var imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .photoLibrary;
                imagePicker.allowsEditing = true
                self.present(imagePicker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)

        }
    }
}


