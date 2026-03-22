import SwiftUI
import FluxTokensKit

// MARK: - ViewModel

@MainActor
public class FluxFormSectionViewModel: ObservableObject {
    @Published public var title: String?
    @Published public var spacing: CGFloat

    public init(
        title: String? = nil,
        spacing: CGFloat = FluxSpacing.sm
    ) {
        self.title = title
        self.spacing = spacing
    }
}

// MARK: - View

public struct FluxFormSection<Content: View>: View {

    @ObservedObject public var viewModel: FluxFormSectionViewModel
    private let content: Content

    public init(
        viewModel: FluxFormSectionViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: FluxSpacing.xs) {
            if let title = viewModel.title {
                Text(title)
                    .font(FluxFont.headline)
                    .foregroundStyle(FluxColors.textPrimary)
                    .padding(.bottom, FluxSpacing.xs)
            }
            VStack(spacing: viewModel.spacing) {
                content
            }
        }
    }
}
