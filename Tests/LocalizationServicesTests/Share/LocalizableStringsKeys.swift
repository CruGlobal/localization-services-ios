//
//  LocalizableStringsKeys.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation

enum LocalizableStringsKeys: String {
    
    case testValueYes = "test.value.yes"
}

extension LocalizableStringsKeys {
    var key: String {
        return rawValue
    }
}
