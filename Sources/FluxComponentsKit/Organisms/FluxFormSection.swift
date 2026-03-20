import SwiftUI
import FluxTokensKit

public struct FluxFormSection<Content: View>: View {

    private let title: String?
    private let spacing: CGFloat
    private let content: Content

    public init(
        title: String? = nil,
        spacing: CGFloat = FluxSpacing.sm,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.spacing = spacing
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: FluxSpacing.xs) {
            if let title {
                Text(title)
                    .font(FluxFont.headline)
                    .foregroundStyle(FluxColors.textPrimary)
                    .padding(.bottom, FluxSpacing.xs)
            }
            VStack(spacing: spacing) {
                content
            }
        }
    }
}
