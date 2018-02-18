//
//  MockErrorPlugin.swift
//  RandomUserTests
//
//  Created by Ivan Cheung on 2018-02-18.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Result
import Moya

class MockErrorPlugin: PluginType {
    
    private let mockError: Error
    
    init(mockError: Error) {
        self.mockError = mockError
    }
    
    //Process the response according to RandomUser.Me's format
    func process(_ result: Result<Moya.Response, MoyaError>, target: TargetType) -> Result<Moya.Response, MoyaError>
    {
        return .failure(.underlying(mockError, nil))
    }
}
