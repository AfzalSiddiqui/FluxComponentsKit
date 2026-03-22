import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxTextFieldViewModel: ObservableObject {
    @Published public var label: String
    @Published public var placeholder: String
    @Published public var text: String
    @Published public var errorMessage: String?
    @Published public var isSecure: Bool

    public init(
        label: String,
        placeholder: String = "",
        text: String = "",
        errorMessage: String? = nil,
        isSecure: Bool = false
    ) {
        self.label = label
        self.placeholder = placeholder
        self.text = text
        self.errorMessage = errorMessage
        self.isSecure = isSecure
    }
}

// MARK: - View

public struct FluxTextField: View {

    @ObservedObject public var viewModel: FluxTextFieldViewModel

    public init(viewModel: FluxTextFieldViewModel) {
        self.viewModel = viewModel
    }

    @FocusState private var isFocused: Bool

    public var body: some View {
        VStack(alignment: .leading, spacing: FluxSpacing.xs) {
            FluxText(viewModel.label, style: .caption)

            Group {
                if viewModel.isSecure {
                    SecureField(viewModel.placeholder, text: $viewModel.text)
                } else {
                    TextField(viewModel.placeholder, text: $viewModel.text)
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
                    .stroke(borderColor, lineWidth: FluxBorder.medium)
            )
            .focused($isFocused)

            if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
                FluxText(errorMessage, style: .caption, color: FluxColors.error)
            }
        }
        .accessibilityElement(children: .combine)
    }

    private var borderColor: Color {
        if let errorMessage = viewModel.errorMessage, !errorMessage.isEmpty {
            return FluxColors.error
        }
        return isFocused ? FluxColors.primary : FluxColors.border
    }
}
