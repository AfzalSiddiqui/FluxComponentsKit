import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxHeaderViewModel: ObservableObject {
    @Published public var title: String
    @Published public var subtitle: String?

    public init(
        title: String,
        subtitle: String? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
    }
}

// MARK: - View

public struct FluxHeader<LeadingAction: View, TrailingAction: View>: View {

    @ObservedObject public var viewModel: FluxHeaderViewModel
    private let leadingAction: LeadingAction
    private let trailingAction: TrailingAction

    public init(
        viewModel: FluxHeaderViewModel,
        @ViewBuilder leadingAction: () -> LeadingAction = { EmptyView() },
        @ViewBuilder trailingAction: () -> TrailingAction = { EmptyView() }
    ) {
        self.viewModel = viewModel
        self.leadingAction = leadingAction()
        self.trailingAction = trailingAction()
    }

    public var body: some View {
        HStack {
            leadingAction

            VStack(spacing: FluxSpacing.xxxs) {
                FluxText(viewModel.title, style: .title2)
                if let subtitle = viewModel.subtitle {
                    FluxText(subtitle, style: .subheadline)
                }
            }
            .frame(maxWidth: .infinity)

            trailingAction
        }
        .padding(.horizontal, FluxSpacing.md)
        .padding(.vertical, FluxSpacing.sm)
        .background(FluxColors.background)
    }
}
