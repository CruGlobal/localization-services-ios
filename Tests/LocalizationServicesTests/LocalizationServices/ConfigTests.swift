//
//  ConfigTests.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 8/15/26.
//

import Foundation
import Testing
@testable import LocalizationServices

struct ConfigTests {

    @Test
    func configUsesDefaultsWhenNotProvided() {

        let config = Config(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )

        #expect(config.fetchStringsInOrder.map { $0.id } == Config.defaultFetchOrder.map { $0.id })
        #expect(config.shouldFallbackToKeyIfNoString == Config.defaultShouldFallbackToKey)
    }

    @Test
    func configUsesDefaultsWhenProvidedValuesAreNil() {

        let config = Config(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true,
            fetchStringsInOrder: nil,
            shouldFallbackToKeyIfNoString: nil
        )

        #expect(config.fetchStringsInOrder.map { $0.id } == Config.defaultFetchOrder.map { $0.id })
        #expect(config.shouldFallbackToKeyIfNoString == Config.defaultShouldFallbackToKey)
    }

    @Test
    func configStoresProvidedValues() {

        let bundle: Bundle = Bundle.getTestBundle()

        let config = Config(
            localizableStringsFilesBundle: bundle,
            isUsingBaseInternationalization: false,
            fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id), .system, .english],
            shouldFallbackToKeyIfNoString: true
        )

        #expect(config.localizableStringsFilesBundle == bundle)
        #expect(config.isUsingBaseInternationalization == false)
        #expect(config.fetchStringsInOrder.map { $0.id } == [LocaleId.spanish.id, "system", "english"])
        #expect(config.shouldFallbackToKeyIfNoString == true)
    }

    @Test
    func localizationServicesExposesConfig() async {

        let config = Config(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true,
            fetchStringsInOrder: [.locale(identifier: LocaleId.spanish.id)],
            shouldFallbackToKeyIfNoString: true
        )

        let localizationServices = LocalizationServices(config: config)
        let asyncLocalizationServices = AsyncLocalizationServices(config: config)

        #expect(localizationServices.config.fetchStringsInOrder.map { $0.id } == [LocaleId.spanish.id])
        #expect(localizationServices.config.shouldFallbackToKeyIfNoString == true)
        #expect(await asyncLocalizationServices.config.fetchStringsInOrder.map { $0.id } == [LocaleId.spanish.id])
        #expect(await asyncLocalizationServices.config.shouldFallbackToKeyIfNoString == true)
    }

    @Test
    func localizationServicesUsesDefaultFetchOrderWhenNotProvided() async {

        let config = Config(
            localizableStringsFilesBundle: Bundle.getTestBundle(),
            isUsingBaseInternationalization: true
        )

        #expect(LocalizationServices(config: config).stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
        #expect(await AsyncLocalizationServices(config: config).stringForKey(key: LocalizableStringsKeys.testValueYes.key) == "yes")
    }
}
