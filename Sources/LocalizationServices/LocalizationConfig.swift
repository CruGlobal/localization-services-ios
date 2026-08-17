//
//  LocalizationConfig.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 8/15/26.
//

import Foundation

public struct LocalizationConfig: Sendable {

    let localizableStringsFilesBundle: Bundle?
    let isUsingBaseInternationalization: Bool

    public init(
        localizableStringsFilesBundle: Bundle?,
        isUsingBaseInternationalization: Bool
    ) {

        self.localizableStringsFilesBundle = localizableStringsFilesBundle
        self.isUsingBaseInternationalization = isUsingBaseInternationalization
    }
}
