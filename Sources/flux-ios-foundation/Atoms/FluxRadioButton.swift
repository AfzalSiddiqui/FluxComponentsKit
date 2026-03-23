import SwiftUI
import flux_ios_ds

// MARK: - ViewModel

@MainActor
public class FluxRadioButtonViewModel: ObservableObject {
    @Published public var label: String
    @Published public var isSelected: Bool
    @Published public var size: FluxRadioButton.Size
    @Published public var color: Color
    @Published public var isDisabled: Bool
    public var onSelect: (() -> Void)?

    public init(
        label: String,
        isSelected: Bool = false,
        size: FluxRadioButton.Size = .medium,
        color: Color = FluxColors.primary,
        isDisabled: Bool = false,
        onSelect: (() -> Void)? = nil
    ) {
        self.label = label
        self.isSelected = isSelected
        self.size = size
        self.color = color
        self.isDisabled = isDisabled
        self.onSelect = onSelect
    }
}

// MARK: - View

public struct FluxRadioButton: View {

    public enum Size {
        case small
        case medium
        case large

        var circleSize: CGFloat {
            switch self {
            case .small: return 16
            case .medium: return 20
            case .large: return 24
            }
        }

        var innerDotSize: CGFloat {
            switch self {
            case .small: return 8
            case .medium: return 10
            case .large: return 12
            }
        }

        var textStyle: FluxText.Style {
            switch self {
            case .small: return .footnote
            case .medium: return .body
            case .large: return .headline
            }
        }
    }

    @ObservedObject public var viewModel: FluxRadioButtonViewModel

    public init(viewModel: FluxRadioButtonViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Button {
            viewModel.isSelected = true
            viewModel.onSelect?()
        } label: {
            HStack(spacing: FluxSpacing.sm) {
                Circle()
                    .stroke(viewModel.isSelected ? viewModel.color : FluxColors.border, lineWidth: FluxBorder.thick)
                    .frame(width: viewModel.size.circleSize, height: viewModel.size.circleSize)
                    .overlay(
                        Circle()
                            .fill(viewModel.color)
                            .frame(width: viewModel.size.innerDotSize, height: viewModel.size.innerDotSize)
                            .opacity(viewModel.isSelected ? 1 : 0)
                    )
                    .animation(.easeInOut(duration: 0.2), value: viewModel.isSelected)

                if !viewModel.label.isEmpty {
                    FluxText(viewModel.label, style: viewModel.size.textStyle)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isDisabled)
        .opacity(viewModel.isDisabled ? 0.5 : 1.0)
        .accessibilityLabel(viewModel.label)
        .accessibilityAddTraits(viewModel.isSelected ? [.isButton, .isSelected] : .isButton)
    }
}
