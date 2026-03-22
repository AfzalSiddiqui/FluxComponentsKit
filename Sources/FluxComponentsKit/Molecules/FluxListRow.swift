import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxListRowViewModel: ObservableObject {
    @Published public var icon: FluxIcon.Source?
    @Published public var iconColor: Color
    @Published public var title: String
    @Published public var subtitle: String?
    @Published public var showChevron: Bool
    public var action: (() -> Void)?

    public init(
        icon: FluxIcon.Source? = nil,
        iconColor: Color = FluxColors.primary,
        title: String,
        subtitle: String? = nil,
        showChevron: Bool = true,
        action: (() -> Void)? = nil
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.subtitle = subtitle
        self.showChevron = showChevron
        self.action = action
    }
}

// MARK: - View

public struct FluxListRow: View {

    @ObservedObject public var viewModel: FluxListRowViewModel

    public init(viewModel: FluxListRowViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        let content = HStack(spacing: FluxSpacing.sm) {
            if let icon = viewModel.icon {
                FluxIcon(viewModel: FluxIconViewModel(source: icon, size: .medium, color: viewModel.iconColor))
            }

            VStack(alignment: .leading, spacing: FluxSpacing.xxxs) {
                FluxText(viewModel.title, style: .body)
                if let subtitle = viewModel.subtitle {
                    FluxText(subtitle, style: .caption)
                }
            }

            Spacer(minLength: 0)

            if viewModel.showChevron {
                FluxIcon(viewModel: FluxIconViewModel(systemName: "chevron.right", size: .small, color: FluxColors.textSecondary))
            }
        }
        .padding(.vertical, FluxSpacing.sm)
        .padding(.horizontal, FluxSpacing.md)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(viewModel.action != nil ? .isButton : [])

        if let action = viewModel.action {
            Button(action: action) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }
}
