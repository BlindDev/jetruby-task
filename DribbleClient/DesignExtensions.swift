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
        get{
            //YYYY-MM-DDTHH:MM:SSZ

            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-ddTHH:MM:SSZ"
            
            return dateFormatter.dateFromString(self)
        }
    }
}

extension NSDate {
    public var convertedString: String!{
        get{            
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy MM DD"
            
            return dateFormatter.stringFromDate(self)
        }
    }
}