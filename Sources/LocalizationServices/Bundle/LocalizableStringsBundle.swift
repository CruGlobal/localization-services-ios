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
        
        let returnValueIfNotFound: String = LocalizableStringsBundle.uniqueValue
        
        let table: String? = self.table ?? table
        
        if let table = table, !table.isEmpty {
            
            let localizedString: String = getStringFromBundle(key: key, returnValueIfNotFound: returnValueIfNotFound, table: table)
            
            if localizedStringIsValid(localizedString: localizedString, returnValueIfNotFound: returnValueIfNotFound) {
                return localizedString
            }
        }
        
        let localizedString: String = bundle.localizedString(forKey: key, value: returnValueIfNotFound, table: nil)
        
        guard localizedStringIsValid(localizedString: localizedString, returnValueIfNotFound: returnValueIfNotFound) else {
            return nil
        }
        
        return localizedString
    }
    
    private func getStringFromBundle(key: String, returnValueIfNotFound: String?, table: String?) -> String {
        return bundle.localizedString(forKey: key, value: returnValueIfNotFound, table: table)
    }
    
    private func localizedStringIsValid(localizedString: String, returnValueIfNotFound: String) -> Bool {
        return !localizedString.isEmpty && localizedString != LocalizableStringsBundle.uniqueValue
    }
}
