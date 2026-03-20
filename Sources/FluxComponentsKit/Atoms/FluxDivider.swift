import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxDividerViewModel: ObservableObject {
    @Published public var axis: FluxDivider.Axis
    @Published public var color: Color

    public init(
        axis: FluxDivider.Axis = .horizontal,
        color: Color = FluxColors.divider
    ) {
        self.axis = axis
        self.color = color
    }
}

// MARK: - View

public struct FluxDivider: View {

    public enum Axis {
        case horizontal
        case vertical
    }

    @ObservedObject public var viewModel: FluxDividerViewModel

    public init(viewModel: FluxDividerViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        switch viewModel.axis {
        case .horizontal:
            Rectangle()
                .fill(viewModel.color)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)
        case .vertical:
            Rectangle()
                .fill(viewModel.color)
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .accessibilityHidden(true)
        }
    }
}
