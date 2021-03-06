//
//  Air.swift
//  Weather
//
//  Created by 王文博 on 2016/12/1.
//  Copyright © 2016年 ts. All rights reserved.
//

import Foundation
import UIKit

class Air: NSObject {
    var interName: String
    var weatherURL: URL?
    var jsondata: Data?{
        if getData != nil {
            return getData
        } else {
            fetchAsync()
            return getData
        }
    }
    private var getData: Data?
    var isFetching = false
    init(_ name: String, _ url: String) {
        interName = name
        weatherURL = URL(string: url)
        print("init \(interName)")
        super.init()
    }
    func fetchAsync() {
        if !isFetching, let url = weatherURL {
            print("start getting air \(self.interName)")
            isFetching = true
            let downloadTask = URLSession.shared.downloadTask(with: url,completionHandler: {
                [weak self] url, response, error in if let error = error {
                    print("error getting air \(self?.interName) error: \(error)")
                    
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.isFetching = false
                        }
                    }
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let url = url {
                    do {
                        let getData = try NSData(contentsOf: url, options: NSData.ReadingOptions.uncached)
                        print("received data for air \(self?.interName)")
                        DispatchQueue.main.async {
                            if let strongSelf = self {
                                strongSelf.getData = getData as Data
                                print(getData)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetAir"), object: strongSelf)
                                strongSelf.isFetching = false
                            }
                        }
                    } catch {
                        print("error getting air \(self?.interName) error: \(error)")
                        DispatchQueue.main.async {
                            self?.isFetching = false
                        }
                    }
                } else {
                    print("failed getting air \(self?.interName) error: \(response)")
                    DispatchQueue.main.async { if let strongSelf = self {
                        strongSelf.isFetching = false
                        }
                    }
                }
            })
            downloadTask.resume()
        }
    }
}
