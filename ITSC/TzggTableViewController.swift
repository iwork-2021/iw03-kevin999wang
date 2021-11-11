//
//  TzggTableViewController.swift
//  ITSC
//
//  Created by kw9w on 11/9/21.
//

import UIKit
import SwiftSoup

class TzggTableViewController: UITableViewController {
    
    var items: [InfoItem] = [
        // sample item
//        InfoItem(sumInfo: "sample", reDate: "2021-09-22", url: URL(string: "https://www.apple.cn")!)
    ]
    
    // the index of the items
//    var indexOfItems: Int = 0
    //mark the numbers of the pages
    var numOfPages: Int = 0
    
    let urlMain = URL(string: "https://itsc.nju.edu.cn/tzgg/list.htm")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loadWebContent()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tzggCell", for: indexPath) as! WebInfoTableViewCell
        
        // Configure the cell...
        let item = items[indexPath.row]
        cell.sumInfo.text! = item.sumInfo
        cell.reDate.text! = item.reDate
        return cell
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
    
    func loadWebContent() {
        var url: URL
        if numOfPages == 0 {
            url = urlMain!
//            print(urlMain)
        }
        else {
            url = URL(string: "https://itsc.nju.edu.cn/tzgg/list\(numOfPages).htm")!
        }
        
        let task = URLSession.shared.dataTask(with: url, completionHandler: {
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
                                    let parseFile:Document = try SwiftSoup.parse(string)
//                                    print(parseFile)
//                                    print("1")
                                    let titleInfo:Elements = try parseFile.select("span.news_title")
//                                    print(titleInfo)
                                    let metaInfo:Elements = try parseFile.select("span.news_meta")
                                    let numOfEleThisPage: Int
                                    numOfEleThisPage = titleInfo.array().count
//                                    print(numOfPages)
                                    if numOfEleThisPage == 0{
                                        return
                                    }
                                    for i in 0...numOfEleThisPage-1{
                                        let linkTitle:Element = titleInfo.array()[i]
                                        let linkMeta:Element = metaInfo.array()[i]
                                        let newTitle: String = try linkTitle.text()
//                                        print(newTitle)
                                        let newReDate: String = try linkMeta.text()
//                                        print(newReDate)
                                        let htmlOfTitle: String = try linkTitle.html()
//                                        print(htmlOfTitle)
//                                        like this
//                                        <a href="/51/2b/c21414a545067/page.htm" target="_blank" title="我校召开本研教室资源互通协调会">我校召开本研教室资源互通协调会</a>
                                        let htmlOfTitleParse: Document = try SwiftSoup.parse(htmlOfTitle)
                                        let urlToReferTo: Element = try htmlOfTitleParse.select("a").first()!
                                        let urlToAdd: String = try urlToReferTo.attr("href")
//                                        print(urlToAdd)
                                        let newUrlStr = "https://itsc.nju.edu.cn" + urlToAdd
//                                        print(newUrlStr)
                                        let newUrl = URL(string: newUrlStr)
                                        let newItem = InfoItem(sumInfo: newTitle, reDate: newReDate, url: newUrl!)
                                        self.items.append(newItem)
                                    }
                                   
                                } catch Exception.Error(let type, let message) {
                                    print(message)
                                } catch {
                                    print("error")
                                }
                                
                                self.numOfPages = self.numOfPages + 1
                                self.loadWebContent()
                                self.tableView.reloadData()
                            }
            }
        })
        task.resume()
            
    }
    
    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
