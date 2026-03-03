# PhiaUI Samples

This repository contains sample applications and demonstrations showcasing the [PhiaUI](https://github.com/charlenopires/phiaui) component library for Phoenix LiveView.

## Overview

The main demo application is a **Dashboard** interface that illustrates how to integrate and use various `PhiaUI` components in a real-world scenario. The dashboard includes the following views:

- **Overview**: A general summary dashboard.
- **Analytics**: Data visualization and metric components.
- **Users**: Table and list representations of users.
- **Orders**: Transaction and order management views.

These examples provide a practical reference for building modern, responsive user interfaces with Elixir, Phoenix LiveView, and Tailwind CSS.

## Prerequisites

Before running the sample, ensure you have the following installed:

- Elixir (~> 1.15)
- Erlang/OTP
- Node.js (optional, for some asset processing)

The sample relies on the `PhiaUI` library, which is included as a standard dependency. No local clone is required unless you plan to modify `PhiaUI` directly by overriding the path in `mix.exs`.

## Getting Started

To run the sample application locally:

1. Clone this repository:
   ```bash
   git clone https://github.com/charlenopires/PhiaUI-samples.git
   cd PhiaUI-samples
   ```

2. Install and setup dependencies:
   ```bash
   mix setup
   ```

3. Start the Phoenix endpoint:
   ```bash
   mix phx.server
   ```
   *Or, run it interactively with IEx:* `iex -S mix phx.server`

4. Open your browser and navigate to [`localhost:4000`](http://localhost:4000) to see the application in action.

## Project Structure

This is a standard Phoenix 1.8.x application. Key areas of interest include:

- `lib/phia_demo_web/live/`: Contains the LiveView modules for the dashboard (`Overview`, `Analytics`, `Users`, `Orders`).
- `lib/phia_demo_web/live/components/`: Contains shared dashboard layout components.

## Learn More

- [Phoenix Framework Official Website](https://www.phoenixframework.org/)
- [Phoenix LiveView Guides](https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html)
- [Tailwind CSS Documentation](https://tailwindcss.com/docs)
