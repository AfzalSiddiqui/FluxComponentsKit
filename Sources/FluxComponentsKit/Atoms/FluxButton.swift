import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxButtonViewModel: ObservableObject {
    @Published public var title: String
    @Published public var variant: FluxButton.Variant
    @Published public var size: FluxButton.Size
    @Published public var isLoading: Bool
    @Published public var isDisabled: Bool
    public var action: () -> Void

    public init(
        title: String,
        variant: FluxButton.Variant = .primary,
        size: FluxButton.Size = .medium,
        isLoading: Bool = false,
        isDisabled: Bool = false,
        action: @escaping () -> Void = {}
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.isDisabled = isDisabled
        self.action = action
    }
}

// MARK: - View

public struct FluxButton: View {

    public enum Variant {
        case primary
        case secondary
        case destructive
    }

    public enum Size {
        case small
        case medium
        case large

        var font: Font {
            switch self {
            case .small: return FluxFont.footnote
            case .medium: return FluxFont.body
            case .large: return FluxFont.headline
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return FluxSpacing.xs
            case .medium: return FluxSpacing.sm
            case .large: return FluxSpacing.md
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return FluxSpacing.sm
            case .medium: return FluxSpacing.md
            case .large: return FluxSpacing.lg
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return FluxRadius.sm
            case .medium: return FluxRadius.md
            case .large: return FluxRadius.lg
            }
        }
    }

    @ObservedObject public var viewModel: FluxButtonViewModel

    public init(viewModel: FluxButtonViewModel) {
        self.viewModel = viewModel
    }

    @Environment(\.isEnabled) private var isEnabled

    public var body: some View {
        Button(action: viewModel.action) {
            HStack(spacing: FluxSpacing.xs) {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
                FluxText(viewModel.title, style: .body)
                    .font(viewModel.size.font)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, viewModel.size.verticalPadding)
            .padding(.horizontal, viewModel.size.horizontalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: viewModel.size.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: viewModel.size.cornerRadius)
                    .stroke(borderColor, lineWidth: viewModel.variant == .secondary ? 1.5 : 0)
            )
        }
        .disabled(viewModel.isLoading || viewModel.isDisabled)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityLabel(viewModel.title)
        .accessibilityAddTraits(.isButton)
    }

    private var backgroundColor: Color {
        switch viewModel.variant {
        case .primary: return FluxColors.primary
        case .secondary: return Color.clear
        case .destructive: return FluxColors.error
        }
    }

    private var foregroundColor: Color {
        switch viewModel.variant {
        case .primary: return .white
        case .secondary: return FluxColors.primary
        case .destructive: return .white
        }
    }

    private var borderColor: Color {
        switch viewModel.variant {
        case .primary: return Color.clear
        case .secondary: return FluxColors.primary
        case .destructive: return Color.clear
        }
    }
}
