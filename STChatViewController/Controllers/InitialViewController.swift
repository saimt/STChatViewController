//
//  InitialViewController.swift
//  STChatViewController
//
//  Created by Creatrixe on 31/03/2019.
//  Copyright © 2019 Creatrixe. All rights reserved.
//

import UIKit

class InitialViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func btnInstagramAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "InstagramChatViewController") as! InstagramChatViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func btnMessengerAction(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MessengerChatViewController") as! MessengerChatViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
