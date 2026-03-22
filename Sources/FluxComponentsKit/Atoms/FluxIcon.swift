import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxIconViewModel: ObservableObject {
    @Published public var source: FluxIcon.Source
    @Published public var size: FluxIcon.Size
    @Published public var color: Color

    public init(
        source: FluxIcon.Source,
        size: FluxIcon.Size = .medium,
        color: Color = FluxColors.textPrimary
    ) {
        self.source = source
        self.size = size
        self.color = color
    }

    /// Backward-compatible convenience init
    public convenience init(
        systemName: String,
        size: FluxIcon.Size = .medium,
        color: Color = FluxColors.textPrimary
    ) {
        self.init(source: .system(systemName), size: size, color: color)
    }
}

// MARK: - View

public struct FluxIcon: View {

    public enum Source {
        case system(String)
        case asset(String)
        case url(URL)
    }

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

    // MARK: - Convenience inits

    /// Backward-compatible: system icon by SF Symbol name
    public init(_ systemName: String, size: Size = .medium, color: Color = FluxColors.textPrimary) {
        self.viewModel = FluxIconViewModel(source: .system(systemName), size: size, color: color)
    }

    /// Source-based init
    public init(source: FluxIcon.Source, size: Size = .medium, color: Color = FluxColors.textPrimary) {
        self.viewModel = FluxIconViewModel(source: source, size: size, color: color)
    }

    /// URL convenience init
    public init(url: URL, size: Size = .medium, color: Color = FluxColors.textPrimary) {
        self.viewModel = FluxIconViewModel(source: .url(url), size: size, color: color)
    }

    /// Asset convenience init
    public init(asset: String, size: Size = .medium, color: Color = FluxColors.textPrimary) {
        self.viewModel = FluxIconViewModel(source: .asset(asset), size: size, color: color)
    }

    public var body: some View {
        Group {
            switch viewModel.source {
            case .system(let name):
                Image(systemName: name)
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(viewModel.color)
            case .asset(let name):
                Image(name)
                    .resizable()
                    .scaledToFit()
            case .url(let url):
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Image(systemName: "exclamationmark.triangle")
                            .resizable()
                            .scaledToFit()
                            .foregroundStyle(viewModel.color)
                    case .empty:
                        ProgressView()
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
        .frame(width: viewModel.size.points, height: viewModel.size.points)
        .accessibilityHidden(true)
    }
}
