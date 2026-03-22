import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxIconViewModel: ObservableObject {
    @Published public var systemName: String
    @Published public var size: FluxIcon.Size
    @Published public var color: Color

    public init(
        systemName: String,
        size: FluxIcon.Size = .medium,
        color: Color = FluxColors.textPrimary
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
    }
}

// MARK: - View

public struct FluxIcon: View {

    public enum Size {
        case small
        case medium
        case large
        case custom(CGFloat)

        var points: CGFloat {
            switch self {
            case .small:  return FluxSpacing.md
            case .medium: return FluxSpacing.lg
            case .large:  return FluxSpacing.xl
            case .custom(let size): return size
            }
        }
    }

    @ObservedObject public var viewModel: FluxIconViewModel

    // MARK: - VM-based init (existing)

    public init(viewModel: FluxIconViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Convenience init

    public init(_ systemName: String, size: Size = .medium, color: Color = FluxColors.textPrimary) {
        self.viewModel = FluxIconViewModel(systemName: systemName, size: size, color: color)
    }

    public var body: some View {
        Image(systemName: viewModel.systemName)
            .resizable()
            .scaledToFit()
            .frame(width: viewModel.size.points, height: viewModel.size.points)
            .foregroundStyle(viewModel.color)
            .accessibilityHidden(true)
    }
}
