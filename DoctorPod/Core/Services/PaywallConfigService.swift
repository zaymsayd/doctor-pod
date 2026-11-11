//
//  PaywallConfigService.swift
//  DoctorPod
//
//  Created by Sayed Zaeem on 11/11/2026.
//

import Foundation
import FirebaseFirestore

struct PaywallConfig {
  let title: String
  let subtitle: String
  let features: [String]
  let billingNote: String
}

final class PaywallConfigService {
  
  private let db = Firestore.firestore()
  
  func fetchPaywallConfig() async throws -> PaywallConfig {
    let snapshot = try await db
      .collection("app_config")
      .document("paywall")
      .getDocument()
    
    guard let data = snapshot.data() else {
      throw NSError(
        domain: "PaywallConfigService",
        code: 404,
        userInfo: [
          NSLocalizedDescriptionKey: "Paywall configuration not found."
        ]
      )
    }
    
    return PaywallConfig(
      title: data["title"] as? String ?? "",
      subtitle: data["subtitle"] as? String ?? "",
      features: data["features"] as? [String] ?? [],
      billingNote: data["billingNote"] as? String ?? "",
    )
  }
}
