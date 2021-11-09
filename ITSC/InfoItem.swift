//
//  InfoItem.swift
//  ITSC
//
//  Created by kw9w on 11/9/21.
//

import UIKit

class InfoItem: NSObject {
    // the summary Infomation of the news
    var sumInfo: String
    // the release date of the news
    var reDate: String
    // the url of the news
    var url: URL
    
    
    init(sumInfo: String, reDate: String, url: URL) {
        self.sumInfo = sumInfo
        self.reDate = reDate
        self.url = url
    }

}
