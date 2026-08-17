//
//  LocalizationConfigTests.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 8/15/26.
//

import Foundation
import Testing
@testable import LocalizationServices

struct LocalizationConfigTests {

    @Test
    func configStoresProvidedValues() {

        let bundle: Bundle = Bundle.getTestBundle()

        let config = LocalizationConfig(
            localizableStringsFilesBundle: bundle,
            isUsingBaseInternationalization: false
        )

        #expect(config.localizableStringsFilesBundle == bundle)
        #expect(config.isUsingBaseInternationalization == false)
    }

    @Test
    func localizationServicesExposesConfig() async {

        let bundle: Bundle = Bundle.getTestBundle()

        let config = LocalizationConfig(
            localizableStringsFilesBundle: bundle,
            isUsingBaseInternationalization: true
        )

        let localizationServices = LocalizationServices(config: config)
        let asyncLocalizationServices = AsyncLocalizationServices(config: config)

        #expect(localizationServices.config.localizableStringsFilesBundle == bundle)
        #expect(localizationServices.config.isUsingBaseInternationalization == true)
        #expect(await asyncLocalizationServices.config.localizableStringsFilesBundle == bundle)
        #expect(await asyncLocalizationServices.config.isUsingBaseInternationalization == true)
    }
}
