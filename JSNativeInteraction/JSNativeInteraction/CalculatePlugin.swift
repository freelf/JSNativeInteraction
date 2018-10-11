//
//  TWWebViewModel.swift
//  TuWanApp
//
//  Created by 张东坡 on 2018/2/6.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import UIKit

public class CalculatePlugin: Plugin {
    @objc func square()  {
        // 显示一个 activity
        let activity = UIActivityIndicatorView(style: .gray)
        activity.center = CGPoint(x: UIScreen.main.bounds.width * 0.5, y: UIScreen.main.bounds.height * 0.5)
        UIApplication.shared.keyWindow?.addSubview(activity)
        activity.startAnimating()
        
        
        if let dict = self.data {
            if let number = dict["number"] as? Int {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    activity.stopAnimating()
                    let _ = self.callback(values: ["result" : number * number])
                }
            }
        }
    }
}
