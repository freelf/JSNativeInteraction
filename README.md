## 实现效果
在下面 gif 中可以看到，在右边的 Safari 控制台中，先输入一个回调函数，然后我去调用 webview 初始化时注入的 JavaScript 代码。
代码如下：
```javascript
Calculate = {
square:function(num,callback) {
    Queue.push(Task.init(Queue.length, callback));
    window.webkit.messageHandlers.Beyond.postMessage({className: 'CalculatePlugin', functionName: 'square',taskId : Queue.length - 1, data: {"number":num}});
}
}
```
代码有两个参数，一个是 num，一个是一个回调函数。在这里分别传入了10，和 callback。
Native 端处理代码如下：
```swift
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
```
在 Native 端的代码是对传入的数做平方来模拟 Native 端的耗时任务，然后把平方后的数，回调给 JavaScript，JavaScript 的回调函数是用 alert 来显示平方，所以可以看到左侧模拟器弹了一个 alert，显示100。
这样就是实现了 JavaScript->Native->回调给 JavaScript + 传值的流程。
想要扩展的话，可以继续加入 JavaScript 代码，然后让前端小伙伴直接调用即可。
感兴趣的可以下载 Demo，查看代码，很简单。实现效果如下：
<img src="http://ohg2bgicd.bkt.clouddn.com/JSNativeInteraction.gif" width="100%" />
