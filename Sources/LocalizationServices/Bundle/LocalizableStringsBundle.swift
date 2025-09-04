//
//  LocalizableStringsBundle.swift
//  localization-services
//
//  Created by Levi Eggert on 8/1/23.
//  Copyright © 2023 Cru. All rights reserved.
//

import Foundation

public class LocalizableStringsBundle {
    
    private static let uniqueValue: String = UUID().uuidString
    
    public let bundle: Bundle
    public let table: String?
    
    public init(bundle: Bundle, table: String? = nil) {
        
        self.bundle = bundle
        self.table = table
    }
    
    public func stringForKey(key: String, table: String? = nil) -> String? {
        
        guard !key.isEmpty else {
            return nil
        }
        
        let table: String? = self.table ?? table
        
        let localizedString: String = bundle.localizedString(forKey: key, value: LocalizableStringsBundle.uniqueValue, table: table)
        
        guard !localizedString.isEmpty && localizedString != LocalizableStringsBundle.uniqueValue else {
            return nil
        }
        
        return localizedString
    }
}
