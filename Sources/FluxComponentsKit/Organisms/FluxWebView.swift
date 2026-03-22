import SwiftUI
import FluxTokensKit

#if canImport(UIKit)
import UIKit
import WebKit

// MARK: - ViewModel

@MainActor
public class FluxWebViewViewModel: ObservableObject {
    @Published public var url: URL?
    @Published public var isLoading: Bool = false
    @Published public var progress: Double = 0
    @Published public var errorMessage: String?
    @Published public var showProgressBar: Bool
    @Published public var title: String?

    public init(
        url: URL? = nil,
        showProgressBar: Bool = true,
        title: String? = nil
    ) {
        self.url = url
        self.showProgressBar = showProgressBar
        self.title = title
    }

    public func loadURL(_ urlString: String) {
        errorMessage = nil
        guard let url = URL(string: urlString), url.scheme != nil else {
            errorMessage = "Invalid URL"
            return
        }
        self.url = url
    }
}

// MARK: - View

public struct FluxWebView: View {

    @ObservedObject public var viewModel: FluxWebViewViewModel

    public init(viewModel: FluxWebViewViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(spacing: 0) {
            if viewModel.showProgressBar && viewModel.isLoading {
                FluxLoader(viewModel: FluxLoaderViewModel(
                    progress: viewModel.progress,
                    tint: FluxColors.primary
                ))
            }

            if let errorMessage = viewModel.errorMessage {
                errorView(errorMessage)
            } else if let url = viewModel.url {
                WebViewRepresentable(url: url, viewModel: viewModel)
            } else {
                placeholderView
            }
        }
    }

    private func errorView(_ message: String) -> some View {
        VStack(spacing: FluxSpacing.md) {
            FluxIcon("exclamationmark.triangle.fill", size: .large, color: FluxColors.error)

            FluxText(message, style: .body, color: FluxColors.textSecondary)
                .multilineTextAlignment(.center)

            Button {
                if let url = viewModel.url {
                    viewModel.loadURL(url.absoluteString)
                }
            } label: {
                FluxText("Retry", style: .body, color: FluxColors.primary)
                    .padding(.horizontal, FluxSpacing.md)
                    .padding(.vertical, FluxSpacing.xs)
                    .background(FluxColors.primary.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: FluxRadius.sm))
            }
            .buttonStyle(.plain)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(FluxSpacing.md)
    }

    private var placeholderView: some View {
        VStack(spacing: FluxSpacing.sm) {
            FluxIcon("globe", size: .large, color: FluxColors.textSecondary)
            FluxText("Enter a URL to load", style: .body, color: FluxColors.textSecondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - UIViewRepresentable

private struct WebViewRepresentable: UIViewRepresentable {
    let url: URL
    let viewModel: FluxWebViewViewModel

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        context.coordinator.observeWebView(webView)
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ webView: WKWebView, context: Context) {
        if webView.url != url {
            webView.load(URLRequest(url: url))
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(viewModel: viewModel)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let viewModel: FluxWebViewViewModel
        private var progressObservation: NSKeyValueObservation?
        private var titleObservation: NSKeyValueObservation?

        init(viewModel: FluxWebViewViewModel) {
            self.viewModel = viewModel
        }

        func observeWebView(_ webView: WKWebView) {
            progressObservation = webView.observe(\.estimatedProgress) { [weak self] webView, _ in
                Task { @MainActor in
                    self?.viewModel.progress = webView.estimatedProgress
                }
            }
            titleObservation = webView.observe(\.title) { [weak self] webView, _ in
                Task { @MainActor in
                    self?.viewModel.title = webView.title
                }
            }
        }

        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            Task { @MainActor in
                viewModel.isLoading = true
                viewModel.errorMessage = nil
            }
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            Task { @MainActor in
                viewModel.isLoading = false
            }
        }

        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            Task { @MainActor in
                viewModel.isLoading = false
                viewModel.errorMessage = error.localizedDescription
            }
        }

        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
            Task { @MainActor in
                viewModel.isLoading = false
                viewModel.errorMessage = error.localizedDescription
            }
        }
    }
}

#else

// MARK: - macOS Stub

@MainActor
public class FluxWebViewViewModel: ObservableObject {
    @Published public var url: URL?
    @Published public var isLoading: Bool = false
    @Published public var progress: Double = 0
    @Published public var errorMessage: String?
    @Published public var showProgressBar: Bool
    @Published public var title: String?

    public init(url: URL? = nil, showProgressBar: Bool = true, title: String? = nil) {
        self.url = url
        self.showProgressBar = showProgressBar
        self.title = title
    }

    public func loadURL(_ urlString: String) {
        errorMessage = nil
        guard let url = URL(string: urlString), url.scheme != nil else {
            errorMessage = "Invalid URL"
            return
        }
        self.url = url
    }
}

public struct FluxWebView: View {
    @ObservedObject public var viewModel: FluxWebViewViewModel

    public init(viewModel: FluxWebViewViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        FluxText("WebView is only available on iOS", style: .body, color: FluxColors.textSecondary)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#endif
