//
//  DefaultParsers.swift
//  Pods
//
//  Created by Siddharth Gupta on 06/09/17.
//
//

import Foundation


/// Built-In response interceptor which runs the given response through it's expected ResponseParser.
public class SwiftyParsingInterceptor: ResponseInterceptor {
    
    /// Intercepts the network response, runs throught it's expected ResponseParses and gives back the NetworkResponse.
    ///
    /// - Parameter response: NetworkResponse
    /// - Returns: NetworkResponse
    public func intercept(response: NetworkResponse) -> NetworkResponse {
        do {
            try response.parser?.parse(response: response)
        } catch let error {
            response.error = error as NSError
        }
        return response
    }
}

/// Serializes the network response to JSON and throws SwiftyError if any.
struct JSONParser: ResponseParser {
    
    let readingOptions: JSONSerialization.ReadingOptions
    
    func parse(response: NetworkResponse) throws {
        guard response.error == nil else {
            throw response.error!
        }
        
        if let data = response.data, data.count > 0 {
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: readingOptions)
                response.result = json
            }
            catch let error {
                throw SwiftyError.jsonParsingFailure(error: error)
            }
            
        } else {
            throw SwiftyError.responseValidation(reason: "Empty Data Received")
        }
    }
}