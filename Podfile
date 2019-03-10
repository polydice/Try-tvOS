source "https://github.com/CocoaPods/Specs.git"

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
  pod "R.swift", "~> 3.2.0"
  pod "Kingfisher", "~> 3.2.0"
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


# Specify Swift version in the configs for all the pods installed.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["SWIFT_VERSION"] = "3.0"
    end
  end
end
