# Travel Explorer

A Flutter app to discover destinations across India, save favourites and plan trips.
Theme: a warm "travel journal" look with a colour and emoji per category, in light and dark mode.

## Core features
- Destination list with photo, name, location, category, short description and best time to visit
- Search by name and filter by category (Beaches, Mountains, Heritage, Adventure)
- Details page: description, best time, 3 popular attractions with photos and names
- Wishlist: add / remove, updates instantly, saved after restart

## Extra features
- **Must-try food** for every destination, with photos
- **Where to stay**: recommended hotels with Google review ratings and a Google Maps button
- **Google Maps** link for every destination and stay
- **Trip planner** with photo banner: dates, travellers, budget estimate, countdown on the wishlist
- **Trip Matcher**: pick travel style, budget and trip length to get ranked suggestions
- **Light / Dark / Auto theme**, remembered between launches

## Run
```
flutter pub get
flutter run -d chrome
```

## How photos work
Photos are found at runtime from Wikipedia's free search API (`lib/services/image_service.dart`),
using the phrase written next to each place in `lib/data/destinations.dart`.
You can also use your own file: put it in `assets/images/` and write `'assets/images/name.jpg'`.

## Structure
- `lib/main.dart` app start, theme switching and bottom navigation
- `lib/theme.dart` colours and fonts for light and dark
- `lib/models/` data classes
- `lib/data/` all destination content
- `lib/services/` app state + local storage, photo lookup
- `lib/screens/` Home, Details, Matcher, Wishlist
- `lib/widgets/` card, image and header widgets

## Screenshots
(add yours here)
