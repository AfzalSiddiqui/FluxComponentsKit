import SwiftUI
import flux_ios_ds

// MARK: - ViewModel

@MainActor
public class FluxImageViewModel: ObservableObject {
    @Published public var source: FluxImage.Source
    @Published public var size: FluxImage.Size
    @Published public var contentMode: ContentMode
    @Published public var cornerRadius: CGFloat
    @Published public var borderColor: Color?
    @Published public var borderWidth: CGFloat
    @Published public var isLoading: Bool
    @Published public var loadFailed: Bool
    public var onTap: (() -> Void)?

    public init(
        source: FluxImage.Source,
        size: FluxImage.Size = .medium,
        contentMode: ContentMode = .fill,
        cornerRadius: CGFloat = 0,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        onTap: (() -> Void)? = nil
    ) {
        self.source = source
        self.size = size
        self.contentMode = contentMode
        self.cornerRadius = cornerRadius
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.isLoading = false
        self.loadFailed = false
        self.onTap = onTap
    }
}

// MARK: - View

public struct FluxImage: View {

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
        case flexible

        var points: CGFloat? {
            switch self {
            case .small: return 40
            case .medium: return 80
            case .large: return 160
            case .custom(let size): return size
            case .flexible: return nil
            }
        }
    }

    @ObservedObject public var viewModel: FluxImageViewModel

    // MARK: - VM-based init

    public init(viewModel: FluxImageViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Convenience inits

    public init(systemName: String, size: Size = .medium, color: Color = FluxColors.textPrimary, onTap: (() -> Void)? = nil) {
        self.viewModel = FluxImageViewModel(source: .system(systemName), size: size, onTap: onTap)
    }

    public init(asset: String, size: Size = .medium, contentMode: ContentMode = .fill, cornerRadius: CGFloat = 0, onTap: (() -> Void)? = nil) {
        self.viewModel = FluxImageViewModel(source: .asset(asset), size: size, contentMode: contentMode, cornerRadius: cornerRadius, onTap: onTap)
    }

    public init(url: URL, size: Size = .medium, contentMode: ContentMode = .fill, cornerRadius: CGFloat = 0, onTap: (() -> Void)? = nil) {
        self.viewModel = FluxImageViewModel(source: .url(url), size: size, contentMode: contentMode, cornerRadius: cornerRadius, onTap: onTap)
    }

    public var body: some View {
        let content = imageContent
            .clipShape(RoundedRectangle(cornerRadius: viewModel.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: viewModel.cornerRadius)
                    .stroke(viewModel.borderColor ?? Color.clear, lineWidth: viewModel.borderWidth)
            )

        if let onTap = viewModel.onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
                .accessibilityAddTraits(.isButton)
        } else {
            content
        }
    }

    @ViewBuilder
    private var imageContent: some View {
        switch viewModel.source {
        case .system(let name):
            systemImage(name)
        case .asset(let name):
            assetImage(name)
        case .url(let url):
            asyncImage(url)
        }
    }

    // MARK: - System Image (SF Symbol)

    private func systemImage(_ name: String) -> some View {
        Image(systemName: name)
            .resizable()
            .aspectRatio(contentMode: viewModel.contentMode)
            .modifier(SizeModifier(size: viewModel.size))
            .foregroundStyle(FluxColors.textPrimary)
    }

    // MARK: - Asset Image

    private func assetImage(_ name: String) -> some View {
        Image(name)
            .resizable()
            .aspectRatio(contentMode: viewModel.contentMode)
            .modifier(SizeModifier(size: viewModel.size))
    }

    // MARK: - Async URL Image

    private func asyncImage(_ url: URL) -> some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .tint(FluxColors.primary)
                    .modifier(SizeModifier(size: viewModel.size))
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: viewModel.contentMode)
                    .modifier(SizeModifier(size: viewModel.size))
            case .failure:
                failurePlaceholder
            @unknown default:
                failurePlaceholder
            }
        }
    }

    private var failurePlaceholder: some View {
        VStack(spacing: FluxSpacing.xs) {
            FluxIcon("photo.fill", size: .medium, color: FluxColors.textSecondary)
            FluxText("Failed to load", style: .caption)
        }
        .modifier(SizeModifier(size: viewModel.size))
        .background(FluxColors.surface)
    }
}

// MARK: - Size Modifier

private struct SizeModifier: ViewModifier {
    let size: FluxImage.Size

    func body(content: Content) -> some View {
        if let points = size.points {
            content.frame(width: points, height: points)
        } else {
            content
        }
    }
}
