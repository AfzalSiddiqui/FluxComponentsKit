import SwiftUI
import flux_ios_ds

// MARK: - Item

public struct FluxBoxGridItem {
    public let icon: FluxIcon.Source
    public let label: String
    public let color: Color

    public init(icon: FluxIcon.Source, label: String, color: Color = FluxColors.primary) {
        self.icon = icon
        self.label = label
        self.color = color
    }
}

// MARK: - ViewModel

@MainActor
public class FluxBoxGridViewModel: ObservableObject {
    @Published public var items: [FluxBoxGridItem]
    @Published public var columns: Int
    @Published public var selectionMode: FluxBoxGrid.SelectionMode
    @Published public var selectedIndices: Set<Int>
    @Published public var itemSize: FluxBoxGrid.ItemSize
    public var onSelectionChanged: ((Set<Int>) -> Void)?

    public init(
        items: [FluxBoxGridItem],
        columns: Int = 3,
        selectionMode: FluxBoxGrid.SelectionMode = .none,
        selectedIndices: Set<Int> = [],
        itemSize: FluxBoxGrid.ItemSize = .medium,
        onSelectionChanged: ((Set<Int>) -> Void)? = nil
    ) {
        self.items = items
        self.columns = columns
        self.selectionMode = selectionMode
        self.selectedIndices = selectedIndices
        self.itemSize = itemSize
        self.onSelectionChanged = onSelectionChanged
    }
}

// MARK: - View

public struct FluxBoxGrid: View {

    public enum SelectionMode {
        case none
        case single
        case multi
    }

    public enum ItemSize {
        case small
        case medium
        case large

        var iconSize: FluxIcon.Size {
            switch self {
            case .small: return .small
            case .medium: return .medium
            case .large: return .large
            }
        }

        var padding: CGFloat {
            switch self {
            case .small: return FluxSpacing.xs
            case .medium: return FluxSpacing.sm
            case .large: return FluxSpacing.md
            }
        }

        var textStyle: FluxText.Style {
            switch self {
            case .small: return .caption
            case .medium: return .footnote
            case .large: return .body
            }
        }
    }

    @ObservedObject public var viewModel: FluxBoxGridViewModel

    public init(viewModel: FluxBoxGridViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: FluxSpacing.xs), count: viewModel.columns), spacing: FluxSpacing.xs) {
            ForEach(Array(viewModel.items.enumerated()), id: \.offset) { index, item in
                gridCell(item, at: index)
            }
        }
    }

    private func gridCell(_ item: FluxBoxGridItem, at index: Int) -> some View {
        let isSelected = viewModel.selectedIndices.contains(index)
        return Button {
            guard viewModel.selectionMode != .none else { return }
            toggleSelection(at: index)
        } label: {
            VStack(spacing: FluxSpacing.xs) {
                FluxIcon(
                    source: item.icon,
                    size: viewModel.itemSize.iconSize,
                    color: isSelected ? FluxColors.onPrimary : item.color
                )

                FluxText(
                    item.label,
                    style: viewModel.itemSize.textStyle,
                    color: isSelected ? FluxColors.onPrimary : FluxColors.textPrimary
                )
                .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(viewModel.itemSize.padding)
            .background(isSelected ? FluxColors.primary : FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: FluxRadius.md))
            .overlay(
                RoundedRectangle(cornerRadius: FluxRadius.md)
                    .stroke(isSelected ? FluxColors.primary : FluxColors.border.opacity(FluxOpacity.disabled), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: isSelected)
    }

    private func toggleSelection(at index: Int) {
        switch viewModel.selectionMode {
        case .none:
            break
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
