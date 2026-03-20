import SwiftUI
import FluxTokensKit

public struct FluxListRow: View {

    private let icon: String?
    private let iconColor: Color
    private let title: String
    private let subtitle: String?
    private let showChevron: Bool
    private let action: (() -> Void)?

    public init(
        icon: String? = nil,
        iconColor: Color = FluxColors.primary,
        title: String,
        subtitle: String? = nil,
        showChevron: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.showChevron = showChevron
        self.action = action
    }

    public var body: some View {
        let content = HStack(spacing: FluxSpacing.sm) {
            if let icon {
                FluxIcon(icon, size: .medium, color: iconColor)
            }

            VStack(alignment: .leading, spacing: FluxSpacing.xxxs) {
                Text(title)
                    .font(FluxFont.body)
                    .foregroundStyle(FluxColors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(FluxFont.caption)
                        .foregroundStyle(FluxColors.textSecondary)
                }
            }

            Spacer(minLength: 0)

            if showChevron {
                FluxIcon("chevron.right", size: .small, color: FluxColors.textSecondary)
            }
        }
        .padding(.vertical, FluxSpacing.sm)
        .padding(.horizontal, FluxSpacing.md)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(action != nil ? .isButton : [])

        if let action {
            Button(action: action) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }
}
