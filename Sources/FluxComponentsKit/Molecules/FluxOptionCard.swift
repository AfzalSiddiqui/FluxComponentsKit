import SwiftUI
import FluxTokensKit

// MARK: - Option

public struct FluxOption {
    public let icon: String
    public let label: String
    public let subtitle: String?

    public init(icon: String, label: String, subtitle: String? = nil) {
        self.icon = icon
        self.label = label
        self.subtitle = subtitle
    }
}

// MARK: - ViewModel

@MainActor
public class FluxOptionCardViewModel: ObservableObject {
    @Published public var options: [FluxOption]
    @Published public var selectionMode: FluxOptionCard.SelectionMode
    @Published public var selectedIndices: Set<Int>
    public var onSelectionChanged: ((Set<Int>) -> Void)?

    public init(
        options: [FluxOption],
        selectionMode: FluxOptionCard.SelectionMode = .single,
        selectedIndices: Set<Int> = [],
        onSelectionChanged: ((Set<Int>) -> Void)? = nil
    ) {
        self.options = options
        self.selectionMode = selectionMode
        self.selectedIndices = selectedIndices
        self.onSelectionChanged = onSelectionChanged
    }
}

// MARK: - View

public struct FluxOptionCard: View {

    public enum SelectionMode {
        case single
        case multi
    }

    @ObservedObject public var viewModel: FluxOptionCardViewModel

    public init(viewModel: FluxOptionCardViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: FluxSpacing.xs) {
            ForEach(Array(viewModel.options.enumerated()), id: \.offset) { index, option in
                optionRow(option, at: index)
            }
        }
    }

    private func optionRow(_ option: FluxOption, at index: Int) -> some View {
        let isSelected = viewModel.selectedIndices.contains(index)
        return Button {
            toggleSelection(at: index)
        } label: {
            HStack(spacing: FluxSpacing.sm) {
                FluxIcon(
                    option.icon,
                    size: .large,
                    color: isSelected ? FluxColors.primary : FluxColors.textSecondary
                )

                VStack(alignment: .leading, spacing: FluxSpacing.xxxs) {
                    FluxText(option.label, style: .body)
                    if let subtitle = option.subtitle {
                        FluxText(subtitle, style: .caption)
                    }
                }

                Spacer(minLength: 0)

                selectionIndicator(isSelected: isSelected)
            }
            .padding(FluxSpacing.md)
            .background(isSelected ? FluxColors.primary.opacity(0.08) : FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FluxRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FluxRadius.md)
                    .stroke(isSelected ? FluxColors.primary : FluxColors.border, lineWidth: isSelected ? 2 : 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    @ViewBuilder
    private func selectionIndicator(isSelected: Bool) -> some View {
        switch viewModel.selectionMode {
        case .single:
            FluxRadioButton(viewModel: FluxRadioButtonViewModel(
                label: "",
                isSelected: isSelected,
                size: .medium,
                color: FluxColors.primary
            ))
            .allowsHitTesting(false)
        case .multi:
            FluxCheckBox(viewModel: FluxCheckBoxViewModel(
                isChecked: isSelected,
                label: "",
                style: .filled,
                size: .medium,
                color: FluxColors.primary
            ))
            .allowsHitTesting(false)
        }
    }

    private func toggleSelection(at index: Int) {
        switch viewModel.selectionMode {
        case .single:
            viewModel.selectedIndices = [index]
        case .multi:
            if viewModel.selectedIndices.contains(index) {
                viewModel.selectedIndices.remove(index)
            } else {
                viewModel.selectedIndices.insert(index)
            }
        }
        viewModel.onSelectionChanged?(viewModel.selectedIndices)
    }
}
