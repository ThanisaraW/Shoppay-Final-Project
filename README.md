# Shopee Clone - Flutter App

A complete Shopee clone built with Flutter, replicating the UI and functionality of the real Shopee app.

## 📁 Project Structure

```
lib/
├── main.dart                      # App entry point
├── routes/
│   └── app_router.dart            # GoRouter navigation config
├── screens/
│   ├── main_navigation_screen.dart # Bottom nav shell
│   ├── home_screen.dart           # Home screen (placeholder)
│   ├── categories_screen.dart     # Categories screen
│   ├── notifications_screen.dart  # Notifications screen
│   ├── profile_screen.dart        # User profile screen
│   └── login_screen.dart          # Login/authentication screen
├── components/                    # Reusable UI components
│   ├── product_card.dart          # Product grid item
│   ├── search_bar.dart            # Search input widget
│   ├── category_tile.dart         # Category grid item
│   ├── rating_stars.dart          # Star rating display
│   ├── loading_shimmer.dart       # Skeleton loaders
│   ├── banner_carousel.dart       # Image carousel
│   ├── add_to_cart_button.dart    # Cart action button
│   └── empty_state.dart           # Empty list placeholder
├── models/
│   ├── user_model.dart            # User data model
│   ├── product_model.dart         # Product data model
│   ├── cart_item_model.dart       # Cart item model
│   ├── category_model.dart        # Category model
│   ├── order_model.dart           # Order model
│   └── banner_model.dart          # Banner/slide model
├── services/                      # Business logic layer
│   ├── auth_service.dart          # Firebase Authentication
│   ├── cart_service.dart          # Cart persistence
│   ├── product_service.dart       # Product data handling
│   └── category_service.dart      # Category data handling
├── providers/                     # Riverpod state management
│   ├── auth_provider.dart         # Auth state
│   ├── cart_provider.dart         # Cart state
│   ├── product_provider.dart      # Product state
│   └── category_provider.dart     # Category state
├── data/                          # Mock data (before Firebase)
│   ├── product_data.dart          # Sample products
│   ├── category_data.dart         # Sample categories
│   └── banner_data.dart           # Sample banners
└── utils/
    ├── app_theme.dart             # App colors & text styles
    ├── app_constants.dart         # Constants & config
    └── formatters.dart            # Currency, date formatters
```

## 🚀 Features Implemented

### ✅ Authentication
- Email/Password login via Firebase Auth
- Google Sign-In integration
- Facebook/Line/Apple sign-in UI (placeholders)
- Auto-redirect to login when accessing protected features
- Return to original page after login

### ✅ Navigation
- Bottom navigation with 4 tabs (Home, Categories, Notifications, Profile)
- GoRouter with route protection
- Deep linking support

### ✅ State Management
- Riverpod for all state
- Auth state management
- Cart state with local persistence
- Product and category providers

### ✅ Shopping Cart
- Add/remove items
- Update quantities
- Item selection
- Persist cart using SharedPreferences
- Works without login (local storage)

### ✅ UI Components
- Reusable product cards
- Search bar component
- Category tiles
- Rating stars
- Loading shimmers
- Banner carousel
- Empty states

### ✅ Data Layer
- Service classes for business logic
- Mock data for products, categories, banners
- Easy to swap with Firebase Firestore

## 🔧 Setup Instructions

### 1. Install Dependencies

```bash
flutter pub get
```

### 2. Firebase Setup

1. Create a Firebase project at https://console.firebase.google.com
2. Add your app (Android/iOS/Web)
3. Download `google-services.json` (Android) or `GoogleService-Info.plist` (iOS)
4. Place them in the correct directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`

5. Update `lib/main.dart` with your Firebase config:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

6. Run FlutterFire CLI to generate config:

```bash
flutter pub global activate flutterfire_cli
flutterfire configure
```

### 3. Enable Authentication Methods in Firebase

1. Go to Firebase Console → Authentication → Sign-in method
2. Enable:
   - Email/Password
   - Google
   - (Optional) Facebook, Apple

### 4. Run the App

```bash
flutter run
```

## 📱 Current App Flow

1. **Launch**: App starts on Home screen (browsing allowed without login)
2. **Browse**: Users can view products, categories, search
3. **Add to Cart**: Triggers login redirect if not authenticated
4. **Login**: User logs in, redirected back to original screen
5. **Cart**: Persists locally using SharedPreferences
6. **Profile**: Requires authentication, shows user info

## 🎨 UI Guidelines

- **Shopee Orange**: `#EE4D2D` (primary color)
- **Font**: Roboto
- **Components**: All reusable components in `lib/components/`
- **Thai Language**: Most UI text is in Thai to match Shopee Thailand

## 🔄 Next Steps

Upload Shopee UI screenshots and I will:

1. Build pixel-perfect screens matching the designs
2. Extract all repeated UI elements into reusable components
3. Implement full product listing, detail screens
4. Add cart screen with checkout flow
5. Build search functionality
6. Create category browsing
7. Add order history
8. Implement notifications

## 📝 Notes

- All `// TODO: Connect to Firebase` comments mark where mock data should be replaced
- Services use mock delays (`Future.delayed`) to simulate API calls
- Auth redirects preserve the intended destination using query parameters
- Cart works offline and syncs when connected (future enhancement)

## 🛠 Technologies

- Flutter 3.0+
- Riverpod (State Management)
- GoRouter (Navigation)
- Firebase Auth
- Cloud Firestore (ready to use)
- SharedPreferences (local storage)
- Shimmer, Carousel Slider, Smooth Page Indicator

---

**Ready for UI screenshots to build complete screens!**