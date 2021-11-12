//
//  AboutViewController.swift
//  ITSC
//
//  Created by kw9w on 11/11/21.
//

import UIKit
import SwiftSoup
//import WebKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var item1: UILabel!
    @IBOutlet weak var item2: UILabel!
    @IBOutlet weak var item3: UILabel!
    @IBOutlet weak var item4: UILabel!
    @IBOutlet weak var item5: UILabel!
    @IBOutlet weak var item6: UILabel!
    
    
    let urlMain: URL = URL(string: "https://itsc.nju.edu.cn/main.htm")!
    
//    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.view = webView
        self.handleContentOfUrl()
        // Do any additional setup after loading the view.
    }
    
    
    func handleContentOfUrl() {
        let task = URLSession.shared.dataTask(with: urlMain, completionHandler: {
            data, response, error in
            if let error = error {
                print("\(error.localizedDescription)")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("server error")
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                        let data = data,
                        let string = String(data: data, encoding: .utf8) {
//                            print(string)
                DispatchQueue.main.async { //[self] in
                                //use swiftsoup parse url
                    do {
                        let parseFile: Document = try SwiftSoup.parse(string)
                        let aboutInfo: Element = try parseFile.select("div.foot-center")[0]
                        let aboutHtml: String = try aboutInfo.html()
//                        self.webView.loadHTMLString(aboutHtml, baseURL: nil)
                        let aboutParseFile: Document = try SwiftSoup.parse(aboutHtml)
                        let aboutItem: Elements = try aboutParseFile.select("div.news_box")
//                        let numOfEle: Int = aboutItem.array().count
//                        print(numOfEle)
//                        for item in aboutItem{
//                            let context = try item.text()
//                            print(context)
//                        }
                        self.item1.text! = try aboutItem.array()[0].text()
                        self.item2.text! = try aboutItem.array()[1].text()
                        self.item3.text! = try aboutItem.array()[2].text()
                        self.item4.text! = try aboutItem.array()[3].text()
                        self.item5.text! = try aboutItem.array()[4].text()
                        self.item6.text! = try aboutItem.array()[5].text()
                       
                    } catch Exception.Error(let type, let message) {
                        print(message)
                    } catch {
                        print("error")
                    }

                }
            }
        })
        task.resume()
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
