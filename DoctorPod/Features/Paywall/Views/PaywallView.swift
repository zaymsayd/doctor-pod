import SwiftUI
import StoreKit

struct PaywallView: View {
  
  @StateObject private var viewModel = PaywallViewModel()
  
  @StateObject private var storeKitManager = StoreKitManager()
  
    var body: some View {
      VStack(spacing: 24) {
        Spacer()
        
        Image(systemName: "headphones.circle.fill")
          .font(.system(size: 75))
          .foregroundStyle(AppColors.primary)
        
        Text(viewModel.config?.title ?? "Loading...")
          .font(.largeTitle.bold())
          .multilineTextAlignment(.center)
          .fixedSize(horizontal: false, vertical: true)
        
        Text(viewModel.config?.subtitle ?? "")
          .foregroundStyle(.secondary)
          .multilineTextAlignment(.center)
        
        VStack(alignment: .leading, spacing: 16) {
          ForEach(
              viewModel.config?.features ?? [],
              id: \.self
          ) { feature in
              Label(feature, systemImage: "checkmark.circle.fill")
          }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        Spacer()
        
        if storeKitManager.isLoading {
          ProgressView("Loading plans...")
        } else if storeKitManager.products.isEmpty {
          Text("No subscription products available.")       .foregroundStyle(.secondary)
          
          Button("Try Again") {
            Task {
              await storeKitManager.loadProducts()
            }
          }
        } else {
          if storeKitManager.isPremium {
              VStack(spacing: 12) {
                  Label("Premium is active", systemImage: "checkmark.circle.fill")
                      .font(.headline)
                      .foregroundStyle(.green)

                  Text("You already have access to all Premium features.")
                      .foregroundStyle(.secondary)
                      .multilineTextAlignment(.center)
              }
          } else {
              ForEach(storeKitManager.products, id: \.id) { product in
                  VStack(spacing: 8) {
                      Text(product.displayName)
                          .font(.headline)

                      Text(product.displayPrice)
                          .font(.title2.bold())

                      Button {
                          Task {
                              await storeKitManager.purchase(product)
                          }
                      } label: {
                          Text("Subscribe")
                              .font(.headline)
                              .foregroundStyle(.white)
                              .frame(maxWidth: .infinity)
                              .padding()
                              .background(AppColors.primary)
                              .clipShape(RoundedRectangle(cornerRadius: 14))
                      }
                  }
              }
          }
        }
        
        if let billingNote = viewModel.config?.billingNote {
            Text(billingNote)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        
        
        if !storeKitManager.isPremium {
            Button("Restore Purchases") {
                Task {
                    await storeKitManager.restorePurchases()
                }
            }
            .font(.subheadline)
        }

        if let error = storeKitManager.errorMessage {
            Text(error)
                .font(.caption)
                .foregroundStyle(.red)
                .multilineTextAlignment(.center)
        }
    }
    .padding(24)
    .navigationTitle("Premium")
    .navigationBarTitleDisplayMode(.inline)
    .task {
        await viewModel.fetchConfig()
    }
    }
}

#Preview {
    PaywallView()
}
