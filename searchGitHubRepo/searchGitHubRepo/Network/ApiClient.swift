//
//  ApiClient.swift
//  searchGitHubRepo
//
//  Created by Phyo Kyaw Swar on 09/11/2021.
//

import Foundation

struct ApiClient {
    static let shared = ApiClient()
    
    let baseUrl = "https://api.github.com/search/repositories"
    let session = URLSession.shared
    var task : URLSessionDataTask?
    
    func getRepositoryList(parameters : [String : String]? = nil , success : @escaping(RepositoryVO?) -> Void ,
                 failure : @escaping(Error) -> Void) {
        var components = URLComponents(string: baseUrl)!
        if let params = parameters {
            components.queryItems = params.map { (key, value) in
                URLQueryItem(name: key, value: value )
            }
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
        }
        
        
        var urlRequest = URLRequest(url: components.url!)
        urlRequest.setValue("application/vnd.github.v3+json", forHTTPHeaderField: "accept")
        
        task?.cancel()
        
        let task = session.dataTask(with : urlRequest) { data, response, error  in
            
            print("Response >>>>" , response)
            if let response =  response as? HTTPURLResponse ,
               response.statusCode == 200 {
                if let json = try? JSONSerialization.jsonObject(with: data!, options: .fragmentsAllowed) {
                    print("Response Json >>>> " , json)
                    
                }
//                if let data = data {
//                    let encoder = JSONDecoder()
//                    let repository =  try? encoder.decode(RepositoryVO.self, from: data)
//                    success(repository)
//                }
               
                if let data = data {
                    let repository : RepositoryVO? =  data.decode(modelType: RepositoryVO.self)
                    success(repository)
                }
                
            }
            else {
//                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
//                    print("Response Json >>>> " , json)
//                }
            }
            
            
            if let error = error {
                print("Error >>>>" , error.localizedDescription)
            }
        }
        task.resume()
    }
    
}
