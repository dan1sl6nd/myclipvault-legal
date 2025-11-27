//
//  HardPaywallView.swift
//  MyClipVault
//
//  Created by Claude Code
//

import SwiftUI
import StoreKit

struct HardPaywallView: View {
    @StateObject private var storeManager = StoreKitManager.shared
    @Binding var isOnboardingComplete: Bool

    @State private var selectedProduct: Product?
    @State private var showCards = false
    @State private var isPurchasing = false
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var showRestoreSuccess = false

    var body: some View {
        ZStack {
            // Premium dark background
            Color.black.ignoresSafeArea()

                // Animated gradient orbs
                ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.yellow.opacity(0.4), Color.orange.opacity(0.3), Color.clear],
                            center: .topLeading,
                            startRadius: 0,
                            endRadius: 400
                        )
                    )
                    .frame(width: 600, height: 600)
                    .offset(x: -100, y: -150)
                    .blur(radius: 80)

                Circle()
                    .fill(
                        RadialGradient(
                            colors: [Color.purple.opacity(0.4), Color.pink.opacity(0.3), Color.clear],
                            center: .bottomTrailing,
                            startRadius: 0,
                            endRadius: 400
                        )
                    )
                    .frame(width: 600, height: 600)
                    .offset(x: 100, y: 200)
                    .blur(radius: 80)
            }
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    // Header Section
                    VStack(spacing: 20) {
                        // Premium Crown Icon
                        ZStack {
                            // Glow effect
                            Circle()
                                .fill(
                                    RadialGradient(
                                        colors: [Color.yellow.opacity(0.3), Color.clear],
                                        center: .center,
                                        startRadius: 0,
                                        endRadius: 60
                                    )
                                )
                                .frame(width: 120, height: 120)

                            // Crown
                            Image(systemName: "crown.fill")
                                .font(.system(size: 55, weight: .bold))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [Color.yellow, Color.orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .shadow(color: .yellow.opacity(0.5), radius: 20)
                        }
                        .scaleEffect(showCards ? 1 : 0.5)
                        .opacity(showCards ? 1 : 0)

                        VStack(spacing: 8) {
                            Text("Unlock")
                                .font(.system(size: 32, weight: .black))
                                .foregroundColor(.white)
                                .minimumScaleFactor(0.7)

                            Text("MyClipVault Pro")
                                .font(.system(size: 34, weight: .black))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .minimumScaleFactor(0.5)
                                .lineLimit(1)
                        }
                        .opacity(showCards ? 1 : 0)

                        Text("Choose your plan")
                            .font(.system(size: 13, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(1.2)
                            .opacity(showCards ? 1 : 0)
                    }
                    .padding(.top, 50)
                    .padding(.bottom, 30)

                    // Subscription Plans
                    VStack(spacing: 12) {
                        if storeManager.isLoading && storeManager.subscriptions.isEmpty {
                            // Loading state
                            ProgressView()
                                .scaleEffect(1.5)
                                .tint(.white)
                                .padding(60)
                        } else if storeManager.subscriptions.isEmpty {
                            // Error state
                            VStack(spacing: 16) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 40))
                                    .foregroundColor(.orange)

                                Text("Unable to load plans")
                                    .font(.headline)
                                    .foregroundColor(.white)

                                Text("Please check your connection and try again")
                                    .font(.subheadline)
                                    .foregroundColor(.white.opacity(0.7))
                                    .multilineTextAlignment(.center)

                                Button(action: {
                                    Task {
                                        await storeManager.loadProducts()
                                    }
                                }) {
                                    Text("Retry")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 40)
                                        .padding(.vertical, 12)
                                        .background(
                                            LinearGradient(
                                                colors: [.orange, .red],
                                                startPoint: .leading,
                                                endPoint: .trailing
                                            )
                                        )
                                        .cornerRadius(12)
                                }
                            }
                            .padding(40)
                        } else {
                            // Display subscription options
                            ForEach(Array(storeManager.subscriptions.enumerated()), id: \.element.id) { index, product in
                                SubscriptionPlanCard(
                                    product: product,
                                    isSelected: selectedProduct?.id == product.id,
                                    hasFreeTrial: product.id == "weekly",
                                    onSelect: {
                                        let impact = UIImpactFeedbackGenerator(style: .medium)
                                        impact.impactOccurred()
                                        selectedProduct = product
                                    }
                                )
                                .opacity(showCards ? 1 : 0)
                                .offset(y: showCards ? 0 : 30)
                                .animation(.spring(response: 0.7, dampingFraction: 0.75).delay(Double(index) * 0.1), value: showCards)
                            }
                        }
                    }

                    // Pro Features List
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Everything Included:")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.white.opacity(0.6))
                            .textCase(.uppercase)
                            .tracking(1.0)
                            .padding(.top, 28)
                            .padding(.bottom, 8)

                        VStack(spacing: 10) {
                            ProFeatureRow(icon: "infinity", title: "Unlimited History")
                            ProFeatureRow(icon: "magnifyingglass", title: "Smart Search")
                            ProFeatureRow(icon: "sparkles", title: "Auto Detection")
                            ProFeatureRow(icon: "folder.fill", title: "Smart Folders")
                            ProFeatureRow(icon: "bolt.fill", title: "Quick Actions")
                            ProFeatureRow(icon: "shield.fill", title: "Private & Secure")
                        }
                    }
                    .padding(.leading, 8)
                    .opacity(showCards ? 1 : 0)

                    Spacer(minLength: 180)
                }
                .padding(.horizontal, 24)
            }
            .contentMargins(.horizontal, 0, for: .scrollContent)

            // Bottom Action Section
            VStack {
                Spacer()

                VStack(spacing: 14) {
                    // Continue Button
                    Button(action: {
                        handlePurchase()
                    }) {
                        HStack(spacing: 10) {
                            if isPurchasing {
                                ProgressView()
                                    .tint(.white)
                            } else {
                                Image(systemName: "crown.fill")
                                    .font(.system(size: 16, weight: .bold))

                                Text(getButtonTitle())
                                    .font(.system(size: 17, weight: .bold))
                            }
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            Group {
                                if selectedProduct != nil && !isPurchasing {
                                    LinearGradient(
                                        colors: [Color.yellow, Color.orange],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                } else {
                                    LinearGradient(
                                        colors: [Color.gray.opacity(0.5), Color.gray.opacity(0.5)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                }
                            }
                        )
                        .cornerRadius(14)
                        .shadow(color: selectedProduct != nil ? Color.yellow.opacity(0.4) : Color.clear, radius: 15, y: 8)
                    }
                    .disabled(selectedProduct == nil || isPurchasing)
                    .padding(.horizontal, 20)

                    // Restore Purchases
                    Button(action: {
                        handleRestore()
                    }) {
                        Text("Restore Purchases")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    .disabled(isPurchasing)

                    // Legal Text
                    VStack(spacing: 6) {
                        Text("Auto-renewable. Cancel anytime.")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.5))

                        HStack(spacing: 12) {
                            Link("Terms of Service", destination: URL(string: "https://dan1sland.github.io/ClipVault/terms.html")!)
                            Text("•")
                            Link("Privacy Policy", destination: URL(string: "https://dan1sland.github.io/ClipVault/privacy.html")!)
                        }
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.4))
                    }
                    .padding(.bottom, 10)
                }
                .padding(.top, 20)
                .background(
                    LinearGradient(
                        colors: [Color.clear, Color.black.opacity(0.8), Color.black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .ignoresSafeArea()
                )
            }
        }
        .alert("Error", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(errorMessage)
        }
        .alert("Success", isPresented: $showRestoreSuccess) {
            Button("OK", role: .cancel) {
                isOnboardingComplete = true
                UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
            }
        } message: {
            Text("Your purchases have been restored!")
        }
        .onAppear {
            // Auto-select weekly by default
            if storeManager.subscriptions.isEmpty {
                Task {
                    await storeManager.loadProducts()
                    // Select weekly by default after loading
                    selectedProduct = storeManager.subscriptions.first(where: { $0.id == "weekly" })
                }
            } else {
                selectedProduct = storeManager.subscriptions.first(where: { $0.id == "weekly" })
            }

            withAnimation {
                showCards = true
            }
        }
    }

    private func getButtonTitle() -> String {
        guard let product = selectedProduct else {
            return "Select a Plan"
        }

        if product.id == "weekly" {
            return "Start 3-Day Free Trial"
        } else {
            return "Subscribe Now"
        }
    }

    private func handlePurchase() {
        guard let product = selectedProduct else { return }

        isPurchasing = true

        Task {
            let success = await storeManager.purchase(product)

            await MainActor.run {
                isPurchasing = false

                if success {
                    // Purchase successful, complete onboarding
                    isOnboardingComplete = true
                    UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
                } else {
                    // Show error if there is one
                    if let error = storeManager.errorMessage {
                        errorMessage = error
                        showError = true
                    }
                }
            }
        }
    }

    private func handleRestore() {
        isPurchasing = true

        Task {
            let success = await storeManager.restorePurchases()

            await MainActor.run {
                isPurchasing = false

                if success {
                    // Restore successful
                    showRestoreSuccess = true
                } else {
                    // Show error
                    if let error = storeManager.errorMessage {
                        errorMessage = error
                    } else {
                        errorMessage = "No active subscriptions found"
                    }
                    showError = true
                }
            }
        }
    }
}

// MARK: - Subscription Plan Card

struct SubscriptionPlanCard: View {
    let product: Product
    let isSelected: Bool
    let hasFreeTrial: Bool
    let onSelect: () -> Void

    var body: some View {
        Button(action: onSelect) {
            VStack(spacing: 0) {
                // Badge for free trial or best value
                if hasFreeTrial {
                    HStack {
                        Spacer()
                        Text("3-DAY FREE TRIAL")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                LinearGradient(
                                    colors: [Color.green, Color.cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(6)
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                } else {
                    HStack {
                        Spacer()
                        Text("BEST VALUE")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                LinearGradient(
                                    colors: [Color.purple, Color.pink],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(6)
                        Spacer()
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 6)
                }

                // Plan details
                VStack(spacing: 8) {
                    // Plan name
                    Text(planName)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)

                    // Price
                    HStack(alignment: .firstTextBaseline, spacing: 3) {
                        Text(product.displayPrice)
                            .font(.system(size: 32, weight: .black))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [.yellow, .orange],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)

                        Text(pricePeriod)
                            .font(.system(size: 14, weight: .medium))
                            .foregroundColor(.white.opacity(0.7))
                    }

                    // Additional info
                    if hasFreeTrial {
                        Text("Then \(product.displayPrice)/week")
                            .font(.system(size: 12, weight: .medium))
                            .foregroundColor(.white.opacity(0.6))
                    } else {
                        if let weeklyEquivalent = calculateWeeklyPrice() {
                            Text("Just \(weeklyEquivalent)/week")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                }
                .padding(.vertical, 14)

                // Selection indicator
                HStack(spacing: 6) {
                    Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? .yellow : .white.opacity(0.3))

                    Text(isSelected ? "Selected" : "Tap to select")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(isSelected ? .yellow : .white.opacity(0.5))
                }
                .padding(.bottom, 14)
            }
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        isSelected ?
                            LinearGradient(
                                colors: [Color.yellow.opacity(0.15), Color.orange.opacity(0.15)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ) :
                            LinearGradient(
                                colors: [Color.white.opacity(0.05), Color.white.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(
                                isSelected ?
                                    LinearGradient(
                                        colors: [.yellow, .orange],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ) :
                                    LinearGradient(
                                        colors: [Color.white.opacity(0.2), Color.white.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                lineWidth: isSelected ? 2 : 1
                            )
                    )
            )
            .shadow(color: isSelected ? Color.yellow.opacity(0.3) : Color.clear, radius: 15, y: 8)
            .scaleEffect(isSelected ? 1.01 : 1.0)
        }
        .buttonStyle(.plain)
    }

    private var planName: String {
        switch product.id {
        case "weekly":
            return "Weekly"
        case "yearly":
            return "Annual"
        default:
            return "Unknown"
        }
    }

    private var pricePeriod: String {
        switch product.id {
        case "weekly":
            return "/week"
        case "yearly":
            return "/year"
        default:
            return ""
        }
    }

    private func calculateWeeklyPrice() -> String? {
        guard product.id == "yearly" else { return nil }

        let yearlyPrice = product.price
        let weeklyPrice = yearlyPrice / 52

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceFormatStyle.locale

        return formatter.string(from: weeklyPrice as NSDecimalNumber)
    }
}

// MARK: - Pro Feature Row

struct ProFeatureRow: View {
    let icon: String
    let title: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 16))
                .foregroundColor(.green)

            Text(title)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.9))
                .lineLimit(1)
                .minimumScaleFactor(0.85)

            Spacer()
        }
    }
}
