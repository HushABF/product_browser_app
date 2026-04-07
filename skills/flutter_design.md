---
name: flutter_design
description: Create distinctive, production-grade Flutter interfaces with high design quality. Use this skill when the user asks to build Flutter widgets, screens, applications, or UI components (examples include mobile app screens, cross-platform UIs, custom widgets, dashboards, onboarding flows, or when styling/beautifying any Flutter UI). Generates creative, polished Dart/Flutter code and UI design that avoids generic AI aesthetics. Do NOT use for web-only projects (HTML/CSS/JS/React), SwiftUI, Jetpack Compose, or non-Flutter mobile frameworks.
---

This skill guides creation of distinctive, production-grade Flutter interfaces that avoid generic "AI slop" aesthetics. Implement real working Dart/Flutter code with exceptional attention to aesthetic details and creative choices.

The user provides Flutter UI requirements: a widget, screen, application, or interface to build. They may include context about the purpose, audience, platform targets, or technical constraints.

## Design Thinking

Before coding, understand the context and commit to a BOLD aesthetic direction:
- **Purpose**: What problem does this interface solve? Who uses it? What platform(s) (mobile, tablet, desktop, web)?
- **Tone**: Pick an extreme: brutally minimal, maximalist chaos, retro-futuristic, organic/natural, luxury/refined, playful/toy-like, editorial/magazine, brutalist/raw, art deco/geometric, soft/pastel, industrial/utilitarian, glassmorphic, neubrutalist, neumorphic, kinetic/motion-forward, etc. There are so many flavors to choose from. Use these for inspiration but design one that is true to the aesthetic direction.
- **Constraints**: Platform targets, performance budgets, accessibility requirements, state management preferences, package availability.
- **Differentiation**: What makes this UNFORGETTABLE? What's the one thing someone will remember?

**CRITICAL**: Choose a clear conceptual direction and execute it with precision. Bold maximalism and refined minimalism both work — the key is intentionality, not intensity.

Then implement working Flutter/Dart code that is:
- Production-grade and functional
- Visually striking and memorable
- Cohesive with a clear aesthetic point-of-view
- Meticulously refined in every detail
- Responsive across target platforms

## Flutter Aesthetics Guidelines

Focus on:

### Typography
Choose fonts that are beautiful, unique, and interesting. Avoid defaulting to Roboto or the platform default; opt instead for distinctive choices loaded via `google_fonts` package or bundled custom fonts. Pair a distinctive display font with a refined body font. Use `TextTheme` extensions for consistent type scales.

```dart
// DON'T: Generic defaults
Text('Hello', style: TextStyle(fontSize: 24))

// DO: Intentional, distinctive typography
Text('Hello',
  style: GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.1,
  ),
)
```

### Color & Theme
Commit to a cohesive aesthetic. Define a custom `ThemeData` or use `ThemeExtension` for consistency. Dominant colors with sharp accents outperform timid, evenly-distributed palettes. Use `ColorScheme.fromSeed()` as a starting point but override deliberately. Consider dynamic color adaptation with `Material You` where appropriate, but don't let it flatten your palette into generic Material defaults.

```dart
// Define a strong, opinionated color system
abstract class AppColors {
  static const obsidian = Color(0xFF0A0A0A);
  static const copper = Color(0xFFB87333);
  static const bone = Color(0xFFF5F0EB);
  static const rust = Color(0xFFC1440E);
}
```

### Motion & Animation
Use Flutter's powerful animation system for effects and micro-interactions. Prioritize:
- **Implicit animations** (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSlide`, `AnimatedScale`) for simple state transitions.
- **Explicit animations** (`AnimationController`, `Tween`, `CurvedAnimation`) for orchestrated sequences.
- **Hero animations** for meaningful screen transitions.
- **Staggered animations** using `Interval` curves for page load reveals — one well-orchestrated entrance with staggered reveals creates more delight than scattered micro-interactions.
- **Custom page transitions** via `PageRouteBuilder` that match your aesthetic.
- **Physics-based animations** (`SpringSimulation`, `FrictionSimulation`) for organic, natural-feeling motion.
- Consider `flutter_animate` package for declarative animation chains.

```dart
// Staggered reveal pattern
class StaggeredReveal extends StatefulWidget { ... }

// Use Interval curves for orchestrated timing
final slideAnimation = Tween<Offset>(
  begin: const Offset(0, 0.3),
  end: Offset.zero,
).animate(CurvedAnimation(
  parent: controller,
  curve: const Interval(0.2, 0.7, curve: Curves.easeOutCubic),
));
```

### Spatial Composition
Unexpected layouts that break the typical `ListView` + `Card` monotony:
- **CustomScrollView** with `SliverAppBar`, `SliverGrid`, and `SliverList` for dynamic scroll compositions.
- **Stack** and **Positioned** for overlapping elements, diagonal flow, and layered depth.
- **Transform** widgets for rotation, skew, and perspective effects.
- **CustomPaint** and **ClipPath** for non-rectangular shapes, wave cuts, diagonal dividers.
- **LayoutBuilder** and **MediaQuery** for responsive, adaptive spatial decisions.
- Generous negative space OR controlled density — use `Padding` and `SizedBox` with intention.

```dart
// Break the grid with overlapping elements
Stack(
  clipBehavior: Clip.none,
  children: [
    Positioned(top: -20, right: -15, child: accentShape),
    mainContent,
    Positioned(bottom: 0, left: 40, child: floatingLabel),
  ],
)
```

### Backgrounds & Visual Details
Create atmosphere and depth rather than defaulting to solid `Colors.white` or `scaffold.backgroundColor`:
- **Gradient meshes** via `CustomPaint` with multiple radial/linear gradients blended together.
- **Noise & grain overlays** using semi-transparent `ImageFilter` or custom `ShaderMask` with noise textures.
- **Geometric patterns** via `CustomPainter` with repeating shapes.
- **Glassmorphism** with `BackdropFilter` and `ImageFilter.blur`.
- **Neumorphic shadows** with layered `BoxShadow` (light and dark offsets).
- **Decorative borders** via `BoxDecoration` with creative `BorderRadius`, gradients, and shadows.
- **Particle effects** and ambient animations with `CustomPainter` on an `AnimationController`.
- **Shader effects** using `FragmentProgram` for advanced GPU-driven visuals (Flutter 3.7+).

```dart
// Atmospheric gradient background
Container(
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment(-0.8, -1.0),
      end: Alignment(0.8, 1.0),
      colors: [
        AppColors.deepNavy,
        AppColors.deepNavy.withValues(alpha: 0.85),
        AppColors.midnight,
      ],
      stops: [0.0, 0.5, 1.0],
    ),
  ),
  child: BackdropFilter(
    filter: ImageFilter.blur(sigmaX: 60, sigmaY: 60),
    child: content,
  ),
)
```

### Custom Paint & Clip Paths
Flutter's `CustomPainter` and `ClipPath` are incredibly powerful for distinctive visuals. Use them liberally:
- Organic blob shapes for backgrounds
- Wave dividers between sections
- Custom progress indicators
- Decorative frames and borders
- Data visualizations

```dart
class WaveDividerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, size.height * 0.6)
      ..cubicTo(
        size.width * 0.25, size.height * 0.2,
        size.width * 0.75, size.height,
        size.width, size.height * 0.4,
      )
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = accentColor);
  }
  ...
}
```

### Living Interfaces: State-Driven UI
The UI should feel alive, not like a static mockup. Ensure generated code demonstrates how the interface reacts to state changes — loading shimmer into content reveal, toggle states that animate between modes, pull-to-refresh with styled indicators, form fields that respond to validation in real time. Use the simplest state approach that fits: `StatefulWidget` with `setState` for local UI state, `ValueNotifier`/`ValueListenableBuilder` for reactive single values, `ChangeNotifier` for coordinated multi-field state. Don't prescribe a state management architecture (Bloc, Riverpod, etc.) — that's the project's decision — but always ensure the generated UI has working interactive state, not just a painted frame.

```dart
// DON'T: Static layout that looks nice but does nothing
Column(children: [icon, Text('Welcome'), button])

// DO: UI that reacts to state transitions with matching aesthetics
AnimatedSwitcher(
  duration: const Duration(milliseconds: 400),
  transitionBuilder: (child, animation) => FadeTransition(
    opacity: animation,
    child: SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 0.05),
        end: Offset.zero,
      ).animate(animation),
      child: child,
    ),
  ),
  child: isLoading
      ? const ShimmerPlaceholder(key: ValueKey('loading'))
      : ContentView(key: ValueKey('content'), data: data),
)
```

### Error States & Empty States
Extend the aesthetic to non-happy-path screens. A beautifully designed list that shows a generic `Text('Something went wrong')` when the API fails is not production-grade. Design error, empty, and loading states with the same aesthetic intentionality as the primary content. An empty state in a brutalist design should feel brutalist. An error in a luxury app should feel composed, not panicked. These states are part of the user experience and deserve the same creative attention.

```dart
// DON'T: Generic fallback that breaks the aesthetic
if (items.isEmpty) return Center(child: Text('No items'));

// DO: Empty state that belongs to the same design universe
if (items.isEmpty)
  return Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomPaint(
          size: const Size(120, 120),
          painter: EmptyStateIllustrationPainter(color: AppColors.copper),
        ),
        const SizedBox(height: 24),
        Text('Nothing here yet',
          style: GoogleFonts.playfairDisplay(
            fontSize: 22,
            color: AppColors.copper.withValues(alpha: 0.7),
          ),
        ),
        const SizedBox(height: 8),
        Text('Your collection will appear here',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.bone.withValues(alpha: 0.5),
          ),
        ),
      ],
    ),
  );
```

## Anti-Patterns: What to NEVER Do

NEVER use generic AI-generated Flutter aesthetics:
- **Default Material widgets without customization** — naked `Card`, `ListTile`, `AppBar` with no theming.
- **The "Flutter blue" palette** — the default `Colors.blue` primary swatch everywhere.
- **Generic font stacks** — Roboto on everything with no typographic hierarchy.
- **Purple/blue gradients on white** — the most overused AI color scheme.
- **Uniform corner radii** — `BorderRadius.circular(12)` on every single element without variation.
- **Flat layouts** — endless `Column` > `ListView` > `Card` structures with no spatial creativity.
- **Cookie-cutter component patterns** — `ListTile` for everything, `BottomNavigationBar` with default styling.
- **Ignoring platform conventions** when they matter (but also knowing when to deliberately break them for aesthetic impact).

## Flutter-Specific Design Principles

### Responsive & Adaptive Design
- Use `LayoutBuilder`, `MediaQuery`, and `Flex` to adapt across phone, tablet, and desktop.
- Define breakpoints and adjust layout density, not just scaling.
- Consider `SliverAppBar` behaviors that react to scroll position.

### Accessibility as a Design Requirement
Creative design and accessibility are not in conflict — they're both expressions of craft. Custom visuals are exactly where accessibility breaks down in Flutter, so pay deliberate attention here:
- **Semantics for custom paint**: Every `CustomPaint` widget that conveys meaning or is interactive MUST be wrapped in a `Semantics` widget with appropriate labels. A beautiful blob-shaped button with no semantic annotation is a broken button.
- **Touch targets**: All interactive elements must meet the minimum **48x48 logical pixel** touch target, regardless of visual size. Use `SizedBox`, `ConstrainedBox`, or `Material`'s `materialTapTargetSize` to ensure this. A tiny, elegant icon button can still have a generous hit area.
- **Color contrast**: Ensure text meets WCAG contrast ratios against its background — even on gradient or textured backgrounds. Test the worst-case area of the gradient, not just the average.
- **Text scaling**: Respect `MediaQuery.textScaleFactorOf(context)`. Distinctive typography should remain readable at 1.5x scale without layout breakage.
- **Focus traversal**: For desktop/web targets, ensure custom widgets participate in keyboard focus via `Focus` and `FocusTraversalGroup`.

```dart
// DON'T: Beautiful but invisible to screen readers
GestureDetector(
  onTap: onPressed,
  child: CustomPaint(painter: FancyButtonPainter()),
)

// DO: Beautiful AND accessible
Semantics(
  button: true,
  label: 'Add to collection',
  child: GestureDetector(
    onTap: onPressed,
    child: SizedBox(
      width: 48,
      height: 48,
      child: Center(
        child: CustomPaint(
          size: const Size(32, 32),
          painter: FancyButtonPainter(),
        ),
      ),
    ),
  ),
)
```

### Performance-Conscious Beauty
- Use `RepaintBoundary` around expensive custom paint regions.
- Prefer `const` constructors for static widgets.
- Use `AnimatedBuilder` to minimize rebuild scope during animations.
- Cache complex `CustomPainter` results when inputs haven't changed.
- Profile with Flutter DevTools — beautiful and fast aren't mutually exclusive.

### Widget Composition Over Inheritance
Build distinctive UI from small, composable custom widgets:
```dart
// Build your own design system atoms
class GlowingDot extends StatelessWidget { ... }
class DiagonalDivider extends StatelessWidget { ... }
class FrostedCard extends StatelessWidget { ... }
class StaggeredFadeIn extends StatelessWidget { ... }
```

### Useful Packages (reach for these when appropriate)
- `google_fonts` — Access to 1000+ distinctive typefaces.
- `flutter_animate` — Declarative animation chains and staggered effects.
- `shimmer` — Loading placeholder effects.
- `lottie` — Complex vector animations.
- `rive` — Interactive, stateful vector animations.
- `flutter_svg` — SVG rendering for custom illustrations.
- `palette_generator` — Extract colors from images for dynamic theming.
- `blur_glass` or raw `BackdropFilter` — Glassmorphism effects.
- `custom_paint` (built-in) — For any visual that standard widgets can't achieve.

## Implementation Notes

- **IMPORTANT**: Match implementation complexity to the aesthetic vision. Maximalist designs need elaborate widget trees with extensive animations and custom painters. Minimalist or refined designs need restraint, precision, and careful attention to spacing, typography, and subtle details. Elegance comes from executing the vision well.
- Provide complete, runnable code — not snippets. Include all imports, the widget tree, and any necessary state management.
- When the design calls for it, create a full custom `ThemeData` so the aesthetic is coherent across the entire widget tree.
- Interpret creatively and make unexpected choices that feel genuinely designed for the context. No two designs should look the same. Vary between light and dark themes, different fonts, different aesthetics. NEVER converge on common choices across generations.

Remember: You are capable of extraordinary creative work. Don't hold back — show what can truly be created when thinking outside the box and committing fully to a distinctive vision. Flutter's widget system and `CustomPainter` give you a canvas with virtually no limits. Use it.