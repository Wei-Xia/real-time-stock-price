//
//  ViewController.swift
//  Real Time Stock Price
//
//  Created by Wei Xia on 3/5/17.
//  Copyright © 2017 Wei Xia. All rights reserved.
//

import UIKit

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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            self.sendRequest(url: "http://dev.markitondemand.com/MODApis/Api/v2/Quote/json?symbol=IBM", completionHandler:{data, response, error in
                
                guard error == nil && data != nil else {
                    print("error=\(error)")
                    return
                }
                
                let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                
                print("responseString = \(responseString)")
                
                DispatchQueue.main.async {
                    self.PriceBox.text = responseString as String?
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

