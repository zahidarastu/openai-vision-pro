import SwiftUI

struct StartSessionView: View {
    @Binding var isSessionStarted: Bool

    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack {
                    Spacer(minLength: geometry.size.height * 0.1) // Adjust the spacing at the top
                    
                    TitlePanelView()
                        .padding(.bottom, 20) // Space between the title and the image
                    
                    ImagePanelView(imageName: "crossroads", width: geometry.size.width * 0.85, height: geometry.size.height * 0.5) // Adjust the size relative to the screen size
                    
                    // Subtitle and Description
                    VStack(spacing: 10) {
                        Text("Let’s peer into the future")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.vertical, 10)

                        Text("Every choice leads to two parallel universes - we show you both.")
                            .font(.body)
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20) // Space between the description and the button
                    
                    // Begin Session Button
                    Button(action: {
                        self.isSessionStarted = true
                    }) {
                        Text("Begin Session")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(width: 280, height: 50)
                            .cornerRadius(25)
                    }
                    
                    Spacer(minLength: geometry.size.height * 0.1) // Adjust the spacing at the bottom
                }
                .frame(width: geometry.size.width) // The width of the VStack should match the width of the screen
                .padding(.bottom, geometry.safeAreaInsets.bottom) // Add padding at the bottom equal to the safe area insets
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

#Preview(windowStyle: .automatic) {
    StartSessionView(isSessionStarted: .constant(false))
}
