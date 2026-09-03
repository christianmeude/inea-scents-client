# Product

<!-- impeccable:product-schema 1 -->

## Platform

multi-platform (web admin dashboard + adaptive mobile app + web landing page)

## Users

- **Customers**: End users seeking to book a personalized perfume bar experience via the mobile app.
- **Leads / Prospective Customers**: People discovering Inea Scents via the landing page, arriving via social media ads or organic search.
- **Admins**: Business owners or managers who operate the web dashboard to manage bookings, packages, inquiries, and settings.

## Product Purpose

A perfume bar service reservation system. Success means every date in the calendar is booked and every event garners excellent feedback and ratings. The landing page converts visitors into Inquiries; the mobile app turns Inquiries and direct sign-ups into Bookings.

## Positioning

Offers quality products and excellent service. It exudes elegance and grace, while being generous with the packages and services provided. The brand experience must feel like a "Concierge" -- helpful, anticipating needs, and flawless across every touchpoint.

## Operating Context

Three applications share a single backend and database:

- **Admin Dashboard** (Laravel + Inertia, `web`): Session-authenticated admin portal for managing bookings, packages, inquiries, and business settings. Hosted on Render.
- **Mobile App** (Flutter, `adaptive`): Native iOS/Android app for customers to browse packages, pick scents, check availability, and complete bookings. Communicates with the shared backend via OpenAPI-typed API.
- **Landing Page** (React + Vite, `web`): Marketing site for SEO, brand storytelling, and lead generation. Submits Inquiries via public API. Developer-maintained.

## Capabilities and Constraints

- The mobile app is built in Flutter and consumes the same backend API as the admin dashboard. Offline states, loading states, and form validations must be handled gracefully.
- The landing page must be highly performant, accessible, and SEO-optimized with near-instant load times.
- The backend must reliably serve both the admin web dashboard and the mobile API simultaneously.
- The landing page generates Inquiries; it does not create Bookings directly.

## Brand Commitments

- Core aesthetic values: Elegance and grace
- The experience must feel tactile, responsive, and deeply personal.
- Existing Facebook business page: https://www.facebook.com/profile.php?id=61580331093927

## Evidence on Hand

- Web dashboard prototypes (`backend: docs/design/web/`)
- Mobile app prototypes (`client: docs/design/mobile/`)
- Palette inspiration (`backend: docs/design/palette-inspo.png`)

## Product Principles

- **API First & Shared State**: The backend must seamlessly support both the web admin dashboard and the external mobile API with a strictly-typed OpenAPI contract.
- **Elegance in Utility**: Every interface -- admin, customer, and public -- should reflect the brand's core values of elegance and grace.
- **Frictionless Booking**: Every step from date selection to payment must feel effortless and explicitly clear.
- **Persuasion & Storytelling**: The landing page uses bold typography, high-quality imagery, and clear value propositions to convert visitors.
- **Clear Call-to-Action**: The next step for any visitor or user must always be obvious and highly tactile.
- **Performance is Polish**: Fast loads and smooth animations across all platforms. Jitter or lag breaks the illusion of premium quality.
- **Booking Efficiency**: Streamline booking and package management to help the business achieve a fully booked calendar.
