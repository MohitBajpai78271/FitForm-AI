//
//  FitForm_AIApp.swift
//  FitForm AI
//
//  Created by Mac on 25/12/24.
//

import SwiftUI
import Firebase
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
      return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct FitForm_AIApp: App {
    let persistenceController = PersistenceController.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authManager = AuthManager.shared
    var body: some Scene { 
        WindowGroup {
            if authManager.isSignedIn {
                         ContentView()
                     } else {
                         SignInView()
                             .environmentObject(authManager)
                     }
        }
    }
}

//            ContentView()
//            SignInView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)

