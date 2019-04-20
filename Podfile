source 'https://github.com/CocoaPods/Specs.git'

platform :tvos, "9.0"
use_frameworks!
inhibit_all_warnings!

workspace "iCookTV"
project "iCookTV"

target :iCookTV do
  pod "Alamofire", "~> 4.2.0"
  pod "Crashlytics"
  pod "Fabric"
  pod "Freddy", "~> 3.0.0"
  pod "HCYoutubeParser"
  pod "Hue", "~> 2.0.0"
  pod "R.swift"
  pod "Kingfisher"
  pod "TreasureData-iOS-SDK", "0.1.15"

  target :iCookTVTests do
    pod "Nimble"
    pod "Quick"
    pod "SwiftLint"
  end
end


plugin "cocoapods-keys", {
  project: "iCookTV",
  keys: ["BaseAPIURL", "CrashlyticsAPIKey", "TreasureDataAPIKey"]
}

