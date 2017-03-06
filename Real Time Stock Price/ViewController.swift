//
//  ViewController.swift
//  Real Time Stock Price
//
//  Created by Wei Xia on 3/5/17.
//  Copyright © 2017 Wei Xia. All rights reserved.
//

import UIKit
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate, URLSessionDelegate, URLSessionDataDelegate {

    @IBOutlet weak var PriceBox: UILabel!
    
    func sendRequest(url: String, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionTask {
        
        let requestURL = URL(string:"\(url)")!
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: completionHandler)
        task.resume()
        
        return task
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            self.sendRequest(url: "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=IBM", completionHandler:{data, response, error in
                
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                let responseNSString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                let responseString = responseNSString as! String
                
                let dict = self.convertToDictionary(text: responseString)
                
                print(dict)
                
                let json = JSON(dict)

                let price = json["LastPrice"].stringValue
                
                print(price)

                DispatchQueue.main.async {
                    self.PriceBox.text = price as String?
                }
            })
            print("fire")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

