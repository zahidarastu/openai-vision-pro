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
        Text("Welcome to the Crossroads!")
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

    var body: some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 800, height: 500)
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
                
                //ImagePanelView(imageName: "Sunset-Zahid")
                //ImageGalleryView(imageNames: ["Sunset-Zahid", "Sutro-Tower", "Waymo-burn"])
                MixedContentGalleryView(contents: [
                    .image("Sunset-Zahid"),
                    .text("Here's some insightful text about the first image."),
                    .image("Sutro-Tower"),
                    .text("A captivating story about Sutro Tower."),
                    .image("Waymo-burn"),
                    .text("Final thoughts on autonomous vehicles.")
                ])

                //Divider().padding()
                
                InteractivePanelView()
                
                Divider().padding()
                
                Text(responseText)
                    .onAppear {
                        fetchData()
                    }.padding()
                
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
        
        // Add sessionID and userID to the request headers if they exist
        if let sessionID = self.sessionID {
            request.addValue(sessionID, forHTTPHeaderField: "sessionID")
        }
        request.addValue(userID, forHTTPHeaderField: "userID")
        
        let body: [String: Any] = ["message": "whats up"]
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
