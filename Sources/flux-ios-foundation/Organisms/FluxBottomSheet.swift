import SwiftUI
import flux_ios_ds

// MARK: - ViewModel

@MainActor
public class FluxBottomSheetViewModel: ObservableObject {
    @Published public var isPresented: Bool
    @Published public var title: String?
    @Published public var detent: FluxBottomSheet<EmptyView>.Detent
    @Published public var showHandle: Bool
    @Published public var showCloseButton: Bool
    @Published public var isDismissibleByDrag: Bool
    public var onDismiss: (() -> Void)?

    public init(
        isPresented: Bool = false,
        title: String? = nil,
        detent: FluxBottomSheet<EmptyView>.Detent = .medium,
        showHandle: Bool = true,
        showCloseButton: Bool = true,
        isDismissibleByDrag: Bool = true,
        onDismiss: (() -> Void)? = nil
    ) {
        self.isPresented = isPresented
        self.title = title
        self.detent = detent
        self.showHandle = showHandle
        self.showCloseButton = showCloseButton
        self.isDismissibleByDrag = isDismissibleByDrag
        self.onDismiss = onDismiss
    }
}

// MARK: - View

public struct FluxBottomSheet<Content: View>: View {

    public enum Detent {
        case small
        case medium
        case large

        var heightFraction: CGFloat {
            switch self {
            case .small: return 0.25
            case .medium: return 0.50
            case .large: return 0.85
            }
        }
    }

    @ObservedObject public var viewModel: FluxBottomSheetViewModel
    private let content: Content
    @State private var dragOffset: CGFloat = 0

    public init(
        viewModel: FluxBottomSheetViewModel,
        @ViewBuilder content: () -> Content
    ) {
        self.viewModel = viewModel
        self.content = content()
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            if viewModel.isPresented {
                FluxColors.overlay
                    .ignoresSafeArea()
                    .onTapGesture { dismiss() }
                    .transition(.opacity)

                sheetContent
                    .transition(.move(edge: .bottom))
                    .offset(y: dragOffset)
                    .gesture(dragGesture)
            }
        }
        .animation(.easeInOut(duration: 0.3), value: viewModel.isPresented)
    }

    private var sheetContent: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 0) {
                    if viewModel.showHandle {
                        FluxDivider(viewModel: FluxDividerViewModel(
                            axis: .horizontal,
                            color: FluxColors.border,
                            thickness: 5,
                            cornerRadius: 2.5
                        ))
                        .frame(width: 36)
                        .padding(.top, FluxSpacing.xs)
                        .padding(.bottom, FluxSpacing.xs)
                    }

                    if viewModel.title != nil || viewModel.showCloseButton {
                        HStack {
                            if let title = viewModel.title {
                                FluxText(title, style: .headline)
                            }
                            Spacer()
                            if viewModel.showCloseButton {
                                Button { dismiss() } label: {
                                    FluxIcon("xmark.circle.fill", size: .large, color: FluxColors.textSecondary)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, FluxSpacing.md)
                        .padding(.bottom, FluxSpacing.xs)

                        FluxDivider(viewModel: FluxDividerViewModel())
                    }

                    ScrollView {
                        content.padding(FluxSpacing.md)
                    }
                }
                .frame(height: geometry.size.height * viewModel.detent.heightFraction)
                .background(FluxColors.background)
                .clipShape(RoundedRectangle(cornerRadius: FluxRadius.lg))
            }
        }
        .ignoresSafeArea(edges: .bottom)
    }

    private var dragGesture: some Gesture {
        DragGesture()
            .onChanged { value in
                guard viewModel.isDismissibleByDrag else { return }
                if value.translation.height > 0 { dragOffset = value.translation.height }
            }
            .onEnded { value in
                guard viewModel.isDismissibleByDrag else { return }
                if value.translation.height > 100 { dismiss() }
                dragOffset = 0
            }
    }

    private func dismiss() {
        viewModel.isPresented = false
        viewModel.onDismiss?()
    }
}
