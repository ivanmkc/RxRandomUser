//
//  RandomUserTarget.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Moya

enum RandomUserTarget {
    case GetRandomUsers(numberOfUsers : Int)
}

extension RandomUserTarget : TargetType {
    var headers: [String : String]? {
        return nil
    }
    
    var baseURL: URL { return URL(string: "https://randomuser.me/api")! }
    var path: String {
        switch self {
        case .GetRandomUsers:
            return ""
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .GetRandomUsers(let numberOfUsers):
            return ["results" : numberOfUsers]
        }
    }
    
    var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
    
    var sampleData: Data {
        let name: String
        
        switch self {
        case .GetRandomUsers:
            name = "GetRandomUsers"
        }
        
        guard let pathUrl = Bundle.main.url(forResource: name, withExtension: "json"),
            let data = try? Data(contentsOf: pathUrl) else {
                return Data()
        }
        
        return data
    }
    
    var task : Task {
        guard let parameters = self.parameters, !parameters.isEmpty else { return .requestPlain }
        
        return .requestParameters(parameters: parameters, encoding: self.parameterEncoding)
    }
}
