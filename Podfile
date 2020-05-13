source 'https://cdn.cocoapods.org/'

platform :tvos, "10.0"
use_frameworks!
inhibit_all_warnings!

workspace "iCookTV"
project "iCookTV"

target :iCookTV do
  pod "Alamofire", "4.8.2"
  pod "Firebase/Crashlytics"
  pod "HCYoutubeParser"
  pod "Hue", "5.0.0"
  pod "Kingfisher", "5.7.0"
  pod "FBSDKTVOSKit"
  pod "ComScore"

  target :iCookTVTests do
    pod "SwiftLint", '0.34.0'
  end
end


plugin "cocoapods-keys", {
  project: "iCookTV",
  keys: ["BaseAPIURL", "FacebookAppID", "ComScorePublisherID"]
}

