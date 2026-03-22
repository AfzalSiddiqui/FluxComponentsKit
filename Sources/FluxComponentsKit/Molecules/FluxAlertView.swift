import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxAlertViewViewModel: ObservableObject {
    @Published public var variant: FluxAlertView.Variant
    @Published public var title: String
    @Published public var message: String
    @Published public var icon: String?
    @Published public var isDismissible: Bool
    @Published public var isVisible: Bool
    public var onDismiss: (() -> Void)?

    public init(
        variant: FluxAlertView.Variant = .info,
        title: String,
        message: String,
        icon: String? = nil,
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

        var defaultIcon: String {
            switch self {
            case .info: return "info.circle.fill"
            case .success: return "checkmark.circle.fill"
            case .warning: return "exclamationmark.triangle.fill"
            case .error: return "xmark.circle.fill"
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
            case .info: return FluxColors.primary.opacity(0.1)
            case .success: return FluxColors.success.opacity(0.1)
            case .warning: return FluxColors.warning.opacity(0.1)
            case .error: return FluxColors.error.opacity(0.1)
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
                    viewModel.icon ?? viewModel.variant.defaultIcon,
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
