import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxSegmentedControlViewModel: ObservableObject {
    @Published public var items: [String]
    @Published public var selectedIndex: Int
    @Published public var size: FluxSegmentedControl.Size
    @Published public var style: FluxSegmentedControl.Style
    @Published public var isDisabled: Bool
    public var onSelectionChanged: ((Int) -> Void)?

    public init(
        items: [String],
        selectedIndex: Int = 0,
        size: FluxSegmentedControl.Size = .medium,
        style: FluxSegmentedControl.Style = .filled,
        isDisabled: Bool = false,
        onSelectionChanged: ((Int) -> Void)? = nil
    ) {
        self.items = items
        self.selectedIndex = selectedIndex
        self.size = size
        self.style = style
        self.isDisabled = isDisabled
        self.onSelectionChanged = onSelectionChanged
    }
}

// MARK: - View

public struct FluxSegmentedControl: View {

    public enum Size {
        case small
        case medium
        case large

        var textStyle: FluxText.Style {
            switch self {
            case .small: return .footnote
            case .medium: return .body
            case .large: return .headline
            }
        }

        var verticalPadding: CGFloat {
            switch self {
            case .small: return FluxSpacing.xxs
            case .medium: return FluxSpacing.xs
            case .large: return FluxSpacing.sm
            }
        }

        var horizontalPadding: CGFloat {
            switch self {
            case .small: return FluxSpacing.xs
            case .medium: return FluxSpacing.sm
            case .large: return FluxSpacing.md
            }
        }
    }

    public enum Style {
        case filled
        case outlined
    }

    @ObservedObject public var viewModel: FluxSegmentedControlViewModel

    public init(viewModel: FluxSegmentedControlViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                Button {
                    viewModel.selectedIndex = index
                    viewModel.onSelectionChanged?(index)
                } label: {
                    FluxText(item, style: viewModel.size.textStyle, color: foregroundColor(for: index))
                        .padding(.vertical, viewModel.size.verticalPadding)
                        .padding(.horizontal, viewModel.size.horizontalPadding)
                        .frame(maxWidth: .infinity)
                        .background(backgroundColor(for: index))
                }
                .buttonStyle(.plain)
            }
        }
        .background(surfaceBackground)
        .clipShape(RoundedRectangle(cornerRadius: FluxRadius.md))
        .overlay(
            RoundedRectangle(cornerRadius: FluxRadius.md)
                .stroke(viewModel.style == .outlined ? FluxColors.border : Color.clear, lineWidth: FluxBorder.thin)
        )
        .disabled(viewModel.isDisabled)
        .opacity(viewModel.isDisabled ? 0.5 : 1.0)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedIndex)
        .accessibilityElement(children: .contain)
    }

    private func foregroundColor(for index: Int) -> Color {
        let isSelected = index == viewModel.selectedIndex
        switch viewModel.style {
        case .filled:
            return isSelected ? FluxColors.onPrimary : FluxColors.textPrimary
        case .outlined:
            return isSelected ? FluxColors.primary : FluxColors.textSecondary
        }
    }

    private func backgroundColor(for index: Int) -> Color {
        let isSelected = index == viewModel.selectedIndex
        switch viewModel.style {
        case .filled:
            return isSelected ? FluxColors.primary : Color.clear
        case .outlined:
            return isSelected ? FluxColors.primary.opacity(FluxOpacity.light) : Color.clear
        }
    }

    private var surfaceBackground: Color {
        switch viewModel.style {
        case .filled: return FluxColors.surface
        case .outlined: return Color.clear
        }
    }
}
