//
//  ViewController.swift
//  Friends
//
//  Created by Sergey Osipyan on 1/10/19.
//  Copyright © 2019 Sergey Osipyan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UIViewControllerTransitioningDelegate {

  
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    var friend = Friend()
    var index: Int?
   

    @IBOutlet weak var friendImage: UIImageView!
    @IBOutlet weak var frieandName: UILabel!
    @IBOutlet weak var friendPositin: UILabel!
    
    func update() {
        guard let index = index else { return }
        frieandName.text = friend.friends[index]
        friendPositin.text = friend.friednsPosition[index]
        friendImage.image = friend.friendsImage[index]
        navigationItem.title = friend.friends[index]
    }
    
    
}