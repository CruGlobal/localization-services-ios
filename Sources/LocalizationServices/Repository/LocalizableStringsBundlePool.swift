//
//  LocalizableStringsBundlePool.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 7/28/26.
//

import Foundation

actor LocalizableStringsBundlePool {
    
    final class PoolObject {
        
        let localeIdentifier: String
        let stringsBundle: LocalizableStringsBundle?
        
        init(localeIdentifier: String, stringsBundle: LocalizableStringsBundle?) {
            self.localeIdentifier = localeIdentifier
            self.stringsBundle = stringsBundle
        }
    }
    
    private let localizableStringsBundleLoader: LocalizableStringsBundleLoader
    private let maxSize: Int
    
    private var pool: [PoolObject] = Array()
    
    init(localizableStringsBundleLoader: LocalizableStringsBundleLoader, maxSize: Int = 5) {
        
        self.localizableStringsBundleLoader = localizableStringsBundleLoader
        self.maxSize = maxSize
    }
    
    func getStringsBundle(localeIdentifier: String) -> LocalizableStringsBundle? {
        
        if let object = pool.first(where: { $0.localeIdentifier == localeIdentifier }) {
            return object.stringsBundle
        }
    
        let localeLocalizableStringsBundle = LocaleLocalizableStringsBundle(
            localeIdentifier: localeIdentifier,
            localeBundleLoader: localizableStringsBundleLoader
        )
        
        addStringsBundle(
            localeIdentifier: localeIdentifier,
            stringsBundle: localeLocalizableStringsBundle?.localizableStringsBundle
        )
        
        return localeLocalizableStringsBundle?.localizableStringsBundle
    }
    
    func addStringsBundle(localeIdentifier: String, stringsBundle: LocalizableStringsBundle?) {
        
        let object = PoolObject(
            localeIdentifier: localeIdentifier,
            stringsBundle: stringsBundle
        )
        
        pool.insert(object, at: 0)
        
        if pool.count > maxSize {
            _ = pool.removeLast()
        }
    }
}
