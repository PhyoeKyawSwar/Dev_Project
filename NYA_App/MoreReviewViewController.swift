//
//  MoreReviewViewController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 18/6/18.
//  Copyright © 2018 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class MoreReviewViewController: UIViewController {
    @IBOutlet weak var tblReview: UITableView!
    var review_imageArray = [String]()

    var reviewArray = [ReviewObject]()
    override func viewDidLoad() {
        super.viewDidLoad()

        tblReview.delegate = self
        tblReview.dataSource = self
        tblReview.reloadData()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MoreReviewViewController : UITableViewDelegate , UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return reviewArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReviewTableViewCell") as! ReviewTableViewCell
        let dict = reviewArray[indexPath.row]
        
        cell.setupData(dict: dict)
        
        if dict.images.count > 0
        {
            review_imageArray = dict.images
            cell.reviewCollection.register(UINib(nibName: "ShowReviewCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ShowReviewCollectionViewCell")
            
            cell.reviewCollection.delegate = self
            cell.reviewCollection.dataSource = self
            cell.reviewCollection.reloadData()
        }
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        
        return cell
    }
    
}

extension MoreReviewViewController : UICollectionViewDelegate , UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return review_imageArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowReviewCollectionViewCell", for: indexPath) as! ShowReviewCollectionViewCell
        cell.imgReview.setimage(url_string: "\(image_url_host)\(review_imageArray[indexPath.item])")
        
        return cell
    }
}
