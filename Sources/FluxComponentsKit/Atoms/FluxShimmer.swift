import SwiftUI
import FluxTokensKit

// MARK: - Shape

public extension FluxShimmer {

    /// Predefined placeholder shapes for building skeleton screens.
    ///
    /// Each case maps to a SwiftUI shape with sensible defaults:
    /// - `.line`      — thin rounded rectangle, ideal for text placeholders
    /// - `.circle`    — circular placeholder (avatars, icons)
    /// - `.rectangle` — generic rounded rectangle (images, cards, banners)
    enum Shape {
        /// A thin rounded-rectangle line (text placeholder).
        case line(width: CGFloat = 120, height: CGFloat = 12)
        /// A circular placeholder (avatar, icon).
        case circle(diameter: CGFloat = 40)
        /// A generic rounded rectangle (image, card, banner).
        case rectangle(width: CGFloat = .infinity, height: CGFloat = 80, radius: CGFloat = FluxRadius.md)
    }
}

// MARK: - ViewModel

/// Holds the configuration state for a single `FluxShimmer` placeholder.
@MainActor
public class FluxShimmerViewModel: ObservableObject {

    /// The geometric shape of the placeholder.
    @Published public var shape: FluxShimmer.Shape

    /// Whether the gradient sweep animation is running.
    @Published public var isAnimating: Bool

    public init(
        shape: FluxShimmer.Shape = .line(),
        isAnimating: Bool = true
    ) {
        self.shape = shape
        self.isAnimating = isAnimating
    }
}

// MARK: - View

/// A standalone shimmer placeholder atom for building skeleton screens.
///
/// Renders a single animated placeholder shape. For applying shimmer over
/// existing components, use the `.fluxShimmer()` view modifier instead.
///
/// ```swift
/// // Individual shapes
/// FluxShimmer(shape: .circle(diameter: 48))
/// FluxShimmer(shape: .line(width: 200, height: 14))
///
/// // Composite helpers
/// FluxShimmer.textBlock(lines: 3)
/// FluxShimmer.card()
/// ```
public struct FluxShimmer: View {

    @ObservedObject public var viewModel: FluxShimmerViewModel

    /// VM-based initializer for dynamic state management.
    public init(viewModel: FluxShimmerViewModel) {
        self.viewModel = viewModel
    }

    /// Convenience initializer for inline usage without a separate ViewModel.
    public init(shape: Shape = .line(), isAnimating: Bool = true) {
        self.viewModel = FluxShimmerViewModel(shape: shape, isAnimating: isAnimating)
    }

    /// Drives the horizontal offset of the gradient highlight (–1 → 1).
    @State private var phase: CGFloat = -1

    public var body: some View {
        shapeView
            .onAppear {
                guard viewModel.isAnimating else { return }
                withAnimation(
                    .linear(duration: 1.5)
                    .repeatForever(autoreverses: false)
                ) {
                    phase = 1
                }
            }
            .accessibilityLabel("Loading placeholder")
            .accessibilityHidden(true)
    }

    // MARK: - Private Helpers

    /// Animated gradient that sweeps across the placeholder shape.
    private var gradientOverlay: some View {
        LinearGradient(
            colors: [
                .clear,
                FluxColors.surface.opacity(0.6),
                .clear
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .offset(x: viewModel.isAnimating ? phase * 200 : 0)
    }

    /// Renders the correct SwiftUI shape, base fill, gradient overlay, and clip
    /// for each `Shape` case. Clipping is applied inline per case to avoid
    /// `some Shape` type-erasure issues with `@ViewBuilder`.
    @ViewBuilder
    private var shapeView: some View {
        switch viewModel.shape {
        case .line(let width, let height):
            RoundedRectangle(cornerRadius: FluxRadius.xs)
                .fill(FluxColors.border.opacity(0.3))
                .frame(width: width == .infinity ? nil : width, height: height)
                .frame(maxWidth: width == .infinity ? .infinity : nil)
                .overlay(gradientOverlay)
                .clipShape(RoundedRectangle(cornerRadius: FluxRadius.xs))

        case .circle(let diameter):
            Circle()
                .fill(FluxColors.border.opacity(0.3))
                .frame(width: diameter, height: diameter)
                .overlay(gradientOverlay)
                .clipShape(Circle())

        case .rectangle(let width, let height, let radius):
            RoundedRectangle(cornerRadius: radius)
                .fill(FluxColors.border.opacity(0.3))
                .frame(width: width == .infinity ? nil : width, height: height)
                .frame(maxWidth: width == .infinity ? .infinity : nil)
                .overlay(gradientOverlay)
                .clipShape(RoundedRectangle(cornerRadius: radius))
        }
    }
}

// MARK: - Skeleton Helpers

public extension FluxShimmer {

    /// Creates a multi-line text placeholder block.
    ///
    /// The last line is shorter (80 pt) to mimic a paragraph's trailing line.
    ///
    /// - Parameters:
    ///   - lines: Number of placeholder lines. Defaults to `3`.
    ///   - spacing: Vertical spacing between lines. Defaults to `FluxSpacing.xs`.
    static func textBlock(lines: Int = 3, spacing: CGFloat = FluxSpacing.xs) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            ForEach(0..<lines, id: \.self) { index in
                let isLast = index == lines - 1
                FluxShimmer(shape: .line(
                    width: isLast ? 80 : .infinity,
                    height: 12
                ))
            }
        }
    }

    /// Creates a card-shaped skeleton placeholder with avatar, title lines,
    /// an image rectangle, and a two-line text block.
    static func card() -> some View {
        VStack(alignment: .leading, spacing: FluxSpacing.sm) {
            // Avatar row
            HStack(spacing: FluxSpacing.sm) {
                FluxShimmer(shape: .circle(diameter: 40))
                VStack(alignment: .leading, spacing: FluxSpacing.xxs) {
                    FluxShimmer(shape: .line(width: 120, height: 14))
                    FluxShimmer(shape: .line(width: 80, height: 10))
                }
            }
            // Image placeholder
            FluxShimmer(shape: .rectangle(width: .infinity, height: 120, radius: FluxRadius.sm))
            // Body text placeholder
            FluxShimmer.textBlock(lines: 2)
        }
        .padding(FluxSpacing.md)
        .background(FluxColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FluxRadius.lg))
        .fluxShadow(.small)
    }
}
