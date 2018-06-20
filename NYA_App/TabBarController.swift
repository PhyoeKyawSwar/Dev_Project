//
//  TabBarController.swift
//  NYA_App
//
//  Created by Phyo Kyaw Swar on 21/10/17.
//  Copyright © 2017 Phyo Kyaw Swar. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

      /* let tabBarImages = [#imageLiteral(resourceName: "home_active"),#imageLiteral(resourceName: "chat_box_active"),#imageLiteral(resourceName: "home_active"),#imageLiteral(resourceName: "nearby_active"),#imageLiteral(resourceName: "user_active")]
        if let items = self.tabBar.items {
            for i in 0..<items.count {
                let tabBarItem = items[i]
                let tabBarImage = tabBarImages[i]
                tabBarItem.image = tabBarImage.withRenderingMode(.alwaysOriginal)
                tabBarItem.selectedImage = tabBarImage
            }
        }
 */
        for tabBarItem in self.tabBar.items! {
            print(tabBarItem.tag)
            switch tabBarItem.tag {
            case 0:
                tabBarItem.title = "Timeline"
                tabBarItem.selectedImage = UIImage(named: "planner_active")?.withRenderingMode(.alwaysOriginal)
                tabBarItem.image = UIImage(named: "planner")?.withRenderingMode(.alwaysOriginal)
                
                //UINavigationController.show(AppStoryboard.Home.instance.instantiateViewController(withIdentifier: "HomeViewController"), sender: nil) as! HomeViewController
               
                break
            case 1:
                tabBarItem.title = "Chat"
                tabBarItem.selectedImage = UIImage(named: "chat_box_active")?.withRenderingMode(.alwaysOriginal)
                tabBarItem.image = UIImage(named: "chat_box_unactive")?.withRenderingMode(.alwaysOriginal)
                break
            case 2:
                tabBarItem.title = "Home"
                tabBarItem.selectedImage = UIImage(named: "home_active")?.withRenderingMode(.alwaysOriginal)
                tabBarItem.image = UIImage(named: "home_unactive")?.withRenderingMode(.alwaysOriginal)
                break
            case 3:
                tabBarItem.title = "NearBy"
                tabBarItem.selectedImage = UIImage(named: "nearby_active")?.withRenderingMode(.alwaysOriginal)
                tabBarItem.image = UIImage(named: "nearby_unactive")?.withRenderingMode(.alwaysOriginal)
                break
            case 4 :
                tabBarItem.title = "My Account"
                tabBarItem.selectedImage = UIImage(named: "user_active")?.withRenderingMode(.alwaysOriginal)
                tabBarItem.image = UIImage(named: "user_unactive")?.withRenderingMode(.alwaysOriginal)
                break
            default:
                break
            }
        }
        
        self.selectedIndex = 2
        

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
