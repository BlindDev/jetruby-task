//
//  DesignExtensions.swift
//  DribbleClient
//
//  Created by Pavel Popov on 12.09.16.
//  Copyright © 2016 Pavel Popov. All rights reserved.
//

import Foundation

extension String {
    
    public var convertedDate: NSDate!{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        return dateFormatter.dateFromString(self)
    }
    
    public var withoutHTML: String!{
        return self.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
    }
}

extension NSDate {
    public var convertedString: String!{
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "d MM yyyy HH:mm:ss"
        
        return dateFormatter.stringFromDate(self)
    }
}