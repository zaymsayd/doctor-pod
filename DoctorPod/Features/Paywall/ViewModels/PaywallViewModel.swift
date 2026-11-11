
import Foundation
import Combine

@MainActor
final class PaywallViewModel: ObservableObject {

    @Published var config: PaywallConfig?
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let service = PaywallConfigService()

    func fetchConfig() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            config = try await service.fetchPaywallConfig()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
