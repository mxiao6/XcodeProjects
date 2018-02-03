//
//  News.swift
//  NewsStream
//
//  Created by XMZ on 9/1/16.
//  Copyright © 2016 Mingze Xiao. All rights reserved.
//

import Foundation

class News {
    
    //NYTimes Developer API Key
    private let cocoanutsDemoAPIKey = "770e0fabd8b04628936797cf9fa5f5a2"
    enum Section: String {
        case home, world, national, politics, nyregion, business, opinion, technology, science, health, sports, arts, fashion, dining, travel, magazine, realestate
    }
    
    enum FetchResult {
        case Success([String])
        case Failure(String)
    }
    
    func fetchTopStories(forSection section: News.Section, completion callback: (FetchResult) -> Void) {
        guard let url = NSURL(string: "http://api.nytimes.com/svc/topstories/v1/\(section).json?api-key=\(cocoanutsDemoAPIKey)") else {
            callback(FetchResult.Failure("Could not find news source."))
            return
        }
        
        //configure request
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        //configure session
        let session = NSURLSession(configuration: .defaultSessionConfiguration())
        //create the task
        let task = session.dataTaskWithRequest(request) { (newsData, response, error) -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                guard error == nil else {
                    callback(FetchResult.Failure(error!.localizedDescription))
                    return
                }
                
                guard let newsData = newsData else {
                    callback(FetchResult.Failure("Failed to retrieve news data."))
                    return
                }
                
                do {
                    if let newsDictionary = try NSJSONSerialization.JSONObjectWithData(newsData, options: .AllowFragments) as? NSDictionary {
                        
                        var headlines = [String]()
                        
                        if let results = newsDictionary["results"] as? NSArray {
                            for result in results {
                                if let headline = result["abstract"] as? String {
                                    headlines.append(headline)
                                }
                            }
                        }
                        
                        if !headlines.isEmpty {
                            callback(FetchResult.Success(headlines))
                        } else {
                            callback(FetchResult.Failure("Failed to parse your news headlines."))
                        }
                        
                    } else {
                        callback(FetchResult.Failure("Failed to serialize your news data."))
                    }
                } catch let error as NSError {
                    callback(FetchResult.Failure(error.localizedDescription))
                }
                
            })
        }

        //send off the network request task
        task.resume()
    }
}