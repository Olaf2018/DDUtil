//
//  ViewController.swift
//  Example
//
//  Created by DDBB on 2020/5/1.
//  Copyright © 2020 DDWin. All rights reserved.
//

import UIKit
import DDUtil

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ToastView Sampllse
        DDToastView.show("bring your ideas to life",inView: self.view)
        DDToastView.show("bring your ideas to life",inView: self.view)
        DDToastView.show("bring your ideas to life",inView: self.view)
        DDToastView.show("bring your ideas to life",inView: self.view)
//        "adfafafasdfadsfa".toast(inView: self.view, position: .center)
    }
}

