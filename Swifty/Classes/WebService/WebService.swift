//
//  WebService.swift
//  Pods
//
//  Created by Siddharth Gupta on 16/03/17.
//
//

import Foundation


/// WebServiceNetworkInterface: A protocol which lets any object become a bridge between a webservice and the internet.
///
/// Conformance to this only requires the implementation of one method: loadResource(resource: completion:)
@objc public protocol WebServiceNetworkInterface: class {
    
    /// Implement this method to tell a WebService what to do when .load() is called on it's NetworkResource. The NetworkResource on which the .load() method is called comes in as an argument, and any networking library can be used to fire the resource's internal request over the network, and then a NetworkResponse can be created from the internet's response, and passed into the completion closure.
    ///
    /// - Parameters:
    ///   - resource: NetworkResource
    ///   - completion: The completion block which expects a NetworkResponse for the resource that was passed in.
    func loadResource(resource: NetworkResource, completion: @escaping (NetworkResponse) -> Void)
}

/// WebService is a protocol which helps you write your network requests in a declarative, type-safe and expressive way.
///
/// You start by creating a class, putting in your server's base URL & a network interface, and begin writing your network requests as functions
@objc public protocol WebService {
    
    /// Base URL
    static var serverURL: String { get set }
    
    /// WebServiceNetworkInterface
    static var networkInterface: WebServiceNetworkInterface { get set }
}

extension WebService {
    
    /// A BaseResource created from the server URL of the WebService
    static public var server: BaseResource {
        if let url = URL(string: serverURL) {
            return BaseResource(request: NSMutableURLRequest(url: url), networkInterface: networkInterface)
        }
        return BaseResource(predisposition: WebServiceError.invalidBaseURL(url: "Your WebService \(self) has an Invalid Server Base URL | Please make sure you specifiy a scheme (http/https) and a valid path with URL Allowed Characters, a trailing slash is not required."))
    }
    
    /// Can be used to use a custom base URL for a given request, instead of the using the WebService's Server URL
    ///
    /// - Parameter baseURL: String
    /// - Returns: BaseResource
    static public func customResource(with baseURL: String) -> BaseResource {
        if let customURL = URL(string: baseURL) {
            let request = NSMutableURLRequest(url: customURL)
            return BaseResource(request: request, networkInterface: networkInterface)
        }
        return BaseResource(predisposition: WebServiceError.invalidBaseURL(url: "Invalid URL passed into custom resource | Please make sure you specifiy a scheme (http/https) and a valid path with URL Allowed Characters, a trailing slash is not required."))
    }
    
}
