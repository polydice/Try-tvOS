source 'https://cdn.cocoapods.org/'

platform :tvos, "10.0"
use_frameworks!
inhibit_all_warnings!

workspace "iCookTV"
project "iCookTV"

target :iCookTV do
  pod "Alamofire", "4.8.2"
  pod "Firebase/Crashlytics"
  pod "Hue", "5.0.0"
  pod "Kingfisher"
  pod "FBSDKTVOSKit"
  pod "ComScore"

  target :iCookTVTests do
    pod "SwiftLint"
  end
end


plugin "cocoapods-keys", {
  project: "iCookTV",
  keys: ["BaseAPIURL", "FacebookAppID", "ComScorePublisherID"]
}

