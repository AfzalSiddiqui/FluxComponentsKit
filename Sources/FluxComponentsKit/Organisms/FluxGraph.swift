import SwiftUI
import FluxTokensKit

// MARK: - DataPoint

public struct FluxDataPoint {
    public let label: String
    public let value: Double
    public let color: Color?

    public init(label: String, value: Double, color: Color? = nil) {
        self.label = label
        self.value = value
        self.color = color
    }
}

// MARK: - ViewModel

@MainActor
public class FluxGraphViewModel: ObservableObject {
    @Published public var chartType: FluxGraph.ChartType
    @Published public var data: [FluxDataPoint]
    @Published public var title: String?
    @Published public var showLabels: Bool
    @Published public var showValues: Bool
    @Published public var barColor: Color
    @Published public var lineColor: Color
    @Published public var animate: Bool

    public init(
        chartType: FluxGraph.ChartType = .bar,
        data: [FluxDataPoint] = [],
        title: String? = nil,
        showLabels: Bool = true,
        showValues: Bool = true,
        barColor: Color = FluxColors.primary,
        lineColor: Color = FluxColors.primary,
        animate: Bool = true
    ) {
        self.chartType = chartType
        self.data = data
        self.title = title
        self.showLabels = showLabels
        self.showValues = showValues
        self.barColor = barColor
        self.lineColor = lineColor
        self.animate = animate
    }
}

// MARK: - View

public struct FluxGraph: View {

    public enum ChartType {
        case bar
        case line
        case pie
    }

    @ObservedObject public var viewModel: FluxGraphViewModel
    @State private var animationProgress: CGFloat = 0

    public init(viewModel: FluxGraphViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: FluxSpacing.sm) {
            if let title = viewModel.title {
                FluxText(title, style: .headline)
            }

            switch viewModel.chartType {
            case .bar:
                barChart
            case .line:
                lineChart
            case .pie:
                pieChart
            }
        }
        .onAppear {
            if viewModel.animate {
                withAnimation(.easeInOut(duration: 0.8)) {
                    animationProgress = 1
                }
            } else {
                animationProgress = 1
            }
        }
        .onChange(of: viewModel.chartType) { _ in
            animationProgress = 0
            withAnimation(.easeInOut(duration: 0.8)) {
                animationProgress = 1
            }
        }
    }

    // MARK: - Bar Chart

    private var barChart: some View {
        let maxValue = viewModel.data.map(\.value).max() ?? 1

        return VStack(spacing: FluxSpacing.xs) {
            HStack(alignment: .bottom, spacing: FluxSpacing.xs) {
                ForEach(Array(viewModel.data.enumerated()), id: \.offset) { _, point in
                    VStack(spacing: FluxSpacing.xxs) {
                        if viewModel.showValues {
                            FluxText("\(Int(point.value))", style: .caption)
                        }

                        RoundedRectangle(cornerRadius: FluxRadius.xs)
                            .fill(point.color ?? viewModel.barColor)
                            .frame(maxWidth: .infinity)
                            .frame(height: max(4, CGFloat(point.value / maxValue) * 150 * animationProgress))

                        if viewModel.showLabels {
                            FluxText(point.label, style: .caption)
                                .lineLimit(1)
                        }
                    }
                }
            }
            .frame(height: 200)

            FluxDivider(viewModel: FluxDividerViewModel())
        }
    }

    // MARK: - Line Chart

    private var lineChart: some View {
        let maxValue = viewModel.data.map(\.value).max() ?? 1

        return VStack(spacing: FluxSpacing.xs) {
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                let stepX = viewModel.data.count > 1 ? width / CGFloat(viewModel.data.count - 1) : width
                let points = viewModel.data.enumerated().map { index, point in
                    CGPoint(
                        x: CGFloat(index) * stepX,
                        y: height - CGFloat(point.value / maxValue) * height * animationProgress
                    )
                }

                ZStack {
                    Path { path in
                        guard let first = points.first else { return }
                        path.move(to: first)
                        for point in points.dropFirst() {
                            path.addLine(to: point)
                        }
                    }
                    .stroke(viewModel.lineColor, lineWidth: 2)

                    ForEach(Array(points.enumerated()), id: \.offset) { index, point in
                        FluxIcon("circle.fill", size: .custom(8), color: viewModel.data[index].color ?? viewModel.lineColor)
                            .position(point)

                        if viewModel.showValues {
                            FluxText("\(Int(viewModel.data[index].value))", style: .caption)
                                .position(x: point.x, y: point.y - 14)
                        }
                    }
                }
            }
            .frame(height: 180)

            if viewModel.showLabels {
                HStack {
                    ForEach(Array(viewModel.data.enumerated()), id: \.offset) { _, point in
                        FluxText(point.label, style: .caption)
                            .frame(maxWidth: .infinity)
                    }
                }
            }
        }
    }

    // MARK: - Pie Chart

    private var pieChart: some View {
        let total = viewModel.data.map(\.value).reduce(0, +)
        let defaultColors: [Color] = [FluxColors.primary, FluxColors.success, FluxColors.warning, FluxColors.error, FluxColors.accent]

        return VStack(spacing: FluxSpacing.sm) {
            GeometryReader { geometry in
                let size = min(geometry.size.width, geometry.size.height)
                let center = CGPoint(x: geometry.size.width / 2, y: size / 2)
                let radius = size / 2

                ZStack {
                    ForEach(Array(viewModel.data.enumerated()), id: \.offset) { index, _ in
                        let (startAngle, endAngle) = sliceAngles(index: index, total: total)
                        PieSlice(
                            startAngle: startAngle,
                            endAngle: Angle(degrees: startAngle.degrees + (endAngle.degrees - startAngle.degrees) * animationProgress),
                            center: center,
                            radius: radius
                        )
                        .fill(viewModel.data[index].color ?? defaultColors[index % defaultColors.count])
                    }
                }
            }
            .frame(height: 200)

            // Legend
            VStack(alignment: .leading, spacing: FluxSpacing.xxs) {
                ForEach(Array(viewModel.data.enumerated()), id: \.offset) { index, point in
                    HStack(spacing: FluxSpacing.xs) {
                        FluxIcon("circle.fill", size: .custom(10), color: point.color ?? defaultColors[index % defaultColors.count])
                        FluxText(point.label, style: .footnote)
                        Spacer()
                        if viewModel.showValues {
                            FluxText("\(Int(point.value))", style: .footnote)
                        }
                    }
                }
            }
        }
    }

    private func sliceAngles(index: Int, total: Double) -> (Angle, Angle) {
        let values = viewModel.data.map(\.value)
        var startDegrees: Double = -90
        for i in 0..<index {
            startDegrees += (values[i] / total) * 360
        }
        let endDegrees = startDegrees + (values[index] / total) * 360
        return (Angle(degrees: startDegrees), Angle(degrees: endDegrees))
    }
}

// MARK: - Pie Slice Shape

private struct PieSlice: Shape {
    let startAngle: Angle
    let endAngle: Angle
    let center: CGPoint
    let radius: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: center)
        path.addArc(center: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        path.closeSubpath()
        return path
    }
}
