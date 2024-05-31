//
//  LocalizableStringsdictKeys.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation

enum LocalizableStringsdictKeys: String {
    
    case accountActivityToolOpens = "account.activity.toolOpens"
    case badgesToolsOpened = "badges.toolsOpened"
}

extension LocalizableStringsdictKeys {
    var key: String {
        return rawValue
    }
}

