//
//  LocaleLocalizableStringsBundleTests.swift
//  LocalizationServices
//
//  Created by Levi Eggert on 9/4/25.
//

import Foundation
import Testing
@testable import LocalizationServices

struct LocaleLocalizableStringsBundleTests {

    @Test
    func missingLocaleResourceReturnsNilBundle() {

        let localeBundle: LocaleLocalizableStringsBundle? = LocaleLocalizableStringsBundle(
            localeIdentifier: LocalizableStringsBundleLoaderTests.missingLocalizableStringsResource,
            localeBundleLoader: LocalizableStringsBundleLoader(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: false
            )
        )

        #expect(localeBundle == nil)
    }

    @Test
    func existingLocaleResourceReturnsBundle() {

        let localeBundle: LocaleLocalizableStringsBundle? = LocaleLocalizableStringsBundle(
            localeIdentifier: "es",
            localeBundleLoader: LocalizableStringsBundleLoader(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: false
            )
        )

        #expect(localeBundle != nil)
    }

    @Test
    func unsupportedLocaleLoadsBaseLanguageLocale() throws {

        let unsupportedLocale: String = "ru-143"

        let localeBundle: LocaleLocalizableStringsBundle? = LocaleLocalizableStringsBundle(
            localeIdentifier: unsupportedLocale,
            localeBundleLoader: LocalizableStringsBundleLoader(
                localizableStringsFilesBundle: Bundle.getTestBundle(),
                isUsingBaseInternationalization: false
            )
        )

        let unwrappedLocaleBundle: LocaleLocalizableStringsBundle = try #require(localeBundle)

        #expect(unwrappedLocaleBundle.localizableStringsBundle.table == unsupportedLocale)
    }
}
