//
//  InterfaceController.swift
//  NewsStream WatchKit Extension
//
//  Created by XMZ on 9/1/16.
//  Copyright © 2016 Mingze Xiao. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    @IBOutlet var newsTable: WKInterfaceTable!
    
    private var headlines = [String]()
    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        // Configure interface objects here.
        let news = News()
        news.fetchTopStories(forSection: News.Section.world) { (fetchResult) in
            switch fetchResult {
            case .Success(let headlines):
                self.headlines = headlines
                self.loadTableData()
            case .Failure(let description):
                let cancel = WKAlertAction(title: "Cancel", style: .Cancel) {}
                
                self.presentAlertControllerWithTitle("Error", message: description, preferredStyle: .Alert, actions: [cancel])
            }
        }
    }
    
    private func loadTableData() {
        newsTable.setNumberOfRows(headlines.count, withRowType: "NewsRowController")
        
        for (index, headline) in headlines.enumerate() {
            let row = newsTable.rowControllerAtIndex(index) as? NewsRowController
            row?.headlineLabel.setText(headline)
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
