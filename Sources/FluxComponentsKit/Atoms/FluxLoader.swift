import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxLoaderViewModel: ObservableObject {
    @Published public var size: FluxLoader.Size
    @Published public var tint: Color
    @Published public var progress: Double?

    /// Indeterminate spinner
    public init(
        size: FluxLoader.Size = .medium,
        tint: Color = FluxColors.primary
    ) {
        self.size = size
        self.tint = tint
        self.progress = nil
    }

    /// Determinate progress bar (0.0 – 1.0)
    public init(
        progress: Double,
        tint: Color = FluxColors.primary
    ) {
        self.size = .medium
        self.tint = tint
        self.progress = progress
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
        if let progress = viewModel.progress {
            ProgressView(value: progress)
                .tint(viewModel.tint)
                .accessibilityLabel("Loading \(Int(progress * 100))%")
        } else {
            ProgressView()
                .controlSize(viewModel.size.controlSize)
                .scaleEffect(viewModel.size.scale)
                .tint(viewModel.tint)
                .accessibilityLabel("Loading")
        }
    }
}
