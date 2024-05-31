//
//  LocaleId.swift
//  localization-services
//
//  Created by Levi Eggert on 5/31/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation

enum LocaleId: String {
    case english = "en"
    case spanish = "es"
}

extension LocaleId {
    var id: String {
        return rawValue
    }
}
