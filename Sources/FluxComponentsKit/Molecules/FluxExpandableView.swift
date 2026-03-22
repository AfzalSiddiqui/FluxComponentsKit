import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxExpandableViewModel: ObservableObject {
    @Published public var title: String
    @Published public var icon: FluxIcon.Source?
    @Published public var isExpanded: Bool
    @Published public var style: FluxExpandableView<EmptyView>.Style
    public var onToggle: ((Bool) -> Void)?

    public init(
        title: String,
        icon: FluxIcon.Source? = nil,
        isExpanded: Bool = false,
        style: FluxExpandableView<EmptyView>.Style = .card,
        onToggle: ((Bool) -> Void)? = nil
    ) {
        self.title = title
        self.icon = icon
        self.isExpanded = isExpanded
        self.style = style
        self.onToggle = onToggle
    }
}

// MARK: - View

public struct FluxExpandableView<Content: View>: View {

    public enum Style {
        case card
        case plain
        case bordered
    }

    @ObservedObject public var viewModel: FluxExpandableViewModel
    private let content: Content

    public init(
        viewModel: FluxExpandableViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
    }

    public var body: some View {
        VStack(spacing: 0) {
            headerButton

            if viewModel.isExpanded {
                if viewModel.style == .plain {
                    FluxDivider(viewModel: FluxDividerViewModel())
                }
                content
                    .padding(contentPadding)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: cornerRadius)
                .stroke(borderColor, lineWidth: viewModel.style == .bordered ? FluxBorder.thin : 0)
        )
        .fluxShadow(viewModel.style == .card ? .small : FluxShadow(color: .clear, radius: 0, x: 0, y: 0))
        .animation(.easeInOut(duration: 0.3), value: viewModel.isExpanded)
    }

    private var headerButton: some View {
        Button {
            viewModel.isExpanded.toggle()
            viewModel.onToggle?(viewModel.isExpanded)
        } label: {
            HStack(spacing: FluxSpacing.sm) {
                if let icon = viewModel.icon {
                    FluxIcon(source: icon, size: .small, color: FluxColors.primary)
                }

                FluxText(viewModel.title, style: .headline)

                Spacer()

                FluxIcon("chevron.right", size: .custom(12), color: FluxColors.textSecondary)
                    .rotationEffect(.degrees(viewModel.isExpanded ? 90 : 0))
            }
            .padding(FluxSpacing.md)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(viewModel.title)
        .accessibilityAddTraits(.isButton)
    }

    private var backgroundColor: Color {
        switch viewModel.style {
        case .card: return FluxColors.surface
        case .plain: return Color.clear
        case .bordered: return FluxColors.surface
        }
    }

    private var cornerRadius: CGFloat {
        switch viewModel.style {
        case .card: return FluxRadius.md
        case .plain: return 0
        case .bordered: return FluxRadius.md
        }
    }

    private var borderColor: Color {
        switch viewModel.style {
        case .bordered: return FluxColors.border
        default: return Color.clear
        }
    }

    private var contentPadding: EdgeInsets {
        EdgeInsets(top: 0, leading: FluxSpacing.md, bottom: FluxSpacing.md, trailing: FluxSpacing.md)
    }
}
