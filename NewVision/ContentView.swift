//
//  ContentView.swift
//  NewVision
//
//  Created by Zahid Husain on 3/1/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

extension Color {
    static let customPurple = Color(red: 0.5, green: 0.0, blue: 0.5)
}

struct TitlePanelView: View {
    var body: some View {
        Text("The Crossroads")
            .font(.largeTitle)
            .padding()
            .frame(maxWidth: 700)
            //.background(Color.blue)
            //.background(Color.customPurple)
            //.shadow(radius: 10)
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

struct ImagePanelView: View {
    var imageName: String
    var width: CGFloat // Add a variable for width
    var height: CGFloat // Add a variable for height

    var body: some View {
        Image(imageName)
            .resizable()
            //.scaledToFit()
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

//struct ImagePanelView: View {
//    var imageName: String
//
//    var body: some View {
//        Image(imageName)
//            .resizable()
//            .aspectRatio(contentMode: .fit)
//            .frame(width: 800, height: 500)
//    }
//}

struct ImageGalleryView: View {
    var imageNames: [String]

    var body: some View {
        TabView {
            ForEach(imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 800, height: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 500)
    }
}

enum GalleryContent {
    case image(String)
    case text(String)
}

struct MixedContentGalleryView: View {
    var contents: [GalleryContent]

    var body: some View {
        TabView {
            ForEach(contents.indices, id: \.self) { index in
                switch contents[index] {
                case .image(let imageName):
                    Image(imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 800, height: 400)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                case .text(let text):
                    Text(text)
                        .font(.title)
                        .padding()
                        .frame(width: 800, height: 400)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(height: 500)
    }
}



struct InteractivePanelView: View {
    @State private var toggleStatus = false

    var body: some View {
        Toggle(isOn: $toggleStatus) {
            Text("Enable Feature")
        }
        .padding()
    }
}

struct AnimatedTextView: View {
    @State private var messages: [(String, String)] = []
    @State private var currentMessageIndex: Int = 0
    var conversation: [(String, String)] = [
        ("The Fates", "Hi Sharon!"),
        ("Sharon Tan", "Hi"),
        ("The Fates", "I heard you’re having a hard time making a big decision. What’s going on?"),
        ("Sharon Tan", "I don’t know whether to move back to Singapore or stay in the Bay. My family all live in Singapore, but the Bay has so many amazing opportunities. What should I do?"),
        ("The Fates", "You already know what is right for you, but I can help show you. Would you like to see?"),
        ("Sharon Tan", "Yes, please."),
    ]

    let typingInterval: TimeInterval = 3.0 // Interval before typing starts
    let sendBubbleColor = Color.black.opacity(0.7)   // Dark bubble for sent messages
    let receiveBubbleColor = Color.gray.opacity(0.9) // Light bubble for received messages

    var body: some View {
        VStack {
            ForEach(messages, id: \.1) { message in
                HStack {
                    if message.0 == "The Fates" {
                        messageBubble(text: message.1, bubbleColor: receiveBubbleColor, textColor: .white)
                            .frame(maxWidth: 400, alignment: .leading)
                        Spacer()
                    } else {
                        Spacer()
                        messageBubble(text: message.1, bubbleColor: sendBubbleColor, textColor: .white)
                            .frame(maxWidth: 400, alignment: .trailing)
                    }
                }
                .padding(.horizontal)
                .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .opacity))
            }
        }
        .onAppear {
            addMessages()
        }
    }
    
    @ViewBuilder
    private func messageBubble(text: String, bubbleColor: Color, textColor: Color) -> some View {
        Text(text)
            .padding(.horizontal)
            .padding(.vertical, 10)
            .background(bubbleColor)
            .foregroundColor(textColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
    }
    
    func addMessages() {
        for (index, message) in conversation.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + typingInterval * Double(index)) {
                withAnimation {
                    messages.append(message)
                }
            }
        }
    }
}



struct ContentView: View {
    @State private var sessionID: String?
    @State private var userID: String = "sharon"
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var rotationAngle: Angle = Angle(degrees: 0)
    @State private var responseText: String = "Loading..."

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView {
            VStack {
                
                TitlePanelView().padding()
                
                Divider().padding()
                
                AnimatedTextView()
                
                //ImagePanelView(imageName: "Sunset-Zahid")
                //ImageGalleryView(imageNames: ["Sunset-Zahid", "Sutro-Tower", "Waymo-burn"])
                
//                MixedContentGalleryView(contents: [
//                    .image("Sunset-Zahid"),
//                    .text("Pacifica Sunset in June."),
//                    .image("Sutro-Tower"),
//                    .text("A captivating story about Sutro Tower."),
//                    .image("Waymo-burn"),
//                    .text("Final thoughts on autonomous vehicles.")
//                ])

                //Divider().padding()
                
                //InteractivePanelView()
                
                Divider().padding()
                
//                Text(responseText)
//                    .onAppear {
//                        fetchData()
//                    }.padding()
                
            }
        }
    }
    
    func fetchData() {
        // Specify the URL of your endpoint
        guard let url = URL(string:"https://openai-hack-backend.onrender.com/conversation") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 100
        
        // Add sessionID and userID to the request headers if they exist
        if let sessionID = self.sessionID {
            request.addValue(sessionID, forHTTPHeaderField: "sessionID")
        }
        request.addValue(userID, forHTTPHeaderField: "userID")
        
        let body: [String: Any] = ["message": "Should I got to San Francisco or New York?"]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        
        // Perform the network request
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response as? HTTPURLResponse {
                // Check if the response contains a new sessionID and update it
                if let newSessionID = response.allHeaderFields["sessionID"] as? String, self.sessionID == nil {
                    DispatchQueue.main.async {
                        self.sessionID = newSessionID
                    }
                }
            }

            if let data = data {
                if let responseString = String(data: data, encoding: .utf8) {
                    // Update the UI with the response
                    DispatchQueue.main.async {
                        self.responseText = responseString
                    }
                }
            } else if let error = error {
                // Handle any errors
                DispatchQueue.main.async {
                    self.responseText = "Error fetching data: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
