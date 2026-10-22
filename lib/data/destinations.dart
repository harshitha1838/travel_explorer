import '../models/destination.dart';

/// All app content lives here.
///
/// Every `image` is a search phrase that the app looks up on Wikipedia at
/// runtime (see services/image_service.dart). To use your own photo instead,
/// put it in assets/images/ and write 'assets/images/yourfile.jpg'.
///
/// Stay ratings are approximate Google review scores. Tapping the map button
/// in the app opens Google Maps where live ratings are shown.
const categories = ['All', 'Beaches', 'Mountains', 'Heritage', 'Adventure'];

const List<Destination> destinations = [
  Destination(
    id: 'goa',
    name: 'Goa',
    location: 'Goa, India',
    category: 'Beaches',
    image: 'Baga Beach Goa',
    description:
        'Golden beaches, lively nightlife, old Portuguese churches and delicious seafood.',
    bestTime: 'November to February',
    costPerPersonPerDay: 3500,
    idealDays: 4,
    mapQuery: 'Goa, India',
    attractions: [
      Attraction('Baga Beach', 'Baga Beach Goa', 'Water sports by day, beach shacks and music at night.'),
      Attraction('Fort Aguada', 'Fort Aguada', '17th-century Portuguese fort with a lighthouse and sea views.'),
      Attraction('Dudhsagar Falls', 'Dudhsagar Falls', 'A four-tier waterfall in the forest, best after the monsoon.'),
    ],
    foods: [
      Food('Goan Fish Curry', 'Goan fish curry', 'Tangy coconut and kokum curry served with rice.'),
      Food('Bebinca', 'Bebinca', 'Layered dessert made with coconut milk and ghee.'),
      Food('Prawn Balchão', 'Balchão', 'Spicy, tangy prawn masala that keeps for days.'),
    ],
    stays: [
      Stay('Taj Fort Aguada Resort & Spa', 'Luxury resort', 4.5, 20000, 'Taj Fort Aguada Resort & Spa, Goa'),
      Stay('Zostel Goa', 'Budget hostel', 4.3, 800, 'Zostel Goa Anjuna'),
    ],
  ),
  Destination(
    id: 'andaman',
    name: 'Andaman & Nicobar',
    location: 'Andaman Islands',
    category: 'Beaches',
    image: 'Radhanagar Beach',
    description:
        'Clear blue water, white sand and coral reefs for a calm island holiday.',
    bestTime: 'October to May',
    costPerPersonPerDay: 5000,
    idealDays: 6,
    mapQuery: 'Andaman and Nicobar Islands, India',
    attractions: [
      Attraction('Radhanagar Beach', 'Radhanagar Beach', 'One of Asia\'s best beaches, famous for sunsets.'),
      Attraction('Cellular Jail', 'Cellular Jail', 'Historic colonial prison with an evening light show.'),
      Attraction('Ross Island', 'Ross Island Andaman', 'Ruins of a British settlement taken over by trees.'),
    ],
    foods: [
      Food('Grilled Lobster', 'Grilled lobster', 'Fresh catch grilled with butter and garlic.'),
      Food('Coconut Prawn Curry', 'Prawn curry', 'Creamy island-style curry with fresh prawns.'),
      Food('Tender Coconut', 'Coconut water', 'Cool, sweet and sold on every beach.'),
    ],
    stays: [
      Stay('Taj Exotica Resort & Spa', 'Luxury beach resort', 4.6, 25000, 'Taj Exotica Resort & Spa Andamans'),
      Stay('Welcomhotel Bay Island', 'Sea-view hotel', 4.2, 8000, 'Welcomhotel by ITC Hotels Bay Island Port Blair'),
    ],
  ),
  Destination(
    id: 'manali',
    name: 'Manali',
    location: 'Himachal Pradesh',
    category: 'Mountains',
    image: 'Manali Himachal Pradesh',
    description:
        'A cool Himalayan town with snow, pine forests, hot springs and big views.',
    bestTime: 'March to June, December for snow',
    costPerPersonPerDay: 3000,
    idealDays: 5,
    mapQuery: 'Manali, Himachal Pradesh',
    attractions: [
      Attraction('Solang Valley', 'Solang Valley', 'Paragliding in summer, skiing and snow play in winter.'),
      Attraction('Hadimba Temple', 'Hadimba Temple', 'Wooden temple inside a quiet cedar forest.'),
      Attraction('Rohtang Pass', 'Rohtang Pass', 'High mountain pass with snow most of the year.'),
    ],
    foods: [
      Food('Siddu', 'Siddu', 'Steamed wheat bread stuffed with walnuts or poppy seeds.'),
      Food('Himachali Dham', 'Himachali Dham', 'Traditional festive meal of rice, dal and rajma.'),
      Food('Momos', 'Momo food', 'Hot steamed dumplings, perfect in cold weather.'),
    ],
    stays: [
      Stay('Span Resort & Spa', 'Riverside resort', 4.3, 6000, 'Span Resort and Spa Manali'),
      Stay('Zostel Manali', 'Budget hostel', 4.4, 900, 'Zostel Manali'),
    ],
  ),
  Destination(
    id: 'jaipur',
    name: 'Jaipur',
    location: 'Rajasthan',
    category: 'Heritage',
    image: 'Jal Mahal Jaipur',
    description:
        'The Pink City: grand forts, royal palaces, colourful bazaars and Rajasthani food.',
    bestTime: 'October to March',
    costPerPersonPerDay: 3500,
    idealDays: 3,
    mapQuery: 'Jaipur, Rajasthan',
    attractions: [
      Attraction('Amber Fort', 'Amer Fort', 'Hilltop fort-palace reached by a winding climb.'),
      Attraction('Hawa Mahal', 'Hawa Mahal', 'The "Palace of Winds" with 953 small windows.'),
      Attraction('City Palace', 'City Palace Jaipur', 'Royal residence with museums and courtyards.'),
    ],
    foods: [
      Food('Dal Baati Churma', 'Dal baati churma', 'Baked wheat balls with spiced lentils and sweet crumble.'),
      Food('Pyaaz Kachori', 'Kachori', 'Crispy fried pastry with a spicy onion filling.'),
      Food('Ghewar', 'Ghewar', 'Honeycomb-shaped sweet, a Jaipur festival special.'),
    ],
    stays: [
      Stay('Rambagh Palace', 'Palace hotel', 4.8, 45000, 'Rambagh Palace Jaipur'),
      Stay('Hotel Pearl Palace', 'Budget heritage stay', 4.5, 2500, 'Hotel Pearl Palace Jaipur'),
    ],
  ),
  Destination(
    id: 'agra',
    name: 'Agra',
    location: 'Uttar Pradesh',
    category: 'Heritage',
    image: 'Taj Mahal',
    description:
        'Home of the Taj Mahal, plus Mughal forts, gardens and great street food.',
    bestTime: 'October to March',
    costPerPersonPerDay: 3000,
    idealDays: 2,
    mapQuery: 'Agra, Uttar Pradesh',
    attractions: [
      Attraction('Taj Mahal', 'Taj Mahal', 'White marble monument of love. Go at sunrise.'),
      Attraction('Agra Fort', 'Agra Fort', 'Massive red sandstone fort of the Mughal emperors.'),
      Attraction('Mehtab Bagh', 'Mehtab Bagh', 'Garden across the river with a calm view of the Taj.'),
    ],
    foods: [
      Food('Petha', 'Petha', 'Soft, translucent sweet made from ash gourd.'),
      Food('Bedai & Aloo Sabzi', 'Bedmi puri', 'Spicy fried bread with tangy potato curry for breakfast.'),
      Food('Agra Chaat', 'Chaat', 'Crunchy, tangy street snacks served in the old market.'),
    ],
    stays: [
      Stay('The Oberoi Amarvilas', 'Luxury palace hotel', 4.8, 55000, 'The Oberoi Amarvilas Agra'),
      Stay('Zostel Agra', 'Budget hostel', 4.4, 900, 'Zostel Agra'),
    ],
  ),
  Destination(
    id: 'rishikesh',
    name: 'Rishikesh',
    location: 'Uttarakhand',
    category: 'Adventure',
    image: 'Rishikesh',
    description:
        'River rafting, bungee jumping and camping by the Ganges, plus yoga and peaceful ghats.',
    bestTime: 'September to November, February to May',
    costPerPersonPerDay: 2500,
    idealDays: 3,
    mapQuery: 'Rishikesh, Uttarakhand',
    attractions: [
      Attraction('Laxman Jhula', 'Lakshman Jhula', 'Iconic suspension bridge over the Ganges.'),
      Attraction('Triveni Ghat', 'Triveni Ghat Rishikesh', 'Evening Ganga aarti on the riverbank.'),
      Attraction('Ganga Rafting', 'Whitewater rafting', 'White-water rapids for beginners and experts.'),
    ],
    foods: [
      Food('Chole Bhature', 'Chole bhature', 'Fluffy fried bread with spicy chickpea curry.'),
      Food('Kafuli', 'Kafuli', 'Garhwali green curry made with spinach and fenugreek.'),
      Food('Masala Chai', 'Masala chai', 'Spiced tea, best enjoyed by the river.'),
    ],
    stays: [
      Stay('Aloha on the Ganges', 'Riverside resort', 4.5, 4500, 'Aloha on the Ganges Rishikesh'),
      Stay('Zostel Rishikesh', 'Budget hostel', 4.4, 900, 'Zostel Rishikesh'),
    ],
  ),
];
