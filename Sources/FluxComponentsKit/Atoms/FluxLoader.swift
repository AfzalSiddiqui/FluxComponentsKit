import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxLoaderViewModel: ObservableObject {
    @Published public var size: FluxLoader.Size
    @Published public var tint: Color

    public init(
        size: FluxLoader.Size = .medium,
        tint: Color = FluxColors.primary
    ) {
        self.size = size
        self.tint = tint
    }
}

// MARK: - View

public struct FluxLoader: View {

    public enum Size {
        case small
        case medium
        case large

        var controlSize: ControlSize {
            switch self {
            case .small:  return .small
            case .medium: return .regular
            case .large:  return .regular
            }
        }

        var scale: CGFloat {
            switch self {
            case .small:  return 1.0
            case .medium: return 1.0
            case .large:  return 1.5
            }
        }
    }

    @ObservedObject public var viewModel: FluxLoaderViewModel

    public init(viewModel: FluxLoaderViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ProgressView()
            .controlSize(viewModel.size.controlSize)
            .scaleEffect(viewModel.size.scale)
            .tint(viewModel.tint)
            .accessibilityLabel("Loading")
    }
}
