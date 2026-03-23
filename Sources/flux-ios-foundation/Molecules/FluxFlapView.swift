import SwiftUI
import flux_ios_ds

// MARK: - Tab

public struct FluxFlapTab {
    public let title: String
    public let icon: FluxIcon.Source?

    public init(title: String, icon: FluxIcon.Source? = nil) {
        self.title = title
        self.icon = icon
    }
}

// MARK: - ViewModel

@MainActor
public class FluxFlapViewModel: ObservableObject {
    @Published public var tabs: [FluxFlapTab]
    @Published public var selectedIndex: Int
    @Published public var style: FluxFlapView<EmptyView>.Style
    public var onTabChanged: ((Int) -> Void)?

    public init(
        tabs: [FluxFlapTab],
        selectedIndex: Int = 0,
        style: FluxFlapView<EmptyView>.Style = .underlined,
        onTabChanged: ((Int) -> Void)? = nil
    ) {
        self.tabs = tabs
        self.selectedIndex = selectedIndex
        self.style = style
        self.onTabChanged = onTabChanged
    }
}

// MARK: - View

public struct FluxFlapView<Content: View>: View {

    public enum Style {
        case underlined
        case filled
        case pill
    }

    @ObservedObject public var viewModel: FluxFlapViewModel
    private let content: (Int) -> Content

    public init(
        viewModel: FluxFlapViewModel,
        @ViewBuilder content: @escaping (Int) -> Content
    ) {
        self.viewModel = viewModel
        self.content = content
    }

    public var body: some View {
        VStack(spacing: 0) {
            tabBar
            FluxDivider(viewModel: FluxDividerViewModel())
            content(viewModel.selectedIndex)
                .frame(maxWidth: .infinity)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.2), value: viewModel.selectedIndex)
        }
    }

    private var tabBar: some View {
        HStack(spacing: viewModel.style == .pill ? FluxSpacing.xs : 0) {
            ForEach(Array(viewModel.tabs.enumerated()), id: \.offset) { index, tab in
                tabButton(tab, at: index)
            }
        }
        .padding(.horizontal, viewModel.style == .pill ? FluxSpacing.sm : 0)
        .padding(.vertical, viewModel.style == .pill ? FluxSpacing.xs : 0)
    }

    private func tabButton(_ tab: FluxFlapTab, at index: Int) -> some View {
        let isSelected = index == viewModel.selectedIndex
        return Button {
            viewModel.selectedIndex = index
            viewModel.onTabChanged?(index)
        } label: {
            HStack(spacing: FluxSpacing.xxs) {
                if let icon = tab.icon {
                    FluxIcon(source: icon, size: .custom(14), color: tabForeground(isSelected: isSelected))
                }
                FluxText(tab.title, style: .body, color: tabForeground(isSelected: isSelected))
            }
            .padding(.vertical, FluxSpacing.sm)
            .padding(.horizontal, FluxSpacing.md)
            .frame(maxWidth: viewModel.style == .pill ? nil : .infinity)
            .background(tabBackground(isSelected: isSelected))
            .clipShape(tabShape)
            .overlay(alignment: .bottom) {
                if viewModel.style == .underlined && isSelected {
                    FluxDivider(viewModel: FluxDividerViewModel(
                        axis: .horizontal,
                        color: FluxColors.primary,
                        thickness: 2
                    ))
                }
            }
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.2), value: viewModel.selectedIndex)
    }

    private func tabForeground(isSelected: Bool) -> Color {
        switch viewModel.style {
        case .underlined:
            return isSelected ? FluxColors.primary : FluxColors.textSecondary
        case .filled:
            return isSelected ? FluxColors.onPrimary : FluxColors.textSecondary
        case .pill:
            return isSelected ? FluxColors.onPrimary : FluxColors.textSecondary
        }
    }

    private func tabBackground(isSelected: Bool) -> Color {
        switch viewModel.style {
        case .underlined:
            return Color.clear
        case .filled:
            return isSelected ? FluxColors.primary : Color.clear
        case .pill:
            return isSelected ? FluxColors.primary : FluxColors.surface
        }
    }

    private var tabShape: some Shape {
        RoundedRectangle(cornerRadius: viewModel.style == .pill ? FluxRadius.xl : 0)
    }
}
