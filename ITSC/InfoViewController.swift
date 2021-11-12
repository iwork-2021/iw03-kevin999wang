//
//  InfoViewController.swift
//  ITSC
//
//  Created by kw9w on 11/11/21.
//

import UIKit
import WebKit
import SwiftSoup
//import SwiftSoup

class InfoViewController: UIViewController {
    
    let webView = WKWebView()
    
    var urlMain: URL = URL(string: "https://apple.com")!
    
    let baseUrl = URL(string: "https://itsc.nju.edu.cn")
    
//    let baseUrlStr: String = "https://itsc.nju.edu.cn"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view = webView
        self.loadWebContent()
        // Do any additional setup after loading the view.
    }
    
    func loadWebContent(){
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
                DispatchQueue.main.async { [self] in
                                //use swiftsoup parse url
                    do {
//                        print(string)
//                        let parseFile: Document = try SwiftSoup.parse(string)
//                        let infoEle: Element = try parseFile.select("div.wrapper.container")[0]
//                        let infoHtml = try infoEle.html()
                        let regex = #"<!--Start\|\|Header-->(.*)<!--End\|\|Header-->"#
                        let regex1 = #"<!--Start\|\|Navi-->.*<!--End\|\|Navi-->"#
                        let regex2 = #"<!--Start\|\|Footer-->.*<!--End\|\|Footer-->"#
                        let RE = try NSRegularExpression(pattern: regex, options: .dotMatchesLineSeparators)
                        let RE1 = try NSRegularExpression(pattern: regex1, options: .dotMatchesLineSeparators)
                        let RE2 = try NSRegularExpression(pattern: regex2, options: .dotMatchesLineSeparators)
                        let tmp1 = RE.stringByReplacingMatches(in: string, range: NSRange(location: 0, length: string.count), withTemplate: "")
//                        print(tmp1)
                        let tmp2 = RE1.stringByReplacingMatches(in: tmp1, options: .reportProgress, range: NSRange(location: 0, length: tmp1.count), withTemplate: "")
                        let reStrOfHtml = RE2.stringByReplacingMatches(in: tmp2, options: .reportProgress, range: NSRange(location: 0, length: tmp2.count), withTemplate: "")
                        
                        
                        self.webView.loadHTMLString(reStrOfHtml, baseURL: self.baseUrl)
                       
                    }
//                        catch Exception.Error(let type, let message) {
//                        print(message)
//                    }
                     catch {
                        print("error")
                    }

                }
            }
        })
        task.resume()
        task.priority = 1
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
