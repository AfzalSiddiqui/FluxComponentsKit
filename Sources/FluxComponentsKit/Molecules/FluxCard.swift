import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxCardViewModel: ObservableObject {
    @Published public var padding: CGFloat
    @Published public var cornerRadius: CGFloat
    @Published public var shadow: FluxShadow

    public init(
        padding: CGFloat = FluxSpacing.md,
        cornerRadius: CGFloat = FluxRadius.md,
        shadow: FluxShadow = .small
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
    }
}

// MARK: - View

public struct FluxCard<Content: View>: View {

    @ObservedObject public var viewModel: FluxCardViewModel
    private let content: Content

    public init(
        viewModel: FluxCardViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
    }

    public var body: some View {
        content
            .padding(viewModel.padding)
            .background(FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            .fluxShadow(viewModel.shadow)
    }
}
