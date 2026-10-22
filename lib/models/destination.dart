/// A popular place to see inside a destination.
///
/// [image] can be an asset path ('assets/images/x.jpg'), a web link, or just
/// a search phrase (e.g. 'Hawa Mahal') which is looked up on Wikipedia.
class Attraction {
  final String name;
  final String image;
  final String about; // one short line
  const Attraction(this.name, this.image, this.about);
}

/// A local dish worth trying.
class Food {
  final String name;
  final String image;
  final String about;
  const Food(this.name, this.image, this.about);
}

/// A recommended place to stay.
class Stay {
  final String name;
  final String type; // e.g. Luxury resort, Budget hostel
  final double rating; // approximate Google review score out of 5
  final int pricePerNight; // approximate starting price in rupees
  final String mapQuery; // text used to find it on Google Maps
  const Stay(this.name, this.type, this.rating, this.pricePerNight, this.mapQuery);
}

/// One travel destination shown in the app.
class Destination {
  final String id;
  final String name;
  final String location;
  final String category;
  final String image;
  final String description;
  final String bestTime;
  final int costPerPersonPerDay; // rough budget in rupees
  final int idealDays; // how long a good trip takes
  final String mapQuery; // text used for Google Maps
  final List<Attraction> attractions;
  final List<Food> foods;
  final List<Stay> stays;

  const Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.image,
    required this.description,
    required this.bestTime,
    required this.costPerPersonPerDay,
    required this.idealDays,
    required this.mapQuery,
    required this.attractions,
    required this.foods,
    required this.stays,
  });
}

/// A trip the user has planned for a destination.
class TripPlan {
  final DateTime start;
  final DateTime end;
  final int travelers;

  const TripPlan({required this.start, required this.end, required this.travelers});

  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
        'travelers': travelers,
      };

  factory TripPlan.fromJson(Map<String, dynamic> json) => TripPlan(
        start: DateTime.parse(json['start'] as String),
        end: DateTime.parse(json['end'] as String),
        travelers: json['travelers'] as int,
      );
}
