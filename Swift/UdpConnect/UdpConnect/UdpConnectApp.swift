//
//  UdpConnectApp.swift
//  UdpConnect
//
//  Created by 和田健 on 2023/09/06.
//

import SwiftUI

@main
struct UdpConnectApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
    func applicationDidEnterBackground(_ application: UIApplication) {
        // アプリがバックグラウンドに入ったときに呼ばれる
        print("バックグラウンド")
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // アプリが終了する直前に呼ばれる
        print("アプリケーションの停止")
    }
}
