import Foundation
import SwiftUI
import RealityKit
import RealityKitContent

// Define a new struct for the first gallery
struct GalleryOneView: View {
    var body: some View {
        VStack {
            Text("Path One - San Francisco")
                .font(.title)
                .padding(.bottom, 10) // Adds some space between the title and the gallery
            MixedContentGalleryView(contents: [
//                .text("San Francisco"),
                .image("SF-1"),
                .image("SF-2"),
                .image("SF-3"),
                .image("SF-4"),
            ])
            Button("Continue Conversation with Future Self") {
                print("Gallery One: Explore More button tapped.")
            }
            .padding(.top, 10)
        }
    }
}

// Define a new struct for the second gallery
struct GalleryTwoView: View {
    var body: some View {
        VStack {
            Text("Path Two - Singapore")
                .font(.title)
                .padding(.bottom, 10) // Adds some space between the title and the gallery
            MixedContentGalleryView(contents: [
//                .text("Singapore"),
                .image("singapore-2"),
                .image("singapore-1"),
                .image("singapore-3"),
                .image("singapore-4"),
            ])
            Button("Continue Conversation with Future Self") {
                print("Gallery One: Explore More button tapped.")
            }
            .padding(.top, 10)
        }
    }
}

// Adjust the original GalleryView to include both galleries in separate panes
struct GalleryView: View {
    var body: some View {
        HStack {
            GalleryOneView()
                .frame(maxWidth: .infinity)
                .padding()
            GalleryTwoView()
                .frame(maxWidth: .infinity)
                .padding()
        }
    }
}

#Preview(windowStyle: .automatic) {
    GalleryView().previewLayout(.sizeThatFits)
}
