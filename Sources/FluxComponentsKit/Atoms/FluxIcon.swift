import SwiftUI
import FluxTokensKit

public struct FluxIcon: View {

    public enum Size {
        case small
        case medium
        case large

        var points: CGFloat {
            switch self {
            case .small:  return FluxSpacing.md
            case .medium: return FluxSpacing.lg
            case .large:  return FluxSpacing.xl
            }
        }
    }

    private let systemName: String
    private let size: Size
    private let color: Color

    public init(
        _ systemName: String,
        size: Size = .medium,
        color: Color = FluxColors.textPrimary
    ) {
        self.systemName = systemName
        self.size = size
        self.color = color
    }

    public var body: some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: size.points, height: size.points)
            .foregroundStyle(color)
            .accessibilityHidden(true)
    }
}
