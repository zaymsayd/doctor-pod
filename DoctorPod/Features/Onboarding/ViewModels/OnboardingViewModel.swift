import Foundation
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
  @Published var shouldContinue = false
  
  func continueTapped() {
    shouldContinue = true
  }
}
