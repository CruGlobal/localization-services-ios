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
    
    public init(bundle: Bundle) {
        
        self.bundle = bundle
    }
    
    public func stringForKey(key: String) -> String? {
                
        let localizedString: String = bundle.localizedString(forKey: key, value: LocalizableStringsBundle.uniqueValue, table: nil)
        
        guard !localizedString.isEmpty else {
            return nil
        }
        
        guard localizedString != LocalizableStringsBundle.uniqueValue else {
            return nil
        }
        
        return localizedString
    }
}
