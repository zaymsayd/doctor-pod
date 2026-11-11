//
//  StoreKitManager.swift
//  DoctorPod
//
//  Created by Sayed Zaeem on 11/11/2026.
//

import Foundation
import StoreKit
import Combine

enum StoreVerificationError: Error {
    case failedVerification
}

@MainActor
final class StoreKitManager: ObservableObject {
  
  @Published var products: [Product] = []
  @Published var purchasedProductIDs: Set<String> = []
  @Published var isLoading = true
  @Published var errorMessage: String?
  
  
  private let productIDs = [
    "com.zaymsayd.doctorpod.premium.monthly"
  ]
  
  init() {
      Task {
          await updatePurchasedProducts()
          await loadProducts()
      }
  }
  
  func loadProducts() async {
    isLoading = true
    defer { isLoading = false }
    
    do {
      products = try await Product.products(for: productIDs)
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  func purchase(_ product: Product) async {
    do {
      let result = try await product.purchase()
      
      switch result {
      case .success(let verification):
        let transaction = try checkVerified(verification)
        
        await updatePurchasedProducts()
        await transaction.finish()
      
      case .userCancelled:
        break
      
      case .pending:
        errorMessage = "Your purchase is pending approval."
      @unknown default:
        break
      }
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  
  func restorePurchases() async {
    do {
      try await AppStore.sync()
      await updatePurchasedProducts()
      
    } catch {
      errorMessage = error.localizedDescription
    }
  }
  
  func updatePurchasedProducts() async {
    var purchasedIDs = Set<String>()
    
    for await result in Transaction.currentEntitlements {
      if case .verified(let transaction) = result {
        purchasedIDs.insert(transaction.productID)
      }
    }
    
    purchasedProductIDs = purchasedIDs
  }
  
  
  private func checkVerified<T>(
    _ result: VerificationResult<T>
  ) throws -> T {
    switch result {
    case .unverified:
      throw StoreVerificationError.failedVerification
      
    case .verified(let safe):
      return safe
    }
    

  }
  
  var isPremium: Bool {
      purchasedProductIDs.contains(
          "com.zaymsayd.doctorpod.premium.monthly"
      )
  }
}
