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
            .aspectRatio(contentMode: .fit)
            .frame(width: width, height: height)
    }
}

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

struct AnimatedConversationView: View {
    @Binding var animationCompleted: Bool
    @Binding var sessionID: String?
    @State private var messages: [(String, String)] = [("The Fates", "Hi! What's on your mind?")]
    @State private var userInput: String = ""
    let sendBubbleColor = Color.black.opacity(0.7)   // Dark bubble for sent messages
    let receiveBubbleColor = Color.gray.opacity(0.9) // Light bubble for received messages

    
    var body: some View {
         VStack {
             // Message list in a scroll view
             ScrollView {
                 VStack {
                     ForEach(messages, id: \.1) { message in
                         HStack {
                             if message.0 == "The Fates" {
                                 messageBubble(text: message.1, bubbleColor: receiveBubbleColor, textColor: .white)
                                     .frame(maxWidth: 300, alignment: .leading)
                                 Spacer()
                             } else {
                                 Spacer()
                                 messageBubble(text: message.1, bubbleColor: sendBubbleColor, textColor: .white)
                                     .frame(maxWidth: 300, alignment: .trailing)
                             }
                         }
                         .padding(.horizontal)
                         .transition(.asymmetric(insertion: .scale, removal: .opacity))
                     }
                 }
                 .padding(.bottom, 50) // Add padding to the bottom to make room for the input field
             }

             // Input field pinned at the bottom
             HStack {
                 TextField("Your response...", text: $userInput, onCommit: {
                     DispatchQueue.main.async {
                     // Trim the userInput to remove leading and trailing white spaces
                     let trimmedInput = self.userInput.trimmingCharacters(in: .whitespacesAndNewlines)
 
                     // Check if the trimmed input is not empty
                     if !trimmedInput.isEmpty {
                         addMessage(from: "User", content: trimmedInput)
                         fetchData(message: trimmedInput)
                         self.userInput = "" // Clear the input field after submission
                     }
                     else {
                         self.userInput = ""
                     }
                 }
                 })
                 .foregroundColor(.white) // This changes the text color inside the TextField
                 .textFieldStyle(RoundedBorderTextFieldStyle())
                 .frame(width: 200, alignment: .trailing)
                 .padding()
             }
             .background(Color(UIColor.systemBackground)) // Match the color with the system background
             .edgesIgnoringSafeArea(.bottom) // Ignore safe area to extend the background
         }
     }

    struct ResponseItem: Decodable {
        let id: String
        let sessionID: String
        let role: String
        let contentType: String
        let content: String
    }

    // Since your JSON is an array, you can decode it directly into an array of ResponseItem
    typealias ResponseArray = [ResponseItem]
    
    private func fetchData(message: String) {
        guard let url = URL(string: "https://openai-hack-backend.onrender.com/conversation") else {
            print("Invalid URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = 100
        
        if let sessionID = sessionID {
            request.addValue(sessionID, forHTTPHeaderField: "sessionID")
        }

        let body: [String: Any] = ["message": message]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data {
                let decoder = JSONDecoder()
                // Convert from snake_case to camelCase
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                do {
                    // Decode the JSON data into an array of ResponseItem
                    let decodedResponse = try decoder.decode(ResponseArray.self, from: data)
                    // Here we assume you want the content of the first item in the array
                    let content = decodedResponse.first?.content ?? "No content"
                    DispatchQueue.main.async {
                        // Append the user's message and the parsed content to the messages array
                        //self.sessionID = decodedResponse.first?.sessionID
                        self.messages.append(("The Fates", content))
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.messages.append(("Error", "Failed to parse data: \(error.localizedDescription)"))
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.messages.append(("Error", "Failed to fetch data: \(error.localizedDescription)"))
                }
            }

        }.resume()
    }


    @ViewBuilder
    private func messageBubble(text: String, bubbleColor: Color, textColor: Color) -> some View {
        Text(text)
            .padding()
            .background(bubbleColor)
            .foregroundColor(textColor)
            .cornerRadius(15)
            .overlay(
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.gray, lineWidth: 0.5)
            )
    }

    private func addMessage(from sender: String, content: String) {
        withAnimation {
            messages.append((sender, content))
        }
    }
}


struct ContentView: View {
    @State private var sessionID: String?
    //@State private var userID: String = "sharon"
    @State private var showImmersiveSpace = false
    @State private var immersiveSpaceIsShown = false
    @State private var rotationAngle: Angle = Angle(degrees: 0)
    @State private var responseText: String = "Loading..."
    @State private var showGalleryView = false
    @State private var animationCompleted = false

    @Environment(\.openImmersiveSpace) var openImmersiveSpace
    @Environment(\.dismissImmersiveSpace) var dismissImmersiveSpace

    let timer = Timer.publish(every: 1/60, on: .main, in: .common).autoconnect()

    var body: some View {
            VStack {
                
                TitlePanelView().padding()
                
                Divider().padding()
                
//                AnimatedTextView(animationCompleted: $animationCompleted)
                AnimatedConversationView(animationCompleted: $animationCompleted, sessionID: $sessionID)
            
                //ImageGalleryView(imageNames: ["Sunset-Zahid", "Sutro-Tower", "Waymo-burn"])
                
                //Divider().padding()
                
                //InteractivePanelView()
                
                Divider().padding()
                
                //Text(responseText)
                //    .onAppear {
                //        fetchData()
                //    }.padding()
                
                if animationCompleted {
                    Button("Continue") {
                        showGalleryView = true
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(width: 280, height: 50)
                    .cornerRadius(25)
                    
                    .fullScreenCover(isPresented: $showGalleryView) {
                        GalleryView()
                    }
                }
        }
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
