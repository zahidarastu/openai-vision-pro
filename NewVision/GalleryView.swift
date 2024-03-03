import Foundation
import SwiftUI
import RealityKit
import RealityKitContent


// Define a new struct for the first gallery
struct GalleryOneView: View {
    var audioPlayer = AudioPlayerUtil()
    let fileName = "sharon_path1"
    var body: some View {
        VStack {
            HStack{
                Text("Path One - San Francisco")
                    .font(.title)
                Button(action: {
                                audioPlayer.playSound(soundName: fileName, soundType: "mp3")
                            }) {
                                Image(systemName: "speaker.3")
                            }
                }.padding(.bottom, 10) // Adds some space between the title and the gallery
            
            MixedContentGalleryView(contents: [
//                .text("San Francisco"),
                .image("SF-1"),
                .image("SF-2"),
                .image("SF-3"),
                .image("SF-4"),
                .image("SF-5"),
                .image("SF-8"),
                .image("SF-9"),
                .image("SF-10"),
                .image("SF-11"),
                .image("SF-12"),
                .image("SF-6"),
                .image("SF-13")
            ])
            Button(action: {
                            print("Gallery One: Explore More button tapped.")
                        }) {
                            Text("Continue Conversation with Future Self")
                        }
                        .padding(.top, 10)
            }
        }
    }

// Define a new struct for the second gallery
struct GalleryTwoView: View {
    var audioPlayer = AudioPlayerUtil()
    let fileName = "sharon_path2"
    var body: some View {
        VStack{
            HStack {
                Text("Path Two - Singapore")
                .font(.title)
            Button(action: {
                            audioPlayer.playSound(soundName: fileName, soundType: "mp3")
                        }) {
                            Image(systemName: "speaker.3")
                        }
            }.padding(.bottom, 10) // Adds some space between the title and the gallery
            MixedContentGalleryView(contents: [
//                .text("Singapore"),
                .image("singapore-2"),
                .image("singapore-1"),
                .image("singapore-3"),
                .image("singapore-4"),
                .image("singapore-5"),
                .image("singapore-6"),
                .image("singapore-7"),
                .image("singapore-9"),
                .image("singapore-10"),
                .image("singapore-11"),
            ])
            Button(action: {
                            audioPlayer.playSound(soundName: fileName, soundType: "mp3")
                            print("Gallery One: Explore More button tapped.")
                        }) {
                            Text("Continue Conversation with Future Self")
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
