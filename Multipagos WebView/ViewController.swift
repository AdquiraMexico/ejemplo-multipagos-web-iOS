//
//  ViewController.swift
//  Multipagos WebView
//
//  Created by Daniel on 11/19/18.
//  Copyright © 2018 Daniel. All rights reserved.
//

import UIKit

import WebKit




class ViewController: UIViewController {

    @IBOutlet weak var Lanzar: UIButton!

    @IBOutlet weak var vistaWeb: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vistaWeb.navigationDelegate = self as? WKNavigationDelegate
        
        self.vistaWeb.addObserver(self, forKeyPath: "URL", options: .new, context: nil)
        self.vistaWeb.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(WKWebView.url) {
            print("### URL:", self.vistaWeb.url!)
        }
        
        if keyPath == #keyPath(WKWebView.estimatedProgress) {
            // When page load finishes. Should work on each page reload.
            if (self.vistaWeb.estimatedProgress == 1) {
                print("### EP:", self.vistaWeb.estimatedProgress)
            }
        }
    }
    
    @IBAction func invocar(_ sender: Any) {

        
        func getPostString(params:[String:Any]) -> String
        {
            var data = [String]()
            for(key, value) in params
            {
                data.append(key + "=\(value)")
            }
            return data.map { String($0) }.joined(separator: "&")
        }

        
        print("Post Lanzado")
        
        /*
         https://prepro.adquiracloud.mx/clb/endpoint/flapMexico
         mp_account:<input name="mp_account" value="3202"><br>
         mp_customername:<input name="mp_customername" value="PRUEBAS BANCOMER"><br>
         mp_order:<input name="PRUEBAS BANCOMER" value="2018111500000"><br>
         mp_reference:<input name="mp_reference" value="ABCDE12345"><br>
         mp_product:<input name="mp_product" value="1"><br>
         mp_node:<input name="mp_node" value="1"><br>
         mp_concept:<input name="mp_concept" value="99"><br>
         mp_amount:<input name="mp_amount" value="150.00"><br>
         mp_currency:<input name="mp_currency" value="1"><br>
         mp_urlsuccess:<input name="mp_urlsuccess" value="https://www.egbs5.com.mx/egobierno/operacion/respuesta.jsp"><br>
         mp_urlfailure:<input name="mp_urlfailure" value="https://www.egbs5.com.mx/egobierno/operacion/respuesta.jsp"><br>
         mp_signature:<input name="mp_signature" value="MrQSwFwMlr834ZCsvINkWsAW2KQ="><br>
         
         
         */

        let parameters = ["mp_account": 3202,
                          "mp_customername": "PRUEBAS BANCOMER",
                          "mp_order" : "2018111500000",
                          "mp_reference"  : "ABCDE12345",
                          "mp_product" : 1,
                          "mp_node"  : 1,
                          "mp_concept" : 99,
                          "mp_amount" : 150.00,
                          "mp_currency" : 1,
                          "mp_urlsuccess" : "https://www.egbs5.com.mx/egobierno/operacion/respuesta.jsp",
                          "mp_urlfailure" : "https://www.egbs5.com.mx/egobierno/operacion/respuesta.jsp",
                          "mp_signature" : "MrQSwFwMlr834ZCsvINkWsAW2KQ"
            ] as [String : Any]
        
        //create the url with URL
        let url = URL(string: "https://prepro.adquiracloud.mx/clb/endpoint/flapMexico")! //change the url
        
        //create the session object
        let session = URLSession.shared

        //now create the URLRequest object using the url object
        var request = URLRequest(url: url)
        
        let postString = getPostString(params: parameters)
        var escapedString = postString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)

        request.httpBody = escapedString!.data(using: .utf8)
        
        request.httpMethod = "POST" //set http method as POST
        print(escapedString)

        print(request)

        let task = URLSession.shared.dataTask(with: request) { (data : Data?, response : URLResponse?, error : Error?) in
            if data != nil
            {
                if let returnString = String(data: data!, encoding: .utf8)
                {
                    self.vistaWeb.loadHTMLString(returnString, baseURL: url)
                }
            }
        }
        task.resume()
        
        
        //vistaWeb.load(request)
        /*
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted) // pass dictionary to nsdata object and set it as request body
        } catch let error {
            print(error.localizedDescription)
        }
        vistaWeb.loadRequest(request)
*/
        /*
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //yourWebView.loadRequest
        //create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            
            guard error == nil else {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                //create json object from data
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                    // handle json...
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
        
        */
    }
    
    


}

