//
//  Bundle+TestBundle.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation

extension Bundle {
    
    static func getTestBundle() -> Bundle {
        
        var testBundle: Bundle = Bundle.main
        
        #if SWIFT_PACKAGE
            testBundle = Bundle.module
        #endif
        
        return testBundle
    }
}
