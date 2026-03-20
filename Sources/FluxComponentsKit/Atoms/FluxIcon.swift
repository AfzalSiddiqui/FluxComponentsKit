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

        var points: CGFloat {
            switch self {
            case .small:  return FluxSpacing.md
            case .medium: return FluxSpacing.lg
            case .large:  return FluxSpacing.xl
            }
        }
    }

    @ObservedObject public var viewModel: FluxIconViewModel

    public init(viewModel: FluxIconViewModel) {
        self.viewModel = viewModel
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
