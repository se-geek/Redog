//
//  APIRequest.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import Foundation

enum Method : String {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
}

protocol APIRequest {
    var method : Method { get }
    var base : String { get }
    var path: String { get }
    var parameters: [String : String] { get }
}

extension APIRequest {
    
    var method: Method {
        return .GET
    }
    
    var urlComponents: URLComponents {
        var components = URLComponents(string: base)!
        components.path = path
        
        if parameters.values.count > 0 {
            components.queryItems = parameters.map { URLQueryItem(name: String($0) , value: String($1) )
                
            }
        }
        return components
    }
    
    var request: URLRequest {
        let url = urlComponents.url!
        var urlRequest: URLRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
    
}

enum DogsRequest {
    case getDogs
}

extension DogsRequest: APIRequest {
    
    
    var base: String {
        return "https://dog.ceo"
    }
    
    var path: String {
        return "/api/breeds/image/random"
    }
    
    var parameters: [String : String] {
        return [:]
    }
    
    var method: Method {
        return .GET
    }
    
}


class APIRequester: APIClient {
    
    let session : URLSession
    
    init(configuration : URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration : .default)
    }
    
    func getDogImages(for apiRequest: DogsRequest, completion: @escaping (Result<GenerateDogsModel?, APIError>, HTTPURLResponse?) -> Void) {
        
        var finalRequest = apiRequest.request
        addDefaultHeaders(to: &finalRequest)
        fetch(with: finalRequest, decode: { (json) -> GenerateDogsModel? in
            guard let response = json as? GenerateDogsModel else { return nil}
            return response
        }, completion: completion)
    }
    
}
