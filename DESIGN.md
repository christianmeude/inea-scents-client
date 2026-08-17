---
name: Inea Scents
description: A perfume bar service reservation system
colors:
  primary: "#6a4053"
  secondary: "#99868c"
  tertiary: "#c4acac"
  neutral-bg: "#fdf4f5"
  neutral-surface: "#ffffff"
  neutral-text: "#6a4053"
  semantic:
    success: "#22c55e"
    pending: "#eab308"
    unavailable: "#fca5a5"
    link: "#06b6d4"
typography:
  display:
    fontFamily: "Figtree, sans-serif"
    fontSize: "2rem"
    fontWeight: 700
  title:
    fontFamily: "Figtree, sans-serif"
    fontSize: "1.25rem"
    fontWeight: 600
  body:
    fontFamily: "Figtree, sans-serif"
    fontSize: "0.875rem"
    fontWeight: 400
rounded:
  md: "0.5rem"
  lg: "1rem"
  full: "9999px"
spacing:
  sm: "0.5rem"
  md: "1rem"
  lg: "1.5rem"
  xl: "2rem"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "#ffffff"
    rounded: "{rounded.full}"
    padding: "0.75rem 2rem"
  button-outline:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    rounded: "{rounded.full}"
    padding: "0.5rem 1rem"
  input-text:
    backgroundColor: "transparent"
    textColor: "{colors.primary}"
    rounded: "{rounded.lg}"
    padding: "0.75rem 1rem"
---

# Design System: Inea Scents

## Overview

**Creative North Star: "The Elegant Concierge"**

The visual system is warm, inviting, and graceful, heavily inspired by high-end cosmetic and perfume branding. It leans into a soft, romantic palette of plums, dusty roses, and warm creams. The interface balances structural elegance with a mix of soft rounded rectangles for data entry, and highly tactile pill shapes for actions.

**Key Characteristics:**
- **Soft geometries:** Extensive use of pill shapes for actions, and soft rounded rectangles (8-12px) for inputs and cards.
- **Monochromatic warmth:** UI elements, text, and borders all heavily utilize the primary Dark Plum color instead of harsh blacks or greys.
- **Ambient Depth:** Very soft drop shadows lift primary content cards, while sticky navigation elements utilize glassmorphism (translucency + background blur).
- **Semantic Clarity:** Statuses use clear, bright semantic colors (green, yellow, red) as pill-shaped tags to stand out against the warm, muted palette.

## Colors

The palette is derived directly from the brand's floral and cosmetic inspiration.

### Primary & Structural
- **Dark Plum** (#6a4053): The anchor of the system. Used for logos, primary text, active states, solid buttons, icons, and delicate structural borders.
- **Muted Plum** (#99868c): Used for secondary backgrounds and translucent layers.

### Backgrounds
- **Light Cream** (#fdf4f5): The primary background color for the application shell, providing a warm alternative to stark white.
- **Surface White** (#ffffff): Used for content cards (like the calendar component or product cards) to contrast against the cream background.

### Semantic
- **Success (Green):** Used for "Confirmed" or "Payment Successful".
- **Pending (Yellow):** Used for pending states.
- **Unavailable (Red):** Used for "Marked as Unavailable".
- **Link (Cyan/Blue):** Used for actionable text links like "View Details" in tables.

**The No-Black Rule.** Pure black is avoided. Text, icons, and structural lines use Dark Plum to maintain the soft, warm aesthetic.

## Typography

**Display/Logo Sans:** Josefin Sans (Bold, 700) - Used for "INEA".
**Display/Logo Script:** Great Vibes (Regular, 400) - Used for "Scents".
**Body Font:** Figtree (with system sans-serif)

### Hierarchy
- **Title** (600, 1.25rem): Page and section headers, always rendered in Dark Plum.
- **Body** (400, 0.875rem): General UI text.

## Layout & Elevation

The layout is generous and airy. 

**Ambient Shadows.** The primary white macro-cards (like "Total Bookings", "Order Details") feature very soft, diffused drop shadows to lift them gently off the Light Cream background.

**Glassmorphism.** Sticky or floating UI elements, such as the mobile bottom navigation bar, use a translucent plum background paired with a backdrop blur filter (`backdrop-blur`), allowing the content underneath to softly show through.

## Shapes & Components

Forms and actions have distinct, deliberate shapes.

### Buttons & Tags (The Pill Rule)
- **Shape:** Fully rounded / pill-shaped (`border-radius: 9999px`).
- **Primary Buttons:** Solid Dark Plum background with white text ("Next", "Modify").
- **Tags:** Small pill shapes used for statuses (e.g., green background for "Booked").

### Inputs & Forms (The Soft Rectangle)
- **Shape:** Soft rounded corners (approx 8px to 12px radius, `rounded-lg`).
- **Style:** Text inputs, search bars, and form textareas are *not* pills. They are standard rounded rectangles, often with a thin grey or Dark Plum border.

### Cards & Modals
- **Corner Style:** Large 16px to 24px radius (`rounded-2xl` or `rounded-3xl`).
- **Data Rows:** Inside modals and tables, rows of data alternate backgrounds, and the background highlight itself is often pill-shaped, creating a very soft, cushioned feel for the data.

## Do's and Don'ts

### Do:
- **Do** use pill shapes (`rounded-full`) for all buttons and status tags.
- **Do** use soft rounded rectangles (`rounded-lg`) for text inputs and search bars.
- **Do** use Dark Plum (#6a4053) for primary text and headings instead of black or dark grey.
- **Do** use ambient, soft drop shadows for main white cards.
- **Do** use glassmorphism (`bg-opacity` + `backdrop-blur`) for sticky navigation bars.

### Don't:
- **Don't** use sharp corners for any element.
- **Don't** use pill shapes for standard text inputs or textareas; reserve pills for actions (buttons) and metadata (tags).
- **Don't** use pure black or stark dark greys.
