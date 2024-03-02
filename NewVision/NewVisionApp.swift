//
//  NewVisionApp.swift
//  NewVision
//
//  Created by Zahid Husain on 3/1/24.
//

import SwiftUI

@main
struct NewVisionApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }

        ImmersiveSpace(id: "ImmersiveSpace") {
            ImmersiveView()
        }
    }
}
