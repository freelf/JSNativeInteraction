//
//  TWWebViewController.swift
//  TuWanApp
//
//  Created by 张东坡 on 2017/12/11.
//  Copyright © 2017年 张东坡. All rights reserved.
//

import UIKit
import WebKit
@objc class SFWebViewController: UIViewController {

    @objc var url:String
    @objc init(with url:String) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var wk: WKWebView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let conf = WKWebViewConfiguration()
        conf.userContentController.add(self, name: "Beyond")
        self.wk = WKWebView.init(frame: self.view.frame, configuration: conf)
        let request = URLRequest.init(url: URL.init(string: self.url)!)
        self.wk.load(request)
        self.runPluginJS(names: ["Base","Calculate"])
        self.view.addSubview(self.wk)
        self.wk.navigationDelegate = self
        self.wk.uiDelegate = self

    }
    func runPluginJS(names:Array<String>) {
        for name in names {
            if let path = Bundle.main.path(forResource: name, ofType: "js") {
                do {
                    let js = try String.init(contentsOfFile: path, encoding: .utf8)
                    self.wk.evaluateJavaScript(js, completionHandler: nil)
                }catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
extension SFWebViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.title = webView.title
    }
}
extension SFWebViewController:WKUIDelegate {
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        self.present(ac, animated: true, completion: nil)
    }
}
extension SFWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.name)
        if message.name == "Beyond" {
            if let dict = message.body as? [String:Any] {
                if let className = dict["className"] as? String,let functionName = dict["functionName"] as? String {
                    if let cls = NSClassFromString("JSNativeBridge" + "." + className) as? Plugin.Type {
                        let obj = cls.init()
                        obj.wk = self.wk
                        obj.taskId = dict["taskId"] as? Int
                        obj.data = dict["data"] as? [String:Any]
                        let functionSelector = Selector(functionName)
                        if obj.responds(to: functionSelector) {
                            obj.perform(functionSelector)
                        }else {
                            print("方法未找到")
                        }
                    }else {
                        print("类未找到")
                    }
                }
            }
        }
    }
}

