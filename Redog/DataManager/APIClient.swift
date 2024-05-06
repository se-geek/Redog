//
//  APIClient.swift
//  Redog
//
//  Created by Srinivas on 04/05/24.
//

import Foundation

enum APIError : Error {
    case requestFailed
    case jsonConversionFailure
    case invalidData
    case responseUnsuccessful
    case jsonParsingFailure
    
    var localizedDescription: String {
        switch self {
        case .requestFailed: return "Request Failed"
        case .jsonConversionFailure: return "Json Conversion Failure"
        case .invalidData: return "invalid Data"
        case .responseUnsuccessful: return "Response unsuccessful "
        case .jsonParsingFailure : return "Json Parsing Failure "
        }
    }
    
}

protocol APIClient {
    var session : URLSession { get }
    func fetch<T : Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>, HTTPURLResponse?) -> Void)
}

extension APIClient {
    
    var session: URLSession{
        return URLSession(configuration: .default)
    }
    
    typealias JsonTaskCompletionHandler = (Decodable?, APIError?, HTTPURLResponse?) -> Void
    
    typealias TaskCompletionHandler  = (Data?, APIError?, HTTPURLResponse?) -> Void
    
    private func decodingTask<T: Decodable>(with request: URLRequest, decodingType: T.Type, completionHandler completion: @escaping JsonTaskCompletionHandler) -> URLSessionDataTask {
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed, nil)
                return
            }
            if httpResponse.statusCode ==  200 {
                if let data = data{
                    do {
                        self.testParseJson(data: data)
                        let genericModel = try JSONDecoder().decode(decodingType.self, from: data)
                        completion(genericModel, nil, httpResponse)
                    } catch {
                        completion(nil, .jsonConversionFailure, httpResponse)
                    }
                } else {
                    completion(nil, .invalidData, httpResponse)
                }
            }
            else if httpResponse.statusCode ==  400 {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data ?? Data(), options: []) as? [String: Any] {
                        print(json)
                    }
                }
                catch {
                    print("JSONSerialization error:", error)
                }
                
                completion(data, .invalidData, httpResponse)
            }
            else if httpResponse.statusCode ==  500 {
                completion(nil, .invalidData, httpResponse)
            }
            else {
                if let data = data{
                    do{
                        self.testParseJson(data: data)
                        let genericModel = try JSONDecoder().decode(decodingType.self, from: data)
                        completion(genericModel, nil, httpResponse)
                    } catch {
                        completion(nil, .jsonParsingFailure, httpResponse)
                    }
                } else {
                    completion(nil, .responseUnsuccessful, httpResponse)
                }
            }
        }
        
        return task
    }
    
    func addDefaultHeaders(to request: inout URLRequest) {
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    
    func fetch<T: Decodable>(with request: URLRequest, decode: @escaping (Decodable) -> T?, completion: @escaping (Result<T, APIError>, HTTPURLResponse?) -> Void) {
        var finalRequest = request
        let task = decodingTask(with: finalRequest, decodingType: T.self) { (json, error, response) in
            
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        completion(.failure(error), response)
                    } else {
                        completion(.failure(.invalidData), response)
                    }
                    return
                }
                if let value = decode(json){
                    completion(Result.success(value), response)
                } else {
                    completion(Result.failure(.jsonParsingFailure), response)
                }
            }
        }
        task.resume()
        
    }
    
    func fetchJsonData(with request: URLRequest,completionHandler completion: @escaping TaskCompletionHandler)  {
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                guard let httpResponse = response as? HTTPURLResponse else {
                    completion(nil, .requestFailed, nil)
                    return
                }
                if httpResponse.statusCode == 200 {
                    if let data = data {
                        //self.testParseJson(data: data)
                        completion(data, nil, httpResponse)
                    } else {
                        completion(nil, .invalidData, httpResponse)
                    }
                } else {
                    if let dataObj = data {
                        self.testParseJson(data: dataObj)
                    }
                    completion(data, .responseUnsuccessful, httpResponse)
                }
            }
        }
        task.resume()
        
    }
    
    func testParseJson(data: Data)  {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else{ return }
        print("Get data successfully")
        //Log.d(data.prettyPrintedJSONString as Any)
    }
    
}
