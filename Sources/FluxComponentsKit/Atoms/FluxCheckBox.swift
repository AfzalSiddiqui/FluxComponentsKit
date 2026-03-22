import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxCheckBoxViewModel: ObservableObject {
    @Published public var isChecked: Bool
    @Published public var label: String
    @Published public var style: FluxCheckBox.Style
    @Published public var size: FluxCheckBox.Size
    @Published public var color: Color
    @Published public var isDisabled: Bool
    public var onToggle: ((Bool) -> Void)?

    public init(
        isChecked: Bool = false,
        label: String = "",
        style: FluxCheckBox.Style = .filled,
        size: FluxCheckBox.Size = .medium,
        color: Color = FluxColors.primary,
        isDisabled: Bool = false,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self.isChecked = isChecked
        self.label = label
        self.style = style
        self.size = size
        self.color = color
        self.isDisabled = isDisabled
        self.onToggle = onToggle
    }
}

// MARK: - View

public struct FluxCheckBox: View {

    public enum Style {
        case filled
        case outlined
    }

    public enum Size {
        case small
        case medium
        case large

        var boxSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 20
            case .large: return 24
            }
        }

        var checkmarkSize: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 14
            }
        }

        var textStyle: FluxText.Style {
            switch self {
            case .small: return .footnote
            case .medium: return .body
            case .large: return .headline
            }
        }

        var cornerRadius: CGFloat {
            switch self {
            case .small: return 3
            case .medium: return 4
            case .large: return 6
            }
        }
    }

    @ObservedObject public var viewModel: FluxCheckBoxViewModel

    public init(viewModel: FluxCheckBoxViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Button {
            viewModel.isChecked.toggle()
            viewModel.onToggle?(viewModel.isChecked)
        } label: {
            HStack(spacing: FluxSpacing.sm) {
                RoundedRectangle(cornerRadius: viewModel.size.cornerRadius)
                    .fill(boxFillColor)
                    .frame(width: viewModel.size.boxSize, height: viewModel.size.boxSize)
                    .overlay(
                        RoundedRectangle(cornerRadius: viewModel.size.cornerRadius)
                            .stroke(boxBorderColor, lineWidth: viewModel.style == .outlined ? FluxBorder.thick : 0)
                    )
                    .overlay(
                        FluxIcon("checkmark", size: .custom(viewModel.size.checkmarkSize), color: checkmarkColor)
                            .opacity(viewModel.isChecked ? 1 : 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isChecked)

                if !viewModel.label.isEmpty {
                    FluxText(viewModel.label, style: viewModel.size.textStyle)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isDisabled)
        .opacity(viewModel.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(viewModel.label)
        .accessibilityAddTraits(viewModel.isChecked ? [.isButton, .isSelected] : .isButton)
    }

    private var boxFillColor: Color {
        switch viewModel.style {
        case .filled:
            return viewModel.isChecked ? viewModel.color : FluxColors.border.opacity(FluxOpacity.muted)
        case .outlined:
            return Color.clear
        }
    }

    private var boxBorderColor: Color {
        switch viewModel.style {
        case .filled:
            return Color.clear
        case .outlined:
            return viewModel.isChecked ? viewModel.color : FluxColors.border
        }
    }

    private var checkmarkColor: Color {
        switch viewModel.style {
        case .filled:
            return FluxColors.onPrimary
        case .outlined:
            return viewModel.color
        }
    }
}
