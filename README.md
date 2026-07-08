# Color Explorer

A Flutter application demonstrating a **Package-Based Architecture** (Monorepo) to build modular, maintainable, and scalable applications. This project serves as a practical implementation and learning resource for decoupling design systems from feature modules.

## Architecture Overview

This project adopts a modular, package-based architecture to enforce a strict separation of concerns. By splitting the codebase into independent packages, we ensure that UI components and design tokens are highly reusable and isolated from the application's business logic.

```
┌────────────────────────────────────────────────────────┐
│                      Main App                          │
│                  (color_explorer)                      │
│  - State Management (ColorExplorerNotifier)            │
│  - Feature Screens (ColorExplorerScreen)               │
│  - Platform-specific Sound Helpers                     │
└───────────────────────────┬────────────────────────────┘
                            │
                            ▼
┌────────────────────────────────────────────────────────┐
│                   packages/design_system               │
│  - Design Tokens (ColorTokens)                         │
│  - Atomic UI Components (ColorStrip)                   │
└────────────────────────────────────────────────────────┘
```

### 1. Main Application (`color_explorer`)
Located in the root directory, this is the orchestrator of the application.
- **State Management** \
Uses `ColorExplorerNotifier` (extending `ChangeNotifier`) to manage the active color state and notify listeners.
- **Feature Presentation** \
Contains `ColorExplorerScreen` and `ScrollEffectItem` which handle the infinite scrolling list and visibility tracking.
- **Platform-Specific Helpers** \
Implements a cross-platform sound utility using conditional imports to play throttled system sounds on Native (Android/iOS/Desktop) and Web.

### 2. Design System (`packages/design_system`)
Located in `packages/design_system`, this is a standalone Dart/Flutter package.
- **Design Tokens** \
Defines the core color palette (`ColorTokens.rainbow`) and utility methods to generate smooth HSV spectrums.
- **Atomic Components** \
Contains reusable, stateless UI components like `ColorStrip` that are completely decoupled from the application's state.

## Key Features

- **Infinite Scroll** \
A seamless, infinite list of colors generated dynamically across the HSV spectrum.
- **Dynamic Theme Interpolation** \
Smoothly interpolates between adjacent colors based on the scroll position, dynamically updating the global application theme in real-time.
- **Cross-Platform Audio Feedback** \
Plays a throttled click/beep sound when color strips scroll off-screen. Uses conditional compilation to support both Web Audio API and Native System Sounds.
- **Strict Code Quality** \
Enforces high-quality code standards using static analysis rules from `very_good_analysis`.

## Project Structure

```text
.
├── lib/
│   ├── main.dart                           # Application entry point & dependency injection
│   ├── color_explorer.dart                 # Feature library export file
│   └── src/
│       └── presentation/
│           ├── color_explorer_notifier.dart # State management
│           ├── color_explorer_screen.dart   # Main feature screen
│           ├── scroll_effect_item.dart      # Visibility tracker for sound effects
│           └── sound_helper/                # Cross-platform audio utilities
│               ├── sound_helper.dart        # Conditional export bridge
│               ├── sound_helper_native.dart # Native implementation
│               ├── sound_helper_stub.dart   # Fallback stub
│               └── sound_helper_web.dart    # Web Audio API implementation
├── packages/
│   └── design_system/                       # Standalone Design System package
│       ├── lib/
│       │   ├── design_system.dart           # Package export file
│       │   └── src/
│       │       ├── components/
│       │       │   └── color_strip.dart     # Atomic UI component
│       │       └── tokens/
│       │           └── color_tokens.dart    # Color tokens & spectrum generator
│       └── pubspec.yaml
├── pubspec.yaml                             # Root pubspec
└── README.md
```

## Getting Started

### Prerequisites

- Flutter SDK (compatible with the environment constraints in `pubspec.yaml`)
- Dart SDK

### Installation

1. Clone the repository:
   ```bash
   git clone <your-repository-url>
   cd color_explorer
   ```

2. Bootstrap the project and fetch dependencies for all packages:
   ```bash
   flutter pub get
   ```

3. Run static analysis to ensure code quality:
   ```bash
   flutter analyze
   ```

4. Run the application:
   ```bash
   flutter run
   ```
