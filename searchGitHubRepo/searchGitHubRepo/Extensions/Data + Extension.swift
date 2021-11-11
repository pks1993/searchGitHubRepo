//
//  Data + Extension.swift
//  searchGitHubRepo
//
//  Created by Phyo Kyaw Swar on 09/11/2021.
//

import Foundation
extension Data {
    func decode<T>(modelType: T.Type) -> T? where T : Decodable{
        let decoder = JSONDecoder()
        do {
            let result = try decoder.decode(modelType, from: self)
            return result
        } catch let jsonError{
            print("an error occur while decoding . . . \(jsonError.localizedDescription) >>>>> \(modelType)")
            return nil
        }
    }
    
   
}
