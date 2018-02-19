//
//  RandomUserResponsePlugin.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Result
import Moya

enum RandomUserResponseError: LocalizedError {
    case InvalidResponseFormat
    case Other(description: String)
    
    var errorDescription: String? {
        switch self {
        case .InvalidResponseFormat:
            return "Invalid response format"
        case .Other(let description):
            return description
        }
    }
}

class RandomUserResponsePlugin: PluginType {
    //Process the response according to RandomUser.Me's format
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>
    {
        switch (result)
        {
        case .success(let response):
            //Handle invalid statuses
            guard let responseFiltered = try? response.filterSuccessfulStatusCodes() else
            {
                return .failure(.statusCode(response))
            }
            
            //Handle invalid JSON formats
            guard let jsonDictionary = try? responseFiltered.mapJSON() as? [String: Any] else
            {
                return .failure(.jsonMapping(response))
            }
            
            //Extract results according to RandomUser.me format
            if let results = jsonDictionary?["results"]
            {
                let data = (try? serializeJSONToData(results)) ?? Data()
                
                return .success(Response(statusCode: response.statusCode, data:data))
            }
            //Extract RandomUser.me errors
            //Note: Their documentation doesn't mention the status code for errors, assuming it is 200 for now.
            if let errorString = jsonDictionary?["error"] as? String
            {
                return .failure(.underlying(RandomUserResponseError.Other(description: errorString), nil))
            }
            else
            {
                return .failure(.underlying(RandomUserResponseError.InvalidResponseFormat, nil))
            }
            
        case .failure(let error):
            return .failure(error)
        }
    }
}

private extension RandomUserResponsePlugin
{
    func serializeJSONToData(_ jsonObject: Any) throws -> Data
    {
        let data = try JSONSerialization.data(withJSONObject: jsonObject)
        return data
    }
}

