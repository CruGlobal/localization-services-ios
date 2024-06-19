//
//  LocalizationServicesInterface.swift
//  localization-services
//
//  Created by Levi Eggert on 3/14/24.
//  Copyright © 2024 Cru. All rights reserved.
//

import Foundation

public protocol LocalizationServicesInterface {
 
    func stringForEnglish(key: String) -> String
    func stringForSystemElseEnglish(key: String) -> String
    func stringForLocaleElseEnglish(localeIdentifier: String?, key: String) -> String
    func stringForLocaleElseSystemElseEnglish(localeIdentifier: String?, key: String) -> String
}
