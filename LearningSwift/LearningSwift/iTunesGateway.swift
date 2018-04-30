//
//  APIGateway.swift
//  LearningSwift
//
//  Created by Keenan on 4/30/18.
//  Copyright © 2018 Keenan. All rights reserved.
//

import Foundation

protocol RecievesResults {
    func didReceiveResults(searchResult: [String: Any])
}

class iTunesGateway {
    var delegate: RecievesResults?
    
    func search(searchTerm: String) {
        let itunesSearchTerm = searchTerm.replacingOccurrences(of: " ", with: "+", options: .caseInsensitive, range: nil)
        let escapedSearchTerm = itunesSearchTerm.addingPercentEncoding(withAllowedCharacters: [])!
        let urlString = "http://itunes.apple.com/search?term=\(escapedSearchTerm)&media=software"
        let url = URL(string: urlString)!
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                self.delegate?.didReceiveResults(searchResult: jsonResult)
            }
            catch let err {
                print(err.localizedDescription)
            }
        }.resume()
    }
}
