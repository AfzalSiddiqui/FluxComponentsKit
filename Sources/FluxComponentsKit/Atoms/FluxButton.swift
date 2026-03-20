import SwiftUI
import FluxTokensKit

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

    private let title: String
    private let variant: Variant
    private let size: Size
    private let isLoading: Bool
    private let action: () -> Void

    public init(
        _ title: String,
        variant: Variant = .primary,
        size: Size = .medium,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.variant = variant
        self.size = size
        self.isLoading = isLoading
        self.action = action
    }

    @Environment(\.isEnabled) private var isEnabled

    public var body: some View {
        Button(action: action) {
            HStack(spacing: FluxSpacing.xs) {
                if isLoading {
                    ProgressView()
                        .tint(foregroundColor)
                }
                Text(title)
                    .font(size.font)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, size.verticalPadding)
            .padding(.horizontal, size.horizontalPadding)
            .foregroundStyle(foregroundColor)
            .background(backgroundColor)
            .clipShape(RoundedRectangle(cornerRadius: size.cornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: size.cornerRadius)
                    .stroke(borderColor, lineWidth: variant == .secondary ? 1.5 : 0)
            )
        }
        .disabled(isLoading)
        .opacity(isEnabled ? 1.0 : 0.5)
        .accessibilityLabel(title)
        .accessibilityAddTraits(.isButton)
    }

    private var backgroundColor: Color {
        switch variant {
        case .primary: return FluxColors.primary
        case .secondary: return Color.clear
        case .destructive: return FluxColors.error
        }
    }

    private var foregroundColor: Color {
        switch variant {
        case .primary: return .white
        case .secondary: return FluxColors.primary
        case .destructive: return .white
        }
    }

    private var borderColor: Color {
        switch variant {
        case .primary: return Color.clear
        case .secondary: return FluxColors.primary
        case .destructive: return Color.clear
        }
    }
}
