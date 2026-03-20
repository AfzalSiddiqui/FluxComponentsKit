import SwiftUI
import FluxTokensKit

public struct FluxDivider: View {

    public enum Axis {
        case horizontal
        case vertical
    }

    private let axis: Axis
    private let color: Color

    public init(
        axis: Axis = .horizontal,
        color: Color = FluxColors.divider
    ) {
        self.axis = axis
        self.color = color
    }

    public var body: some View {
        switch axis {
        case .horizontal:
            Rectangle()
                .fill(color)
                .frame(height: 1)
                .frame(maxWidth: .infinity)
                .accessibilityHidden(true)
        case .vertical:
            Rectangle()
                .fill(color)
                .frame(width: 1)
                .frame(maxHeight: .infinity)
                .accessibilityHidden(true)
        }
    }
}
