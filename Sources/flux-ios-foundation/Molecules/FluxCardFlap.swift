import SwiftUI
import flux_ios_ds

// MARK: - ViewModel

@MainActor
public class FluxCardFlapViewModel: ObservableObject {
    @Published public var isFlipped: Bool
    @Published public var padding: CGFloat
    @Published public var cornerRadius: CGFloat
    @Published public var shadow: FluxShadow
    @Published public var flipDuration: Double
    public var onFlip: ((Bool) -> Void)?

    public init(
        isFlipped: Bool = false,
        padding: CGFloat = FluxSpacing.md,
        cornerRadius: CGFloat = FluxRadius.md,
        shadow: FluxShadow = .small,
        flipDuration: Double = 0.6,
        onFlip: ((Bool) -> Void)? = nil
    ) {
        self.isFlipped = isFlipped
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.flipDuration = flipDuration
        self.onFlip = onFlip
    }
}

// MARK: - View

public struct FluxCardFlap<Front: View, Back: View>: View {

    @ObservedObject public var viewModel: FluxCardFlapViewModel
    private let front: Front
    private let back: Back

    public init(
        viewModel: FluxCardFlapViewModel,
        @ViewBuilder front: () -> Front,
        @ViewBuilder back: () -> Back
    ) {
        self.viewModel = viewModel
        self.front = front()
        self.back = back()
    }

    public var body: some View {
        ZStack {
            frontCard
                .opacity(viewModel.isFlipped ? 0 : 1)
                .rotation3DEffect(
                    .degrees(viewModel.isFlipped ? 180 : 0),
                    axis: (x: 0, y: 1, z: 0)
                )

            backCard
                .opacity(viewModel.isFlipped ? 1 : 0)
                .rotation3DEffect(
                    .degrees(viewModel.isFlipped ? 0 : -180),
                    axis: (x: 0, y: 1, z: 0)
                )
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: viewModel.flipDuration)) {
                viewModel.isFlipped.toggle()
            }
            viewModel.onFlip?(viewModel.isFlipped)
        }
        .accessibilityLabel("Flippable card")
        .accessibilityHint("Tap to flip")
        .accessibilityAddTraits(.isButton)
    }

    private var frontCard: some View {
        front
            .padding(viewModel.padding)
            .frame(maxWidth: .infinity)
            .background(FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            .fluxShadow(viewModel.shadow)
    }

    private var backCard: some View {
        back
            .padding(viewModel.padding)
            .frame(maxWidth: .infinity)
            .background(FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            .fluxShadow(viewModel.shadow)
    }
}
