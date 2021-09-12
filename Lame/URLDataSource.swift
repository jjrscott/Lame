//
//  URLDataSource.swift
//  URLDataSource
//
//  Created by John Scott on 9/12/21.
//  Copyright © 2021 John Scott. All rights reserved.
//

import Foundation

protocol URLDataSource {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class URLSessionDataSource: NSObject, URLSessionDelegate, URLDataSource {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) {
        let task = urlSession.dataTask(with: url, completionHandler: completionHandler)
        task.resume()
    }
    
    // MARK: - URLSession
    
    private lazy var urlSession = defaultURLSession()
    
    private func defaultURLSession() -> URLSession {
        let configuration = URLSessionConfiguration.default
        let delegate = URLSessionDataSourceURLSessionDelegate()
        return URLSession(configuration: configuration, delegate: delegate, delegateQueue: nil)
    }
}

/**
 Certain firewalls override the certificate chain forcing us to use NSAllowsArbitraryLoads. However, even this is insufficient as iOS sees this (correctly)
 as a man in the middle attack (https://en.wikipedia.org/wiki/Man-in-the-middle_attack). To get arround that we need to not just use
 `.useCredential` with `nil` credential, but force it to trust the untrustworthy credential we were given.
 */

class URLSessionDataSourceURLSessionDelegate : NSObject, URLSessionDelegate {
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        if let serverTrust = challenge.protectionSpace.serverTrust {
            completionHandler(.useCredential, URLCredential(trust: serverTrust))
        } else {
            completionHandler(.rejectProtectionSpace, nil)
        }
    }
}
