# PocketPay

A Flutter mobile wallet app for peer-to-peer payments, built as a demo project.

## Features

- Phone/OTP authentication with MPIN setup
- Wallet with balance management
- Add money via Razorpay payment gateway
- Send money to contacts via phone number


## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3 (Dart) |
| Backend / Auth | Supabase |
| State Management | flutter_bloc |
| Payment Gateway | Razorpay |

## Getting Started

### Prerequisites

- Flutter SDK `^3.7.0`
- A [Supabase](https://supabase.com) project
- A [Razorpay](https://razorpay.com) account (test mode works)

### Setup

1. Clone the repo:
   ```bash
   git clone <repo-url>
   cd pocket_pay_demo
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Create a `.env` file in the project root:
   ```env
   SUPABASE_URL=your_supabase_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   RAZORPAY_KEY_ID=your_razorpay_key_id
   ```

4. Apply database migrations from `supabase/migrations/`.

5. Run the app:
   ```bash
   flutter run
   ```

## Project Structure

```
lib/
├── core/          # Routes, theme, shared utilities
└── features/      # Feature modules (auth, wallet, send_money, …)
    └── <feature>/
        ├── data/
        ├── domain/
        └── presentation/
```

Each feature follows a clean architecture slice: data → domain → presentation (BLoC/Cubit).
