import SwiftUI
import flux_ios_ds

// MARK: - ViewModel

@MainActor
public class FluxAlertViewViewModel: ObservableObject {
    @Published public var variant: FluxAlertView.Variant
    @Published public var title: String
    @Published public var message: String
    @Published public var icon: FluxIcon.Source?
    @Published public var isDismissible: Bool
    @Published public var isVisible: Bool
    public var onDismiss: (() -> Void)?

    public init(
        variant: FluxAlertView.Variant = .info,
        title: String,
        message: String,
        icon: FluxIcon.Source? = nil,
        isDismissible: Bool = true,
        isVisible: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) {
        self.variant = variant
        self.title = title
        self.message = message
        self.icon = icon
        self.isDismissible = isDismissible
        self.isVisible = isVisible
        self.onDismiss = onDismiss
    }
}

// MARK: - View

public struct FluxAlertView: View {

    public enum Variant {
        case info
        case success
        case warning
        case error

        var defaultIcon: FluxIcon.Source {
            switch self {
            case .info: return .system("info.circle.fill")
            case .success: return .system("checkmark.circle.fill")
            case .warning: return .system("exclamationmark.triangle.fill")
            case .error: return .system("xmark.circle.fill")
            }
        }

        var color: Color {
            switch self {
            case .info: return FluxColors.primary
            case .success: return FluxColors.success
            case .warning: return FluxColors.warning
            case .error: return FluxColors.error
            }
        }

        var backgroundColor: Color {
            switch self {
            case .info: return FluxColors.primary.opacity(FluxOpacity.light)
            case .success: return FluxColors.success.opacity(FluxOpacity.light)
            case .warning: return FluxColors.warning.opacity(FluxOpacity.light)
            case .error: return FluxColors.error.opacity(FluxOpacity.light)
            }
        }
    }

    @ObservedObject public var viewModel: FluxAlertViewViewModel

    public init(viewModel: FluxAlertViewViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        if viewModel.isVisible {
            HStack(alignment: .top, spacing: FluxSpacing.sm) {
                FluxIcon(
                    source: viewModel.icon ?? viewModel.variant.defaultIcon,
                    size: .large,
                    color: viewModel.variant.color
                )

                VStack(alignment: .leading, spacing: FluxSpacing.xxxs) {
                    FluxText(viewModel.title, style: .headline)
                    FluxText(viewModel.message, style: .footnote)
                }

                Spacer(minLength: 0)

                if viewModel.isDismissible {
                    Button {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.isVisible = false
                        }
                        viewModel.onDismiss?()
                    } label: {
                        FluxIcon("xmark", size: .custom(12), color: FluxColors.textSecondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(FluxSpacing.md)
            .background(viewModel.variant.backgroundColor)
            .overlay(alignment: .leading) {
                FluxDivider(viewModel: FluxDividerViewModel(
                    axis: .vertical,
                    color: viewModel.variant.color,
                    thickness: 4
                ))
            }
            .clipShape(RoundedRectangle(cornerRadius: FluxRadius.sm))
            .transition(.opacity.combined(with: .move(edge: .top)))
            .accessibilityElement(children: .combine)
        }
    }
}
