import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxToggleViewModel: ObservableObject {
    @Published public var isOn: Bool
    @Published public var label: String
    @Published public var size: FluxToggle.Size
    @Published public var tintColor: Color
    @Published public var isDisabled: Bool
    public var onToggle: ((Bool) -> Void)?

    public init(
        isOn: Bool = false,
        label: String = "",
        size: FluxToggle.Size = .medium,
        tintColor: Color = FluxColors.primary,
        isDisabled: Bool = false,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self.isOn = isOn
        self.label = label
        self.size = size
        self.tintColor = tintColor
        self.isDisabled = isDisabled
        self.onToggle = onToggle
    }
}

// MARK: - View

public struct FluxToggle: View {

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

        var textStyle: FluxText.Style {
            switch self {
            case .small: return .footnote
            case .medium: return .body
            case .large: return .headline
            }
        }

        var controlSize: ControlSize {
            switch self {
            case .small: return .small
            case .medium: return .regular
            case .large: return .large
            }
        }
    }

    @ObservedObject public var viewModel: FluxToggleViewModel

    public init(viewModel: FluxToggleViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack {
            if !viewModel.label.isEmpty {
                FluxText(viewModel.label, style: viewModel.size.textStyle)
                Spacer()
            }
            Toggle("", isOn: Binding(
                get: { viewModel.isOn },
                set: { newValue in
                    viewModel.isOn = newValue
                    viewModel.onToggle?(newValue)
                }
            ))
            .labelsHidden()
            .tint(viewModel.tintColor)
            .controlSize(viewModel.size.controlSize)
        }
        .disabled(viewModel.isDisabled)
        .opacity(viewModel.isDisabled ? FluxOpacity.disabled : 1.0)
        .accessibilityLabel(viewModel.label)
        .accessibilityAddTraits(.isButton)
    }
}
