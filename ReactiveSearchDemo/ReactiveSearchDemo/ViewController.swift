//
//  ViewController.swift
//  ReactiveSearchDemo
//
//  Created by Brendon Roberto on 7/11/16.
//  Copyright © 2016 Snackpack Games. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        let producer = RandomUserService().getUsers(100)

        usersSignal.start
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

