import SwiftUI

struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()

    var body: some View {
      NavigationStack {
        ZStack {
          ZStack {
            Color(.systemBackground)
              .ignoresSafeArea()
            
            VStack(spacing: 0) {
              Spacer()
              
              ZStack {
                RoundedRectangle(cornerRadius: 32)
                  .fill(AppColors.primary.opacity(0.08))
                  .frame(width: 280, height: 280)
                
                VStack(spacing: 20) {
                  Image(systemName: "doc.text.fill")
                    .font(.system(size: 75))
                    .foregroundStyle(AppColors.primary)
                  
                  HStack(spacing: 16) {
                    Image(systemName: "waveform")
                      .font(.system(size: 36))
                    
                    Image(systemName: "headphones")
                      .font(.system(size: 36))
                    
                    Image(systemName: "sparkles")
                      .font(.system(size: 36))
                  }
                  .foregroundStyle(AppColors.primary)
                }
              }
              
              Spacer()
                .frame(height: 48)
              
              
              Text("Your documents,\nnow in audio.")
                .font(.system(size: 34, weight: .bold))
                .multilineTextAlignment(.center)
              
              Text("Turn lengthy documents into intelligent audio briefings. Listen, learn and understand more while doing less."
              )
              .font(.system(size: 16))
              
              .foregroundStyle(AppColors.secondaryText)
              .multilineTextAlignment(.center)
              .lineSpacing(5)
              .padding(.horizontal, 24)
              .padding(.top, 16)
              
              Spacer()
              
              Button {
                viewModel.continueTapped()
              } label: {
                HStack {
                  Text("Get Started")
                  Image(systemName: "arrow.right")
                }
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(AppColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: 16))
              }
              .padding(.horizontal, 24)
              .padding(.bottom, 16)
            }
            .padding(.top, 30)
          }.navigationDestination(
            isPresented: $viewModel.shouldContinue
          ) {
            PaywallView()
          }
      }

      }
    }
}

#Preview {
    OnboardingView()
}
