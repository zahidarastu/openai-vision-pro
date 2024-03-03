//
//  GalleryView.swift
//  NewVision
//
//  Created by Zahid Husain on 3/3/24.
//

import Foundation
import SwiftUI
import RealityKit
import RealityKitContent


struct GalleryView: View {
    var body: some View {
        MixedContentGalleryView(contents: [
            .image("Sunset-Zahid"),
            .text("Pacifica Sunset in June."),
            .image("Sutro-Tower"),
            .text("A captivating story about Sutro Tower."),
            .image("Waymo-burn"),
            .text("Final thoughts on autonomous vehicles.")
        ])

    }
}

#Preview(windowStyle: .automatic) {
    GalleryView()
}
