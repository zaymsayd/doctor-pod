import SwiftUI
import FirebaseCore

@main
struct DoctorPodApp: App {
  
  init() {
    FirebaseApp.configure()
  }
  
    var body: some Scene {
        WindowGroup {
            OnboardingView()
        }
    }
}
