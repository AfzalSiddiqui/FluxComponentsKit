import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxInfoViewModel: ObservableObject {
    @Published public var icon: String
    @Published public var iconColor: Color
    @Published public var title: String
    @Published public var description: String
    @Published public var alignment: FluxInfoView.Alignment

    public init(
        icon: String,
        iconColor: Color = FluxColors.primary,
        title: String,
        description: String,
        alignment: FluxInfoView.Alignment = .horizontal
    ) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.description = description
        self.alignment = alignment
    }
}

// MARK: - View

public struct FluxInfoView: View {

    public enum Alignment {
        case horizontal
        case vertical
    }

    @ObservedObject public var viewModel: FluxInfoViewModel

    public init(viewModel: FluxInfoViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        Group {
            switch viewModel.alignment {
            case .horizontal:
                horizontalLayout
            case .vertical:
                verticalLayout
            }
        }
        .padding(FluxSpacing.md)
        .background(FluxColors.surface)
        .clipShape(RoundedRectangle(cornerRadius: FluxRadius.md))
        .fluxShadow(.small)
        .accessibilityElement(children: .combine)
    }

    private var horizontalLayout: some View {
        HStack(spacing: FluxSpacing.sm) {
            FluxIcon(viewModel.icon, size: .large, color: viewModel.iconColor)
            VStack(alignment: .leading, spacing: FluxSpacing.xxxs) {
                FluxText(viewModel.title, style: .headline)
                FluxText(viewModel.description, style: .footnote)
            }
            Spacer(minLength: 0)
        }
    }

    private var verticalLayout: some View {
        VStack(spacing: FluxSpacing.xs) {
            FluxIcon(viewModel.icon, size: .large, color: viewModel.iconColor)
            FluxText(viewModel.title, style: .headline)
                .multilineTextAlignment(.center)
            FluxText(viewModel.description, style: .footnote)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}
