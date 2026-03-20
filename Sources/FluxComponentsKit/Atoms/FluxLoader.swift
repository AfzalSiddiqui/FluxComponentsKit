import SwiftUI
import FluxTokensKit

public struct FluxLoader: View {

    public enum Size {
        case small
        case medium
        case large

        var controlSize: ControlSize {
            switch self {
            case .small:  return .small
            case .medium: return .regular
            case .large:  return .regular
            }
        }

        var scale: CGFloat {
            switch self {
            case .small:  return 1.0
            case .medium: return 1.0
            case .large:  return 1.5
            }
        }
    }

    private let size: Size
    private let tintColor: Color

    public init(
        size: Size = .medium,
        tint: Color = FluxColors.primary
    ) {
        self.size = size
        self.tintColor = tint
    }

    public var body: some View {
        ProgressView()
            .controlSize(size.controlSize)
            .scaleEffect(size.scale)
            .tint(tintColor)
            .accessibilityLabel("Loading")
    }
}
