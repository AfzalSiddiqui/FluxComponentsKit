import SwiftUI
import FluxTokensKit

public struct FluxTextField: View {

    private let label: String
    private let placeholder: String
    @Binding private var text: String
    private let errorMessage: String?
    private let isSecure: Bool

    public init(
        label: String,
        placeholder: String = "",
        text: Binding<String>,
        errorMessage: String? = nil,
        isSecure: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder
        self._text = text
        self.errorMessage = errorMessage
        self.isSecure = isSecure
    }

    @FocusState private var isFocused: Bool

    public var body: some View {
        VStack(alignment: .leading, spacing: FluxSpacing.xs) {
            Text(label)
                .font(FluxFont.caption)
                .foregroundStyle(FluxColors.textSecondary)

            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                } else {
                    TextField(placeholder, text: $text)
                }
            }
            .font(FluxFont.body)
            .foregroundStyle(FluxColors.textPrimary)
            .padding(.horizontal, FluxSpacing.sm)
            .padding(.vertical, FluxSpacing.sm)
            .background(FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FluxRadius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: FluxRadius.sm)
                    .stroke(borderColor, lineWidth: 1.5)
            )
            .focused($isFocused)

            if let errorMessage, !errorMessage.isEmpty {
                Text(errorMessage)
                    .font(FluxFont.caption)
                    .foregroundStyle(FluxColors.error)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var borderColor: Color {
        if let errorMessage, !errorMessage.isEmpty {
            return FluxColors.error
        }
        return isFocused ? FluxColors.primary : FluxColors.border
    }
}
