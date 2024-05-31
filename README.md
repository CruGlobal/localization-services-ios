# localization-services-ios
Class for fetching localized strings based on a Locale from a Bundle's .strings and .stringsdict files

- [Publishing New Versions](#publishing-new-versions)


### Publishing New Versions

Steps to publish new versions for Cocoapods and Swift Package Manager. 

- Edit LocalizationServices.podspec s.version to the newly desired version following Major.Minor.Patch.

- Run command 'pod lib lint LocalizationServices.podspec' to ensure it can deploy without any issues (https://guides.cocoapods.org/making/using-pod-lib-create.html#deploying-your-library).

- Merge the s.version change into the main branch and then tag the main branch with the new version and push the tag to remote (Swift Package Manager relies on tags).  

- Run command 'pod repo push cruglobal-cocoapods-specs LocalizationServices.podspec' to push to CruGlobal cocoapods specs (https://github.com/CruGlobal/cocoapods-specs).  You can also run command 'pod repo list' to see what repos are currently added and 'pod repo add cruglobal-cocoapods-specs https://github.com/CruGlobal/cocoapods-specs.git' to add repos (https://guides.cocoapods.org/making/private-cocoapods.html).


Cru Global Specs Repo: https://github.com/CruGlobal/cocoapods-specs

Private Cocoapods: https://guides.cocoapods.org/making/private-cocoapods.html