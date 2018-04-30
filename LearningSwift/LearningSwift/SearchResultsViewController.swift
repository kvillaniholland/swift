//
//  ViewController.swift
//  LearningSwift
//
//  Created by Keenan on 4/28/18.
//  Copyright © 2018 Keenan. All rights reserved.
//

import UIKit

class SearchResultsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, RecievesResults {
    @IBOutlet var appsTableView : UITableView!
    var tableData = [[String: String]]()
    let apiGateway = iTunesGateway()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        apiGateway.delegate = self
        apiGateway.search(searchTerm: "JQ Software")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func didReceiveResults(searchResult: [String: Any]) {
        guard let results = searchResult["results"] as? [[String: Any]] else {
            print("Could not process search results...")
            return
        }
        
//        var apps = [[String: String]]()
        tableData = results.map({(result) -> [String: String] in
            if let thumbnailURLString = result["artworkUrl100"] as? String,
                let appName = result["trackName"] as? String,
                let price = result["formattedPrice"] as? String {
                return [
                    "thumbnailURLString": thumbnailURLString,
                    "appName": appName,
                    "price": price
                ]
            }
            return ["None": "none"]
        })
//        for result in results {
//            if let thumbnailURLString = result["artworkUrl100"] as? String,
//                let appName = result["trackName"] as? String,
//                let price = result["formattedPrice"] as? String {
//                apps.append(
//                    [
//                        "thumbnailURLString": thumbnailURLString,
//                        "appName": appName,
//                        "price": price
//                    ]
//                )
//            }
//        }
//        tableData = apps
        
        DispatchQueue.main.async {
            self.appsTableView!.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "MyTestCell")
        let app = tableData[indexPath.row]
        
        cell.textLabel?.text = app["appName"]
        cell.detailTextLabel?.text = app["price"]
        
        return cell
    }
}

