//
//  AppDelegate.swift
//  ABSHR
//
//  Created by mac on 05/10/20.
//  Copyright © 2020 . All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import FirebaseCore
import Firebase
import Messages
import UserNotifications
import FirebaseMessaging
import FirebaseAnalytics
import FirebaseAuth
import FirebaseInstanceID
import GoogleMaps
import GooglePlaces
import GoogleSignIn
import Localize_Swift
import MLKitTranslate

@UIApplicationMain

class AppDelegate: UIResponder,UIApplicationDelegate,UNUserNotificationCenterDelegate,MessagingDelegate{

var window: UIWindow?
let gcmMessageIDKey = "gcm.message_id"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        TranslatorManager.shared.downloadModel()
        
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .arabic)

        let englishArabicTranslator = Translator.translator(options: options)

        let conditions = ModelDownloadConditions(
            allowsCellularAccess: true,
            allowsBackgroundDownloading: true
        )
        englishArabicTranslator.downloadModelIfNeeded(with: conditions) { error in
            guard error == nil else { return }
            self.translateText(text: "Home") { (str) in
                print("Home".localized())
                print(str)
            }
            print("Arabic Model downloaded")
            // Model downloaded successfully. Okay to start translating.
        }
        
        
        Localize.setCurrentLanguage(getCurrentLang())
         IQKeyboardManager.shared.enable = true
        self.registerForPushNotifications()
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        GMSServices.provideAPIKey(API_KEY)
        GMSPlacesClient.provideAPIKey(API_KEY)
        GIDSignIn.sharedInstance().clientID = CLIENTID
        Auth.auth().settings?.isAppVerificationDisabledForTesting = false
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                //                device_token = result.token
            }
        }
        Messaging.messaging().isAutoInitEnabled = true
        
        return true
    }
    
    public func translateText(text:String,Complition:@escaping(String) -> Void){
        if getCurrentLang() == "ar-SA"{
        let options = TranslatorOptions(sourceLanguage: .english, targetLanguage: .arabic)
        let englishArabicTranslator = Translator.translator(options: options)
        englishArabicTranslator.translate(text) { translatedText, error in
            guard error == nil, let translatedText = translatedText else {
                print(error?.localizedDescription)
                Complition(text)
                return }
            Complition(translatedText)
            // Translation succeeded.
        }
        }else {
            Complition(text)
        }
    }
    
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        let dataDict:[String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
        
    }
    
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        Auth.auth().setAPNSToken(deviceToken, type: .sandbox)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        print(userInfo)
        
        // Change this to your preferred presentation option
        completionHandler([.sound,.alert,.badge])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        completionHandler()
    }
    
    func application(_ app: UIApplication,open url: URL,options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if Auth.auth().canHandle(url) {
            return true
        }else{
            print("url \(url)")
            print("url host :\(url.host!)")
            print("url path :\(url.path)")
            return true
        }
        
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        let app = UIApplication.shared
        var bgTask:UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
        bgTask = app.beginBackgroundTask(expirationHandler: {
            app.endBackgroundTask(bgTask)
        })
    }
    
}

