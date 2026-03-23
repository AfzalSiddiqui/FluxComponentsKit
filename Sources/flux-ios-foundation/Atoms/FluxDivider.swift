import SwiftUI
import flux_ios_ds

// MARK: - ViewModel

@MainActor
public class FluxDividerViewModel: ObservableObject {
    @Published public var axis: FluxDivider.Axis
    @Published public var color: Color
    @Published public var thickness: CGFloat
    @Published public var cornerRadius: CGFloat

    public init(
        axis: FluxDivider.Axis = .horizontal,
        color: Color = FluxColors.divider,
        thickness: CGFloat = 1,
        cornerRadius: CGFloat = 0
    ) {
        self.axis = axis
        self.color = color
        self.thickness = thickness
        self.cornerRadius = cornerRadius
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
            RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                .fill(viewModel.color)
                .frame(height: viewModel.thickness)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)
        case .vertical:
            RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                .fill(viewModel.color)
                .frame(width: viewModel.thickness)
                .frame(maxHeight: .infinity)
                .accessibilityHidden(true)
        }
    }
}
