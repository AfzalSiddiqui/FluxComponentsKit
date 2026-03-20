import SwiftUI
import FluxTokensKit

public struct FluxCard<Content: View>: View {

    private let padding: CGFloat
    private let cornerRadius: CGFloat
    private let shadow: FluxShadow
    private let content: Content

    public init(
        padding: CGFloat = FluxSpacing.md,
        cornerRadius: CGFloat = FluxRadius.md,
        shadow: FluxShadow = .small,
        @ViewBuilder content: () -> Content
    ) {
        self.padding = padding
        self.cornerRadius = cornerRadius
        self.shadow = shadow
        self.content = content()
    }

    public var body: some View {
        content
            .padding(padding)
            .background(FluxColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .fluxShadow(shadow)
    }
}
