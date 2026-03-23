import SwiftUI
import flux_ios_ds

// MARK: - Segment (for attributed text)

public struct FluxTextSegment {
    public let text: String
    public var isBold: Bool
    public var isItalic: Bool
    public var isUnderline: Bool
    public var isStrikethrough: Bool
    public var color: Color?
    public var fontSize: CGFloat?
    public var link: URL?

    public init(
        text: String,
        isBold: Bool = false,
        isItalic: Bool = false,
        isUnderline: Bool = false,
        isStrikethrough: Bool = false,
        color: Color? = nil,
        fontSize: CGFloat? = nil,
        link: URL? = nil
    ) {
        self.text = text
        self.isBold = isBold
        self.isItalic = isItalic
        self.isUnderline = isUnderline
        self.isStrikethrough = isStrikethrough
        self.color = color
        self.fontSize = fontSize
        self.link = link
    }
}

// MARK: - ViewModel

@MainActor
public class FluxTextViewModel: ObservableObject {
    @Published public var content: String?
    @Published public var segments: [FluxTextSegment]?
    @Published public var style: FluxText.Style
    @Published public var color: Color?

    /// Normal text mode — segments will be nil
    public init(
        content: String,
        style: FluxText.Style = .body,
        color: Color? = nil
    ) {
        self.content = content
        self.segments = nil
        self.style = style
        self.color = color
    }

    /// Attributed text mode — content will be nil
    public init(
        segments: [FluxTextSegment],
        style: FluxText.Style = .body,
        color: Color? = nil
    ) {
        self.content = nil
        self.segments = segments
        self.style = style
        self.color = color
    }

    /// Switch to normal text mode (clears segments)
    public func setContent(_ text: String) {
        self.content = text
        self.segments = nil
    }

    /// Switch to attributed text mode (clears content)
    public func setSegments(_ segments: [FluxTextSegment]) {
        self.segments = segments
        self.content = nil
    }
}

// MARK: - View

public struct FluxText: View {

    public enum Style {
        case largeTitle, title, title2, title3
        case headline, subheadline
        case body, callout, footnote, caption
        case code

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
            case .code:        return .system(.caption, design: .monospaced)
            }
        }

        public var defaultColor: Color {
            switch self {
            case .caption, .footnote, .subheadline:
                return FluxColors.textSecondary
            default:
                return FluxColors.textPrimary
            }
        }
    }

    @ObservedObject public var viewModel: FluxTextViewModel

    // MARK: - VM-based init (existing)

    public init(viewModel: FluxTextViewModel) {
        self.viewModel = viewModel
    }

    // MARK: - Convenience init for plain text

    public init(_ content: String, style: Style = .body, color: Color? = nil) {
        self.viewModel = FluxTextViewModel(content: content, style: style, color: color)
    }

    // MARK: - Convenience init for attributed text

    public init(segments: [FluxTextSegment], style: Style = .body, color: Color? = nil) {
        self.viewModel = FluxTextViewModel(segments: segments, style: style, color: color)
    }

    // MARK: - Body

    public var body: some View {
        if let segments = viewModel.segments {
            buildAttributedText(segments)
        } else if let content = viewModel.content {
            Text(content)
                .font(viewModel.style.font)
                .foregroundStyle(viewModel.color ?? viewModel.style.defaultColor)
        }
    }

    // MARK: - Attributed Text Builder

    private func buildAttributedText(_ segments: [FluxTextSegment]) -> some View {
        var result = Text("")
        for segment in segments {
            var part: Text
            if let url = segment.link {
                part = Text(.init("[\(segment.text)](\(url.absoluteString))"))
            } else {
                part = Text(segment.text)
            }

            if let fontSize = segment.fontSize {
                part = part.font(.system(size: fontSize))
            } else {
                part = part.font(viewModel.style.font)
            }

            if segment.isBold { part = part.bold() }
            if segment.isItalic { part = part.italic() }
            if segment.isUnderline { part = part.underline() }
            if segment.isStrikethrough { part = part.strikethrough() }

            if let color = segment.color {
                part = part.foregroundColor(color)
            } else if let baseColor = viewModel.color {
                part = part.foregroundColor(baseColor)
            } else {
                part = part.foregroundColor(viewModel.style.defaultColor)
            }

            result = result + part
        }
        return result
    }
}
