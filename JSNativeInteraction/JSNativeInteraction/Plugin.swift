//
//  Plugin.swift
//  WebViewAndNative
//
//  Created by 张东坡 on 2018/2/6.
//  Copyright © 2018年 张东坡. All rights reserved.
//

import UIKit
import WebKit
public class Plugin: NSObject {
    // MARK: - Properties
    var wk:WKWebView!
    var taskId:Int!
    var data:[String:Any]?
    
    // MARK: - Instance Method
    required override init() { }
    
    func callback(values:Dictionary<String, Any>) -> Bool {
        do{
            let jsonData = try JSONSerialization.data(withJSONObject: values, options: JSONSerialization.WritingOptions())
            if let jsonString = NSString.init(data: jsonData, encoding: String.Encoding.utf8.rawValue) as String? {
                let js = "fireTask(\(self.taskId!), '\(jsonString)');"
                self.wk.evaluateJavaScript(js, completionHandler: nil)
                return true
            }
        }catch {
            print(error.localizedDescription)
            return false
        }
        return false
    }
    func errorCallback(errorMessage: String) {
        let js = "onError(\(self.taskId ?? -1), '\(errorMessage)');"
        self.wk.evaluateJavaScript(js, completionHandler: nil)
    }
}
