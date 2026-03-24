# flux-ios-foundation

**Reusable SwiftUI components for the Flux iOS Design System.** 26 production-ready components for fast, consistent, and adaptive UI development.

`flux-ios-foundation` provides a complete component library organized using the **Atomic Design** pattern. Every component is theme-driven, accessible, and powered by reactive **MVVM ViewModels**.

---

## Features

- **11 Atoms** — Buttons, text, icons, loaders, toggles, checkboxes, and more
- **10 Molecules** — Cards, text fields, alerts, option cards, tabs, grids
- **5 Organisms** — Headers, bottom sheets, forms, charts, web views
- **MVVM architecture** — Every component has a dedicated ViewModel
- **Theme-driven** — All visuals come from `flux-ios-ds` tokens
- **Accessible** — Dynamic Type, VoiceOver, color contrast built-in
- **No hard-coded values** — Enforces consistent design system usage

---

## Installation

```swift
// Package.swift
dependencies: [
    .package(path: "../flux-ios-foundation")
]
```

```swift
import flux_ios_foundation
// This also gives you flux_ios_ds tokens via @_exported import
```

> **Dependency:** `flux-ios-foundation` depends on [`flux-ios-ds`](../flux-ios-ds) for design tokens.

---

## Components

### Atoms (11) — Basic Building Blocks

| Component | Description | Key Props |
|-----------|-------------|-----------|
| **FluxButton** | Action trigger | variant (primary/secondary/destructive), size, isLoading, isDisabled |
| **FluxText** | Text display | style (largeTitle...caption), attributed segments (bold, italic, URLs) |
| **FluxIcon** | Icon renderer | source (.system/.asset/.url), size (small/medium/large), color |
| **FluxLoader** | Loading indicator | spinner (indeterminate) or progress bar (0.0-1.0), size, tint |
| **FluxDivider** | Visual separator | axis (horizontal/vertical), color, thickness |
| **FluxCheckBox** | Multi-select | style (filled/outlined), size, label, animated toggle |
| **FluxToggle** | Boolean switch | native iOS toggle, size, label, tint |
| **FluxSegmentedControl** | Multi-option selector | style (filled/outlined), size, items, selection callback |
| **FluxRadioButton** | Single-select | size, color, label, circular indicator |
| **FluxImage** | Image display | source (.system/.asset/.url), async loading, border, tap handler |
| **FluxShimmer** | Skeleton placeholder | shape (line/circle/rectangle), animated gradient, helpers |

### Molecules (10) — Atom Combinations

| Component | Description | Key Props |
|-----------|-------------|-----------|
| **FluxCard** | Surface container | padding, cornerRadius, shadow, generic content |
| **FluxTextField** | Text input | label, placeholder, isSecure, errorMessage, focus styling |
| **FluxListRow** | Navigation row | icon, title, subtitle, chevron, tap handler |
| **FluxAlertView** | Status banner | variant (info/success/warning/error), auto-icon, dismissible |
| **FluxInfoView** | Info display | icon, title, description, alignment (horizontal/vertical) |
| **FluxOptionCard** | Selection list | selectionMode (single/multi), options with icon/label/subtitle |
| **FluxExpandableView** | Collapsible section | style (card/plain/bordered), chevron animation |
| **FluxFlapView** | Tabbed container | style (underlined/filled/pill), tab icons, content builder |
| **FluxCardFlap** | 3D flip card | front/back content, 0.6s flip animation, tap toggle |
| **FluxBoxGrid** | Grid selection | columns, selectionMode (none/single/multi), itemSize, LazyVGrid |

### Organisms (5) — Screen-Level Patterns

| Component | Description | Key Props |
|-----------|-------------|-----------|
| **FluxHeader** | Top navigation bar | title, subtitle, leading/trailing action slots |
| **FluxBottomSheet** | Modal panel | detent (small 25%/medium 50%/large 85%), drag-to-dismiss |
| **FluxFormSection** | Form grouping | title, spacing, content wrapper |
| **FluxGraph** | Data visualization | chartType (bar/line/pie), data points, animated, colors |
| **FluxWebView** | Embedded browser | WKWebView (iOS), progress bar, error handling |

---

## Usage Examples

### Button

```swift
@StateObject var vm = FluxButtonViewModel(
    title: "Continue",
    variant: .primary,
    size: .large
) {
    print("Tapped!")
}

FluxButton(viewModel: vm)
```

### Text with Attributed Segments

```swift
FluxText(
    segments: [
        .init(text: "Welcome "),
        .init(text: "Afzal", style: .bold, color: FluxColors.primary),
        .init(text: ", check your ", style: .regular),
        .init(text: "dashboard", style: .underline),
    ],
    style: .body
)
```

### Alert View

```swift
@StateObject var alertVM = FluxAlertViewViewModel(
    variant: .success,
    title: "Payment Complete",
    message: "Your transaction was successful.",
    isDismissible: true
)

FluxAlertView(viewModel: alertVM)
```

### Bottom Sheet

```swift
@StateObject var sheetVM = FluxBottomSheetViewModel(
    title: "Select Option",
    detent: .medium,
    showHandle: true
)

FluxBottomSheet(viewModel: sheetVM) {
    VStack {
        FluxListRow(viewModel: option1VM)
        FluxListRow(viewModel: option2VM)
    }
}
```

### Graph

```swift
@StateObject var graphVM = FluxGraphViewModel(
    chartType: .bar,
    data: [
        FluxDataPoint(label: "Jan", value: 120),
        FluxDataPoint(label: "Feb", value: 200),
        FluxDataPoint(label: "Mar", value: 160),
    ],
    title: "Monthly Revenue",
    animate: true
)

FluxGraph(viewModel: graphVM)
```

---

## File Structure

```
flux-ios-foundation/
|-- Package.swift
|-- LICENSE
|-- README.md
+-- Sources/flux-ios-foundation/
    |-- flux_ios_foundation.swift       (module re-export)
    |-- Atoms/
    |   |-- FluxButton.swift
    |   |-- FluxText.swift
    |   |-- FluxIcon.swift
    |   |-- FluxLoader.swift
    |   |-- FluxDivider.swift
    |   |-- FluxCheckBox.swift
    |   |-- FluxToggle.swift
    |   |-- FluxSegmentedControl.swift
    |   |-- FluxRadioButton.swift
    |   |-- FluxImage.swift
    |   +-- FluxShimmer.swift
    |-- Molecules/
    |   |-- FluxCard.swift
    |   |-- FluxTextField.swift
    |   |-- FluxListRow.swift
    |   |-- FluxAlertView.swift
    |   |-- FluxInfoView.swift
    |   |-- FluxOptionCard.swift
    |   |-- FluxExpandableView.swift
    |   |-- FluxFlapView.swift
    |   |-- FluxCardFlap.swift
    |   +-- FluxBoxGrid.swift
    +-- Organisms/
        |-- FluxHeader.swift
        |-- FluxBottomSheet.swift
        |-- FluxFormSection.swift
        |-- FluxGraph.swift
        +-- FluxWebView.swift
```

---

## License

MIT License - Copyright (c) 2026 Afzal Siddiqui
