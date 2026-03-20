import SwiftUI
import FluxTokensKit

public struct FluxHeader<LeadingAction: View, TrailingAction: View>: View {

    private let title: String
    private let subtitle: String?
    private let leadingAction: LeadingAction
    private let trailingAction: TrailingAction

    public init(
        title: String,
        subtitle: String? = nil,
        @ViewBuilder leadingAction: () -> LeadingAction = { EmptyView() },
        @ViewBuilder trailingAction: () -> TrailingAction = { EmptyView() }
    ) {
        self.title = title
        self.subtitle = subtitle
        self.leadingAction = leadingAction()
        self.trailingAction = trailingAction()
    }

    public var body: some View {
        HStack {
            leadingAction

            VStack(spacing: FluxSpacing.xxxs) {
                Text(title)
                    .font(FluxFont.title2)
                    .foregroundStyle(FluxColors.textPrimary)
                if let subtitle {
                    Text(subtitle)
                        .font(FluxFont.subheadline)
                        .foregroundStyle(FluxColors.textSecondary)
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
