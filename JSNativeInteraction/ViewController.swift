//
//  ViewController.swift
//  JSNativeBridge
//
//  Created by 张东坡 on 2018/10/11.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func goToWebView(_ sender: Any) {
        let vc = SFWebViewController(with: "https://www.baidu.com")
        present(vc, animated: true, completion: nil)
    }

}

