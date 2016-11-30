//
//  Life.swift
//  Weather
//
//  Created by 王文博 on 2016/12/1.
//  Copyright © 2016年 ts. All rights reserved.
//

import Foundation
import UIKit

class Life: NSObject {
    var interName: String
    var weatherURL: URL?
    var jsondata: Data?{
        if getData != nil {
            return getData
        } else {
            fetchAsync() //start asynchronous image fetching from the Internet
            return getData
        }
    }
    private var getData: Data?
    var isFetching = false
    init(_ name: String, _ url: String) {
        interName = name
        weatherURL = URL(string: url)
        print("init image \(interName)")
        super.init()
    }
    func fetchAsync() {
        if !isFetching, let url = weatherURL {
            print("start feteching image \(self.interName)")
            isFetching = true
            let downloadTask = URLSession.shared.downloadTask(with: url,completionHandler: {
                [weak self] url, response, error in if let error = error {
                    print("error downloading image \(self?.interName) error: \(error)")
                    
                    DispatchQueue.main.async {
                        if let strongSelf = self {
                            strongSelf.isFetching = false
                        }
                    }
                } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let url = url {
                    do {
                        print(url)
                        //                        let getData = try Data(contentsOf: url)
                        let getData = try NSData(contentsOf: url, options: NSData.ReadingOptions.uncached)
                        print("received data for image \(self?.interName)")
                        DispatchQueue.main.async {
                            if let strongSelf = self {
                                strongSelf.getData = getData as Data
                                print(getData)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "GetLife"), object: strongSelf)
                                strongSelf.isFetching = false
                            }
                        }
                    } catch {
                        print("error fetching data for image \(self?.interName) error: \(error)")
                        DispatchQueue.main.async {
                            self?.isFetching = false
                        }
                    }
                } else {
                    print("failed downloading image \(self?.interName) error: \(response)")
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
