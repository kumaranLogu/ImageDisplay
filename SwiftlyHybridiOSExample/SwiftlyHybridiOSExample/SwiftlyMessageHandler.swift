import Foundation

import WebKit

class SwiftlyMessageHandler:NSObject, WKScriptMessageHandler {
    var appWebView:WKWebView?
    
    init(theController:ViewController){
        super.init()
        let theConfiguration = WKWebViewConfiguration()
    
        theConfiguration.userContentController.add(self, name: "native")
        
        
        let indexHTMLPath = Bundle.main.path(forResource: "index", ofType: "html")
        appWebView = WKWebView(frame: theController.view.frame, configuration: theConfiguration)
        appWebView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let url = URL(fileURLWithPath: indexHTMLPath!)
        let request = URLRequest.init(url: url)
        appWebView!.load(request)
        theController.view.addSubview(appWebView!)
    }
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        let sentData = message.body as! NSDictionary
        let imageName = "name.jpg"
        let command = sentData["cmd"] as! String
        var response = Dictionary<String,AnyObject>()
        if command == "increment"{
            //guard var count = sentData["count"] as? Int else{
            //    return
            //}
            //count += 1
            //response["count"] = count as AnyObject
            response["image"] = imageName as AnyObject
        }
        let callbackString = sentData["callbackFunc"] as? String
        sendResponse(aResponse: response, callback: callbackString)
    }
    func sendResponse(aResponse:Dictionary<String,AnyObject>, callback:String?){
        guard let callbackString = callback else{
            return
        }
        guard let generatedJSONData = try? JSONSerialization.data(withJSONObject: aResponse, options: JSONSerialization.WritingOptions(rawValue: 0)) else{
            print("failed to generate JSON for \(aResponse)")
            return
        }
        
        appWebView!.evaluateJavaScript("(\(callbackString)('\(NSString(data:generatedJSONData, encoding:String.Encoding.utf8.rawValue)!)'))") {(JSReturnValue, error) in
            if let errorDescription = (error as NSError?)?.description{
                print("returned value: \(errorDescription)")
            }
            else if JSReturnValue != nil{
                print("returned value: \(JSReturnValue!)")
            }
            else{
                print("no return from JS")
            }
        }
       
    }

}
