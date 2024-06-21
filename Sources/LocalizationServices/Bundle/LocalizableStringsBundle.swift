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
        
        guard !key.isEmpty else {
            return nil
        }
        
        let localizedString: String = bundle.localizedString(forKey: key, value: LocalizableStringsBundle.uniqueValue, table: nil)
        
        guard !localizedString.isEmpty && localizedString != LocalizableStringsBundle.uniqueValue else {
            return nil
        }
        
        return localizedString
    }
}
