import SwiftUI
import FluxTokensKit

public struct FluxText: View {

    public enum Style {
        case largeTitle, title, title2, title3
        case headline, subheadline
        case body, callout, footnote, caption

        var font: Font {
            switch self {
            case .largeTitle:  return FluxFont.largeTitle
            case .title:       return FluxFont.title
            case .title2:      return FluxFont.title2
            case .title3:      return FluxFont.title3
            case .headline:    return FluxFont.headline
            case .subheadline: return FluxFont.subheadline
            case .body:        return FluxFont.body
            case .callout:     return FluxFont.callout
            case .footnote:    return FluxFont.footnote
            case .caption:     return FluxFont.caption
            }
        }

        var defaultColor: Color {
            switch self {
            case .caption, .footnote, .subheadline:
                return FluxColors.textSecondary
            default:
                return FluxColors.textPrimary
            }
        }
    }

    private let content: String
    private let style: Style
    private let color: Color?

    public init(
        _ content: String,
        style: Style = .body,
        color: Color? = nil
    ) {
        self.content = content
        self.style = style
        self.color = color
    }

    public var body: some View {
        Text(content)
            .font(style.font)
            .foregroundStyle(color ?? style.defaultColor)
    }
}
