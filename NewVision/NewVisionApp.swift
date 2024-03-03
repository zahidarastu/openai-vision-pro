//
//  NewVisionApp.swift
//  NewVision
//
//  Created by Zahid Husain on 3/1/24.
//

import SwiftUI


@main
struct NewVisionApp: App {
    // State to control the current view
    @State private var isSessionStarted = false

    var body: some Scene {
        WindowGroup {
            if isSessionStarted {
                ContentView()
            } else {
                StartSessionView(isSessionStarted: $isSessionStarted)
            }
        }.windowStyle(.automatic)

        //        ImmersiveSpace(id: "ImmersiveSpace") {
        //            ImmersiveView()
        //        }
    }
}
