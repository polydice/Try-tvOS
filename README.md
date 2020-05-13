# iCook tvOS App

![iOS build](https://github.com/polydice/iCook-tvOS/workflows/iOS%20build/badge.svg)
![Swift 5](https://img.shields.io/badge/Swift-5-orange.svg)
[![codecov.io](https://codecov.io/github/polydice/iCook-tvOS/coverage.svg?branch=develop)](https://codecov.io/github/polydice/iCook-tvOS?branch=develop)

A tvOS app that plays [iCook TV](https://tv.icook.tw/) videos.

<img src="https://polydice.github.io/iCook-tvOS/images/Screenshot.png" width=800px>

## Quick Start

Run the following commands to install dependencies:

```
make bootstrap
```

## Production Setups

If you work at Polydice, instead of `make bootstrap`, set up the project step by step with the following commands. Fill in the credentials and ask admin for required files.

```
bundle install
bundle exec pod install
```

#### API

`pod install` will prompt for the required configuration to run the app:

```
CocoaPods-Keys has detected a keys mismatch for your setup.
What is the key for BaseAPIURL
>
```

> TBD: API details are hidden for now due to proprietary reasons.

#### Required Keys

Managed by [CocoaPods-Keys](https://github.com/orta/cocoapods-keys):

* BaseAPIURL
* FacebookAppID


#### Required Files

* Required by the Firebase SDK for the `Release` configuration:

  ```
  iCookTV/GoogleService-Info.plist
  ```

* `icook-tv-top-shelf-image.png` is not included in the repo due to the license of image.

## Demo

* Download the tvOS app from [App Store](https://itunes.apple.com/tw/app/ai-liao-li/id554065086).

## Contact

[![Twitter](https://img.shields.io/badge/twitter-@polydice-blue.svg?style=flat)](https://twitter.com/polydice)

## License

The names and icons for iCook are trademarks of [Polydice, Inc.](https://polydice.com/) Please refer to the guidelines at [iCook Newsroom](https://newsroom.icook.tw/downloads).

* All image assets are Copyright © 2016 Polydice, Inc. All rights reserved.
* The source code is released under the MIT license. See [LICENSE](https://github.com/bcylin/Try-tvOS/blob/master/LICENSE) for more info.
