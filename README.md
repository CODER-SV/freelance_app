# Nescafe_App

A fully functional food ordering app designed for seamless restaurant-to-customer interaction. It allows users to browse menu items, add to cart, place orders, and complete payments securely using Cashfree.

---

## 🌐 Live Website

👉 [https://coder-sv.github.io/freelance_app](https://coder-sv.github.io/freelance_app)

> This site hosts the required RBI-mandated policy documents for payment gateway verification.

---

## 🍽️ Features

- 🔍 Browse food items by category
- 🛒 Add to cart & modify quantities
- 📦 Place orders with real-time status updates (accepted, declined)
- 💳 Cashfree Payment Gateway Integration
- ⏱️ Order confirmation timer
- 📄 Policy Pages: Terms, Refund, Contact (for Cashfree/RBI compliance)

---

## 📄 Required Policies

As per RBI guidelines for accepting online payments, this app includes:

- [Terms and Conditions](https://coder-sv.github.io/freelance_app/terms-and-conditions.html)
- [Refund and Cancellation](https://coder-sv.github.io/freelance_app/refund-and-cancellation.html)
- [Contact Us](https://coder-sv.github.io/freelance_app/contact-us.html)

All policy documents were generated and converted from PDF to HTML.

##Project Setup
lib/
├── Components/                  # Reusable UI components
│   ├── carousel.dart
│   ├── roundedButton.dart
│   └── sections.dart
│
├── provider/                    # State management
│   ├── cart_provider.dart
│   └── data_provider.dart
│
├── Screens/                     # All app screens
│   ├── cart_screen.dart
│   ├── customisation_screen.dart
│   ├── email_verification_screen.dart
│   ├── home_screen.dart
│   ├── loading_screen.dart
│   ├── login_screen.dart
│   ├── order_confirmation_screen.dart
│   ├── recent_order.dart
│   ├── sign_screens.dart
│   ├── splash_screen.dart
│   └── welcome_screen_first.dart
│
├── Constants.dart               # App-wide constants
└── main.dart                    # App entry point

