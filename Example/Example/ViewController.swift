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
    
    @IBOutlet weak var toastButton: UIButton!
    
    @IBOutlet weak var loadButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func makeToastView(_ sender: UIButton) {
        // DDToastView sample
        DDToastView.show("bring your ideas to life",inView: self.view)
//        "bring your ideas to life".toast(inView: self.view, position: .center)
    }
    
    @IBAction func makeLoadView(_ sender: UIButton) {
        // DDLoadingView sample, touch sceen to dismiss
        DDLoadingView.show(inView: self.view, tappable: true)
    }
}

