# Design System Master File (Web Adaptations)

> **LOGIC:** This document extends the core `DESIGN.md` definitions to provide web-specific structural guidelines (breakpoints, desktop interactions, max-widths). `DESIGN.md` remains the absolute source of truth for brand aesthetics.

---

**Project:** Inea Scents Web
**Category:** Elegant Perfume Bar Concierge

---

## 1. Core Visual Identity (Inherited from DESIGN.md)

### Color Palette

| Role | Hex | Variable |
|------|-----|--------------|
| Primary / Action | `#6a4053` | `--color-primary` (Dark Plum) |
| Secondary / Muted | `#99868c` | `--color-secondary` (Muted Plum) |
| Tertiary | `#c4acac` | `--color-tertiary` |
| Background (App Shell) | `#fdf4f5` | `--color-background` (Light Cream) |
| Surface (Cards/Modals) | `#ffffff` | `--color-surface` |
| Semantic Success | `#22c55e` | `--color-success` |
| Semantic Pending | `#eab308` | `--color-pending` |
| Semantic Error | `#fca5a5` | `--color-error` |

*Note: Pure black is strictly forbidden. Use Dark Plum (`#6a4053`) for primary text, icons, and borders.*

### Typography

- **Display/Logo (Sans):** Josefin Sans (Bold, 700)
- **Display/Logo (Script):** Great Vibes (Regular, 400)
- **Body Font:** Figtree (Regular 400, Semibold 600)

---

## 2. Web-Specific Spatial Rules

### Spacing & Layout Rhythm

| Token | Value | Usage |
|-------|-------|-------|
| `--space-sm` | `8px` | Icon gaps, tight grouping |
| `--space-md` | `16px` | Standard padding, inputs |
| `--space-lg` | `24px` | Card padding |
| `--space-xl` | `32px` | Section gaps |
| `--space-2xl` | `48px` | Generous whitespace |

### Shadows (Ambient Depth)

| Level | Value | Usage |
|-------|-------|-------|
| `--shadow-soft` | `0 4px 20px rgba(106, 64, 83, 0.05)` | Ambient lift for white macro-cards off the cream background |
| `--shadow-glass` | `0 2px 10px rgba(0, 0, 0, 0.05)` | Paired with `backdrop-blur` for sticky navigation |

---

## 3. Shapes & Components

### Buttons & Tags (The Pill Rule)
- **Shape:** Fully rounded / pill-shaped (`border-radius: 9999px`).
- **Primary Buttons:** Solid Dark Plum background with white text.
- **Hover State (Web):** Opacity 0.9 or slight brightness increase. NO heavy translation/elevation shifts. Ensure `SystemMouseCursors.click`.

### Inputs & Forms (The Soft Rectangle)
- **Shape:** Soft rounded corners (`8px - 12px` radius).
- **Style:** Transparent background, Dark Plum border.
- **Focus State (Web):** Must have a clear visible focus ring (e.g., 2px solid Dark Plum) for keyboard navigation.

---

## 4. Web Layout Scaffolding

### Responsive Breakpoints
- **Mobile (< 768px):** Single vertical stack. Bottom glassmorphism navigation.
- **Tablet (768px - 1024px):** 2-column layouts where applicable. Top glassmorphism navigation replaces bottom nav.
- **Desktop (> 1024px):** 3-column side-by-side split view. Max-width container of `1200px` centered on screen.

### Navigation (Desktop)
- Top Navigation Bar.
- Glassmorphism effect: translucent Muted Plum background + `backdrop-blur` filter.

---

## 5. Web Pre-Delivery Checklist

Before delivering web UI code, verify:
- [ ] No pure black or harsh greys used (use Dark Plum / Muted Plum).
- [ ] Buttons are pill-shaped; Inputs are soft-rounded rectangles.
- [ ] `SystemMouseCursors.click` on all clickable elements.
- [ ] Hover states use subtle color/opacity shifts (150-300ms transition) rather than layout-breaking scale transforms.
- [ ] Focus states are visible for keyboard accessibility.
- [ ] Responsive behavior matches the `<768px` (Mobile), `<1024px` (Tablet), and `>1024px` (Desktop) breakpoints.
- [ ] `PageTransitionsTheme` utilizes cross-fades for desktop web.
