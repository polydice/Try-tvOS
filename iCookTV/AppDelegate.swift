//
//  AppDelegate.swift
//  TryTVOS
//
//  Created by Ben on 16/09/2015.
//  Copyright © 2015 bcylin.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit
import Crashlytics
import Fabric
import TreasureData_tvOS_SDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  let tabBarController = UITabBarController()
  private var backgroundTask = UIBackgroundTaskInvalid

  // MARK: - UIApplicationDelegate

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    GroundControl.sync()
    setUpAnalytics()

    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window?.rootViewController = TrackableNavigationController(rootViewController: LaunchViewController())
    window?.makeKeyAndVisible()

    return true
  }

  func applicationDidEnterBackground(application: UIApplication) {
    TreasureData.sharedInstance().endSession(Tracker.sessionsTable)

    backgroundTask = application.beginBackgroundTaskWithExpirationHandler { [weak self] in
      self?.endBackgroundTask(inApplication: application)
    }

    TreasureData.sharedInstance().uploadEventsWithCallback({ [weak self] in
      self?.endBackgroundTask(inApplication: application)
    }) { [weak self] _ in
      self?.endBackgroundTask(inApplication: application)
    }
  }

  // MARK: - Private Methods

  private func endBackgroundTask(inApplication application: UIApplication) {
    application.endBackgroundTask(backgroundTask)
    backgroundTask = UIBackgroundTaskInvalid
  }

  private func setUpAnalytics() {
    Crashlytics.startWithAPIKey(iCookTVKeys.CrashlyticsAPIKey)
    Fabric.with([Crashlytics.self])

    TreasureData.initializeApiEndpoint("https://in.treasuredata.com")
    TreasureData.initializeWithApiKey(iCookTVKeys.TreasureDataAPIKey)
    TreasureData.sharedInstance().enableAutoAppendUniqId()
    TreasureData.sharedInstance().enableAutoAppendModelInformation()
    TreasureData.sharedInstance().enableAutoAppendAppInformation()
    TreasureData.sharedInstance().enableAutoAppendLocaleInformation()

    TreasureData.sharedInstance().defaultDatabase = Tracker.defaultDatabase
    TreasureData.sharedInstance().startSession(Tracker.sessionsTable)
  }

}
