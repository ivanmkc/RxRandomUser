//
//  ModelMapper+transformations.swift
//  RandomUser
//
//  Created by Ivan Cheung on 2018-02-19.
//  Copyright © 2018 IvanCheung. All rights reserved.
//

import Mapper
import SwiftDate

struct ModelMapperTransformations {
    //Extract an URL from a String
    static func extractURLFromString(_ object:Any?) throws -> URL
    {
        guard let urlString = object as? String, let url = URL.init(string: urlString) else {
            throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        return url
    }
    
    //Extract a date from a String in the RandomUser.me format
    static func extractDateFromRandomUserDateString(object: Any?) throws -> Date {
        return try extractDateFromObject(object, format: .custom("yyyy-MM-dd HH:mm:ss"))
    }
    
    //Extract a date from a String given a DateFormat
    static func extractDateFromObject(_ object:Any?, format: DateFormat) throws -> Date
    {
        guard let dateString = object as? String, let date = dateString.date(format: format)
            else {
                throw MapperError.convertibleError(value: object, type: String.self)
        }
        
        return date.absoluteDate
    }
}
