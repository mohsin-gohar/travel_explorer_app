import 'package:flutter/material.dart';

/// Colour used across the app (buttons, badges, highlights).
const Color kPrimaryColor = Color(0xFF00695C);

/// Entry point of the application.
void main() {
  runApp(const TravelExplorerApp());
}

// ============================================================================
//  SECTION 1 - ROOT WIDGET AND THEME
// ============================================================================

/// The root widget of the app. It only builds the MaterialApp and the theme.
class TravelExplorerApp extends StatelessWidget {
  const TravelExplorerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: kPrimaryColor),
        appBarTheme: const AppBarTheme(
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey.shade600),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: kPrimaryColor, width: 1.6),
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      // The home page of the app is the "Explore" screen.
      home: const ExploreScreen(),
    );
  }
}

// ============================================================================
//  SECTION 2 - THE DESTINATION MODEL
// ============================================================================

/// A single destination shown in the app (the "model" of the assignment).
///
/// Everything is `final` and the constructor is `const`, so the whole list of
/// destinations can be declared as a `const List<Destination>`.
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.location,
    required this.category,
    required this.imageUrl,
    required this.rating,
    required this.price,
    required this.description,
    this.highlights = const <String>[],
    this.bestSeason = 'All year round',
  });

  /// Unique id - the favourites list stores these ids.
  final int id;

  /// Name of the place, e.g. "Machu Picchu".
  final String name;

  /// Country / region, e.g. "Cusco Region, Peru".
  final String location;

  /// One of the values inside [kCategories] (except "All").
  final String category;

  /// A full https image link shown on the cards and on the details screen.
  final String imageUrl;

  /// Average traveller rating, from 0.0 to 5.0.
  final double rating;

  /// Approximate price of the trip in US dollars.
  final int price;

  /// Long text displayed on the details screen.
  final String description;

  /// Short bullet points displayed on the details screen.
  final List<String> highlights;

  /// Best time of the year to visit this place.
  final String bestSeason;

  /// Helper: rating formatted as "4.8".
  String get ratingLabel => rating.toStringAsFixed(1);

  /// Helper: price formatted as "$890".
  String get priceLabel => '\$$price';

  /// Helper: an icon that matches the category (used on cards and chips).
  IconData get categoryIcon {
    switch (category) {
      case 'Mountains':
        return Icons.terrain;
      case 'Historical':
        return Icons.account_balance;
      case 'Nature':
        return Icons.forest;
      case 'Beach':
        return Icons.beach_access;
      case 'City':
        return Icons.location_city;
      default:
        return Icons.place;
    }
  }
}

// ============================================================================
//  SECTION 3 - APP CONSTANTS
// ============================================================================

/// The "All" filter value (means: do not filter by category).
const String kAllCategory = 'All';

/// The categories displayed as filter chips.
const List<String> kCategories = <String>[
  kAllCategory,
  'Mountains',
  'Historical',
  'Nature',
  'Beach',
  'City',
];

// ============================================================================
//  SECTION 4 - THE LOCAL DATA SOURCE (our fake API)
// -----------------------------------------------------------------------------
//  In a real app this list would come from a REST API. For this assignment we
//  read it from a local const list, and the Explore screen "fetches" it after a
//  short delay to simulate a real network request.
// ============================================================================

/// The local list of destinations used as the data source of the app.
const List<Destination> kDestinationData = <Destination>[
  Destination(
    id: 1,
    name: 'Machu Picchu',
    location: 'Cusco Region, Peru',
    category: 'Historical',
    imageUrl: 'https://images.unsplash.com/photo-1526392060635-9d6019884377?w=800&q=80',
    rating: 4.9,
    price: 890,
    description:
        'The famous Inca citadel built on a mountain ridge at 2,430 metres. It '
        'was built in the 15th century and was almost forgotten by the outside '
        'world until it was rediscovered in 1911. Today it is one of the New '
        'Seven Wonders of the World and one of the most visited tourist '
        'attractions on the planet.',
    highlights: <String>[
      'Sunrise over the terraces (early booking required)',
      'The 4 day Inca Trail that ends at the gate',
      'Guided walk through the Temple of the Sun',
    ],
    bestSeason: 'May to September',
  ),
  Destination(
    id: 2,
    name: 'Mount Everest Base Camp',
    location: 'Khumbu, Nepal',
    category: 'Mountains',
    imageUrl:
        'https://images.unsplash.com/photo-1544735716-392fe2489ffa?w=800&q=80',
    rating: 4.8,
    price: 1650,
    description:
        'The legendary base camp of the highest mountain on Earth, sitting at '
        '5,364 metres in the Khumbu region. Trekking here is a bucket list '
        'experience: you walk through Sherpa villages, monasteries and stunning '
        'glacier valleys before reaching the camp with a view of the summit.',
    highlights: <String>[
      'Trek through Sagarmatha National Park',
      'Visit the Tengboche monastery',
      'Sunrise view of the Khumbu icefall',
    ],
    bestSeason: 'March to May, October to November',
  ),
  Destination(
    id: 3,
    name: 'Santorini',
    location: 'Cyclades, Greece',
    category: 'Beach',
    imageUrl: 'https://images.unsplash.com/photo-1570077188670-e3a8d69ac5ff?w=800&q=80',
    rating: 4.8,
    price: 1100,
    description:
        'A volcanic island in the Aegean Sea famous for its white houses with '
        'blue domes, its dramatic caldera and its black sand beaches. Santorini '
        'is one of the most photographed islands in the world, especially at '
        'sunset in Oia.',
    highlights: <String>[
      'Sunset in Oia village',
      'Catamaran cruise around the caldera',
      'Wine tasting in the volcanic soil vineyards',
    ],
    bestSeason: 'May to October',
  ),
  Destination(
    id: 4,
    name: 'Serengeti Plains',
    location: 'Tanzania, Africa',
    category: 'Nature',
    imageUrl: 'https://images.unsplash.com/photo-1516426122078-c23e76319801?w=800&q=80',
    rating: 4.7,
    price: 2100,
    description:
        'One of the most famous wildlife areas in the world. Every year almost '
        'two million wildebeest, zebras and gazelles cross the plains in the '
        'Great Migration, followed by lions, cheetahs and hyenas. Game drives '
        'here are an unforgettable experience.',
    highlights: <String>[
      'Great Migration river crossings',
      'Big cat tracking with an expert guide',
      'Hot air balloon over the plains at sunrise',
    ],
    bestSeason: 'June to October',
  ),
  Destination(
    id: 5,
    name: 'Taj Mahal',
    location: 'Agra, India',
    category: 'Historical',
    imageUrl: 'https://images.unsplash.com/photo-1564507592333-c60657eea523?w=800&q=80',
    rating: 4.8,
    price: 320,
    description:
        'A white marble mausoleum built by the Mughal emperor Shah Jahan for '
        'his wife Mumtaz Mahal. It took around 22,000 workers and 20 years to '
        'build. The monument changes colour with the light of the sun, from '
        'pink in the morning to golden at sunset.',
    highlights: <String>[
      'Sunrise visit to catch the golden light',
      'The gardens of the Charbagh',
      'Nearby Agra Fort and the city of Fatehpur Sikri',
    ],
    bestSeason: 'October to March',
  ),
  Destination(
    id: 6,
    name: 'Swiss Alps Village',
    location: 'Zermatt, Switzerland',
    category: 'Mountains',
    imageUrl: 'https://images.unsplash.com/photo-1531366936337-7c912a4589a7?w=800&q=80',
    rating: 4.9,
    price: 1780,
    description:
        'A picture perfect mountain village in the Swiss Alps with wooden '
        'chalets, flower covered balconies and a direct view of the '
        'Matterhorn, the most photographed mountain in Europe. Skiing, hiking '
        'and scenic train journeys are all possible from the village centre.',
    highlights: <String>[
      'Gornergrat railway with Matterhorn views',
      'Ski slopes of the Matterhorn Glacier Paradise',
      'Hiking trails for every fitness level',
    ],
    bestSeason: 'December to March, June to September',
  ),
  Destination(
    id: 7,
    name: 'Kyoto Old Town',
    location: 'Kyoto, Japan',
    category: 'Historical',
    imageUrl: 'https://images.unsplash.com/photo-1493976040374-85c8e12f0c0e?w=800&q=80',
    rating: 4.7,
    price: 1450,
    description:
        'The former imperial capital of Japan is famous for thousands of '
        'temples, bamboo forests, tea houses and beautiful gardens. Kyoto was '
        'never destroyed during the wars, so its traditional wooden '
        'architecture is still perfectly preserved.',
    highlights: <String>[
      'Fushimi Inari shrine with its torii gates',
      'The bamboo forest of Arashiyama',
      'Geisha district walk in the evening',
    ],
    bestSeason: 'March to April, October to November',
  ),
  Destination(
    id: 8,
    name: 'Maldives Resorts',
    location: 'Male Atoll, Maldives',
    category: 'Beach',
    imageUrl: 'https://images.unsplash.com/photo-1514282401047-d79a71a590e8?w=800&q=80',
    rating: 4.9,
    price: 2400,
    description:
        'A tropical nation made of more than 1,000 islands scattered in the '
        'Indian Ocean. Overwater villas, white sand beaches, coral reefs and '
        'unlimited sunshine make it a perfect place for a relaxing luxury '
        'holiday.',
    highlights: <String>[
      'Overwater villa on a private island',
      'Snorkelling on the house reef',
      'Sunset dolphin cruise',
    ],
    bestSeason: 'November to April',
  ),

  Destination(
    id: 9,
    name: 'Grand Canyon',
    location: 'Arizona, USA',
    category: 'Nature',
    imageUrl: 'https://images.unsplash.com/photo-1474044159687-1ee9f3a51722?w=800&q=80',
    rating: 4.8,
    price: 480,
    description:
        'A 446 kilometre long and up to 1,857 metres deep canyon carved by the '
        'Colorado River over millions of years. Its layered red rocks change '
        'colour during the day, and the South Rim offers some of the most '
        'spectacular viewpoints in the United States.',
    highlights: <String>[
      'Sunrise at the South Rim (Mather Point)',
      'Hike the Bright Angel Trail',
      'Helicopter flight over the canyon',
    ],
    bestSeason: 'April to June, September to November',
  ),
  Destination(
    id: 10,
    name: 'Paris City Break',
    location: 'Paris, France',
    category: 'City',
    imageUrl: 'https://images.unsplash.com/photo-1502602898657-3e91760cbb34?w=800&q=80',
    rating: 4.6,
    price: 950,
    description:
        'The "City of Light" is a perfect short city break. Paris combines '
        'world famous museums, elegant boulevards, cafe culture and beautiful '
        'architecture, all connected by the famous underground metro.',
    highlights: <String>[
      'The Louvre museum and the Eiffel Tower',
      'A boat ride along the Seine river',
      'Montmartre and the Sacre-Coeur basilica',
    ],
    bestSeason: 'April to June, September to October',
  ),
  Destination(
    id: 11,
    name: 'New York Skyline',
    location: 'New York, USA',
    category: 'City',
    imageUrl: 'https://images.unsplash.com/photo-1496442226666-8d4d0e62e6e9?w=800&q=80',
    rating: 4.7,
    price: 1250,
    description:
        'The city that never sleeps: Manhattan skyscrapers, Broadway shows, '
        'Central Park, world class museums and neighbourhoods where every '
        'culture of the world is represented.',
    highlights: <String>[
      'Top of the Rock observation deck',
      'Walking tour of Central Park',
      'An evening in Times Square',
    ],
    bestSeason: 'April to June, September to December',
  ),
  Destination(
    id: 12,
    name: 'Bali Rice Terraces',
    location: 'Ubud, Indonesia',
    category: 'Nature',
    imageUrl: 'https://images.unsplash.com/photo-1537996194471-e657df975ab4?w=800&q=80',
    rating: 4.6,
    price: 780,
    description:
        'The island of Bali is famous for its emerald green rice terraces, '
        'wooden temples carved into the cliffs, tropical forests and warm '
        'beaches. Ubud, the cultural heart of the island, is surrounded by '
        'landscape terraces that are more than a thousand years old.',
    highlights: <String>[
      'Tegalalang and Jatiluwih rice terraces',
      'Sacred monkey forest sanctuary',
      'Sunset at the Tanah Lot temple',
    ],
    bestSeason: 'April to October',
  ),
];

// ============================================================================
//  SECTION 5 - EXPLORE SCREEN (HOME)
// -----------------------------------------------------------------------------
//  This StatefulWidget owns ALL the state of the app and refreshes the UI with
//  setState(). It shows: the search bar, the filter chips, the results (grid or
//  list), the loading state and the empty state.
// ============================================================================

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  // ----- Data state (filled by the simulated API call) -----
  final List<Destination> _destinations = <Destination>[];
  bool _isLoading = true;

  // True when the "API" failed -> the error state is displayed with a retry.
  bool _hasError = false;

  // Demo switch: when ON the "API" always fails, so the error state can be
  // shown to the teacher during the evaluation.
  bool _simulateError = false;

  // ----- Search / filter state -----
  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedCategory = kAllCategory;
  bool _showFavoritesOnly = false;

  // ----- Layout state (grid or list) -----
  bool _isGridView = true;

  // ----- Session-only favourites: we only store the ids of the liked items -----
  final Set<int> _favoriteIds = <int>{};

  @override
  void initState() {
    super.initState();
    // Call the "fake API" as soon as the screen appears.
    _loadDestinations();
  }

  @override
  void dispose() {
    // Good practice: dispose the controller to avoid memory leaks.
    _searchController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  //  DATA: simulate an API request with a 2 second delay.
  // --------------------------------------------------------------------------
  Future<void> _loadDestinations() async {
    // Show the loading state again (also used by the "Retry" button).
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    // This line makes the app behave as if the data was coming from a server.
    await Future<void>.delayed(const Duration(seconds: 2));

    // (mounted is checked because the user may have left the screen meanwhile.)
    if (!mounted) {
      return;
    }

    // Demo mode: pretend the server did not answer -> error state.
    if (_simulateError) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
      return;
    }

    // "The server answered" -> copy the local data into the state.
    setState(() {
      _destinations.addAll(kDestinationData);
      _isLoading = false;
    });
  }

  /// Turns the simulated error on / off and reloads the data.
  void _toggleSimulateError() {
    setState(() {
      _simulateError = !_simulateError;
    });
    _loadDestinations();
  }

  // --------------------------------------------------------------------------
  //  SEARCH + FILTER LOGIC
  // --------------------------------------------------------------------------

  /// Live search: called on every key stroke of the search bar.
  void _onSearchChanged(String value) {
    setState(() {
      _query = value;
    });
  }

  /// Filter chip (All / Mountains / Historical / ...) was tapped.
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
  }

  /// "Favourites" chip: show only the liked destinations.
  void _onFavoritesFilterToggled(bool selected) {
    setState(() {
      _showFavoritesOnly = selected;
    });
  }

  /// Clear the search text and go back to the "All" category.
  void _clearFilters() {
    _searchController.clear();
    setState(() {
      _query = '';
      _selectedCategory = kAllCategory;
      _showFavoritesOnly = false;
    });
  }

  /// The single place where the list of destinations to display is calculated.
  /// It applies: the category filter + the search filter + the favourites filter.
  List<Destination> get _visibleDestinations {
    final String search = _query.trim().toLowerCase();

    return _destinations.where((Destination destination) {
      // 1. Category filter
      final bool matchesCategory =
          _selectedCategory == kAllCategory ||
          destination.category == _selectedCategory;

      // 2. Search filter (by name OR by location)
      final bool matchesSearch =
          search.isEmpty ||
          destination.name.toLowerCase().contains(search) ||
          destination.location.toLowerCase().contains(search);

      // 3. Favourites filter
      final bool matchesFavorites =
          !_showFavoritesOnly || _favoriteIds.contains(destination.id);

      return matchesCategory && matchesSearch && matchesFavorites;
    }).toList();
  }

  // --------------------------------------------------------------------------
  //  FAVOURITES: temporary (session only) add / remove with a heart icon.
  // --------------------------------------------------------------------------
  void _toggleFavorite(Destination destination) {
    setState(() {
      if (_favoriteIds.contains(destination.id)) {
        _favoriteIds.remove(destination.id);
      } else {
        _favoriteIds.add(destination.id);
      }
    });
  }

  bool _isFavorite(Destination destination) =>
      _favoriteIds.contains(destination.id);

  // --------------------------------------------------------------------------
  //  NAVIGATION: open the details screen with Navigator.push.
  // --------------------------------------------------------------------------
  void _openDetails(Destination destination) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) => DestinationDetailScreen(
          destination: destination,
          isFavorite: _isFavorite(destination),
          onToggleFavorite: () => _toggleFavorite(destination),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // The filtered list is calculated once and reused by the whole build method.
    final List<Destination> visibleDestinations = _visibleDestinations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Travel Explorer'),
        actions: <Widget>[
          // Demo button: switch ON to show the ERROR state during evaluation.
          IconButton(
            onPressed: _toggleSimulateError,
            icon: Icon(
              _simulateError ? Icons.wifi_off_rounded : Icons.wifi_rounded,
            ),
            tooltip: _simulateError
                ? 'Simulated error is ON - tap to fix'
                : 'Simulate an API error',
          ),
          // Switch between the grid layout and the list layout.
          IconButton(
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
            icon: Icon(
              _isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded,
            ),
            tooltip: _isGridView ? 'Show as list' : 'Show as grid',
          ),
          // Shows how many destinations are in the favourites list.
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Center(
              child: Text(
                '♥ ${_favoriteIds.length}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          _buildSearchBar(),
          _buildCategoryChips(),
          _buildResultHeader(visibleDestinations.length),
          Expanded(child: _buildResults(visibleDestinations)),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------------
  //  WIDGET BUILDERS OF THE EXPLORE SCREEN
  // --------------------------------------------------------------------------

  /// The search bar. `onChanged` gives us the live (instant) search.
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
      child: TextField(
        controller: _searchController,
        onChanged: _onSearchChanged,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search by name or location...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: _query.isEmpty
              ? null
              : IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: _clearFilters,
                  tooltip: 'Clear',
                ),
        ),
      ),
    );
  }

  /// The horizontal row of filter chips (All, Mountains, Historical, ...).
  Widget _buildCategoryChips() {
    return SizedBox(
      height: 48,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: <Widget>[
          // Special chip used to display only the favourites.
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              avatar: Icon(
                _showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                size: 18,
                color: _showFavoritesOnly ? Colors.red : Colors.grey.shade700,
              ),
              label: const Text('Favourites'),
              selected: _showFavoritesOnly,
              onSelected: _onFavoritesFilterToggled,
            ),
          ),
          // One chip per category (generated from the kCategories list).
          ...kCategories.map(
            (String category) => Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(category),
                selected: _selectedCategory == category,
                onSelected: (bool _) => _onCategorySelected(category),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Small line that tells the user how many results are displayed.
  Widget _buildResultHeader(int resultCount) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 6, 18, 8),
      child: Row(
        children: <Widget>[
          Text(
            resultCount == 1 ? '1 destination' : '$resultCount destinations',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const Spacer(),
          if (_selectedCategory != kAllCategory)
            Text(
              'in $_selectedCategory',
              style: const TextStyle(color: kPrimaryColor, fontSize: 13),
            ),
        ],
      ),
    );
  }

  /// Decides what to show: loading, error, empty state, grid or list.
  Widget _buildResults(List<Destination> destinations) {
    // 1. Simulated API loading state.
    if (_isLoading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('Loading amazing destinations...'),
          ],
        ),
      );
    }

    // 2. API ERROR state: the request failed -> message + retry button.
    if (_hasError) {
      return _buildErrorState();
    }

    // 3. Empty state: the search or the filters returned nothing.
    if (destinations.isEmpty) {
      return _buildEmptyState();
    }

    // 4. Real results, shown as a grid or as a list.
    return _isGridView
        ? _buildDestinationsGrid(destinations)
        : _buildDestinationsList(destinations);
  }

  /// Shown when the "API" request fails. Offers a Retry button.
  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              Icons.wifi_off_rounded,
              size: 80,
              color: Colors.redAccent,
            ),
            const SizedBox(height: 16),
            const Text(
              'Something went wrong',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'We could not load the destinations.\n'
              'Please check your connection and try again.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _loadDestinations,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  /// Shown when no destination matches the current search / filters.
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              _showFavoritesOnly ? Icons.favorite_border : Icons.search_off,
              size: 80,
              color: kPrimaryColor.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 16),
            const Text(
              'No destinations found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              _showFavoritesOnly
                  ? 'You have no favourite destinations yet. '
                        'Tap the heart icon to add one!'
                  : 'Try another name, another location or another category.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _clearFilters,
              icon: const Icon(Icons.refresh),
              label: const Text('Reset filters'),
            ),
          ],
        ),
      ),
    );
  }

  /// RESPONSIVE GRID: 1 column on phones, 2 in medium width, 3+ on tablets.
  /// LayoutBuilder tells us the available width of the screen.
  Widget _buildDestinationsGrid(List<Destination> destinations) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        final int columns = _columnsForWidth(width);

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            // A fixed height is used instead of childAspectRatio: with a ratio
            // the cards would become extremely tall on wide screens.
            mainAxisExtent: _cardHeightFor(columns),
          ),
          itemCount: destinations.length,
          itemBuilder: (BuildContext context, int index) {
            final Destination destination = destinations[index];
            return _DestinationCard(
              destination: destination,
              isFavorite: _isFavorite(destination),
              onTap: () => _openDetails(destination),
              onToggleFavorite: () => _toggleFavorite(destination),
            );
          },
        );
      },
    );
  }

  /// Number of columns depending on the screen width (responsive design).
  int _columnsForWidth(double width) {
    if (width >= 1000) {
      return 3;
    }
    if (width >= 600) {
      return 2;
    }
    return 1;
  }

  /// Fixed height of the cards in the grid. Using a constant height (instead of
  /// a width/height ratio) keeps the layout stable on every screen size.
  double _cardHeightFor(int columns) {
    switch (columns) {
      case 1:
        return 300;
      case 2:
        return 260;
      default:
        return 250;
    }
  }

  /// LIST layout: one horizontal card per destination (better on wide screens).
  Widget _buildDestinationsList(List<Destination> destinations) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: destinations.length,
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 12),
      itemBuilder: (BuildContext context, int index) {
        final Destination destination = destinations[index];
        return _DestinationListTile(
          destination: destination,
          isFavorite: _isFavorite(destination),
          onTap: () => _openDetails(destination),
          onToggleFavorite: () => _toggleFavorite(destination),
        );
      },
    );
  }
}

// ============================================================================
//  SECTION 6 - REUSABLE WIDGETS (cards + small helpers)
// ============================================================================

/// Card used by the GridView: big image on top, information underneath.
class _DestinationCard extends StatelessWidget {
  const _DestinationCard({
    required this.destination,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Destination destination;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias, // image follows the rounded corners
      child: InkWell(
        onTap: onTap, // opens the details screen
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // ----- Image + gradient + category badge + heart -----
            Expanded(
              flex: 5,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _DestinationImage(url: destination.imageUrl),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.transparent, Colors.black45],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: _CategoryBadge(destination: destination),
                  ),
                  Positioned(
                    top: 4,
                    right: 4,
                    child: _FavoriteButton(
                      isFavorite: isFavorite,
                      onPressed: onToggleFavorite,
                    ),
                  ),
                ],
              ),
            ),
            // ----- Name, location, rating and price -----
            // NOTE: this part is NOT wrapped in an Expanded, so it always keeps
            // its natural height and the extra space goes to the image instead
            // of leaving a big empty gap under the text.
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    destination.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  _LocationRow(location: destination.location),
                  const SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      _RatingStars(rating: destination.ratingLabel),
                      const Spacer(),
                      Text(
                        destination.priceLabel,
                        style: const TextStyle(
                          color: kPrimaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Card used by the ListView: small image on the left, text on the right.
class _DestinationListTile extends StatelessWidget {
  const _DestinationListTile({
    required this.destination,
    required this.isFavorite,
    required this.onTap,
    required this.onToggleFavorite,
  });

  final Destination destination;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onToggleFavorite;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // ----- Thumbnail -----
              SizedBox(
                width: 110,
                height: 110,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: _DestinationImage(url: destination.imageUrl),
                ),
              ),
              const SizedBox(width: 12),
              // ----- Information -----
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            destination.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        _FavoriteButton(
                          isFavorite: isFavorite,
                          onPressed: onToggleFavorite,
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    _LocationRow(location: destination.location),
                    const SizedBox(height: 6),
                    _CategoryBadge(destination: destination),
                    const SizedBox(height: 8),
                    Row(
                      children: <Widget>[
                        _RatingStars(rating: destination.ratingLabel),
                        const Spacer(),
                        Text(
                          destination.priceLabel,
                          style: const TextStyle(
                            color: kPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Network image with a friendly placeholder (works even without internet).
class _DestinationImage extends StatelessWidget {
  const _DestinationImage({required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: BoxFit.cover,
      loadingBuilder:
          (BuildContext context, Widget child, ImageChunkEvent? progress) {
            // While the picture is downloaded we show a small spinner.
            if (progress == null) {
              return child;
            }
            return Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const CircularProgressIndicator(strokeWidth: 2),
            );
          },
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
            // If the image cannot be loaded (no internet, bad link...).
            return Container(
              color: kPrimaryColor.withValues(alpha: 0.12),
              alignment: Alignment.center,
              child: const Icon(
                Icons.landscape,
                size: 42,
                color: kPrimaryColor,
              ),
            );
          },
    );
  }
}

/// The heart icon used to add / remove a destination from the favourites.
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavorite, required this.onPressed});

  final bool isFavorite;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      tooltip: isFavorite ? 'Remove from favourites' : 'Add to favourites',
      icon: Icon(
        isFavorite ? Icons.favorite : Icons.favorite_border,
        color: isFavorite ? Colors.red : Colors.white,
        size: 24,
      ),
    );
  }
}

/// Small rounded badge showing the category with its icon.
class _CategoryBadge extends StatelessWidget {
  const _CategoryBadge({required this.destination});

  final Destination destination;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(destination.categoryIcon, size: 14, color: kPrimaryColor),
          const SizedBox(width: 4),
          Text(
            destination.category,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

/// One gold star + the rating number (e.g. ★ 4.8).
class _RatingStars extends StatelessWidget {
  const _RatingStars({required this.rating});

  final String rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const Icon(Icons.star, color: Colors.amber, size: 18),
        const SizedBox(width: 4),
        Text(
          rating,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}

/// Location pin + the location text.
class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        const Icon(Icons.place, size: 15, color: Colors.grey),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 13, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}

// ============================================================================
//  SECTION 7 - DESTINATION DETAILS SCREEN
// -----------------------------------------------------------------------------
//  Opened with Navigator.push() from the Explore screen. The AppBar back arrow
//  (and the button at the bottom) close it with Navigator.pop().
// ============================================================================

class DestinationDetailScreen extends StatefulWidget {
  const DestinationDetailScreen({
    super.key,
    required this.destination,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  final Destination destination;

  /// Is this destination already in the favourites list?
  final bool isFavorite;

  /// Called when the user taps the heart, so the list on the previous screen
  /// can be updated too (the session state lives there).
  final VoidCallback onToggleFavorite;

  @override
  State<DestinationDetailScreen> createState() =>
      _DestinationDetailScreenState();
}

class _DestinationDetailScreenState extends State<DestinationDetailScreen> {
  /// Local copy of the favourite flag, so the heart updates instantly here.
  late bool _isFavorite = widget.isFavorite;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    // Also update the favourites list of the Explore screen.
    widget.onToggleFavorite();
  }

  @override
  Widget build(BuildContext context) {
    final Destination destination = widget.destination;

    return Scaffold(
      // SliverAppBar gives us the collapsing image header + back button.
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: kPrimaryColor,
            foregroundColor: Colors.white,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                destination.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  shadows: <Shadow>[
                    Shadow(blurRadius: 8, color: Colors.black54),
                  ],
                ),
              ),
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  _DestinationImage(url: destination.imageUrl),
                  // Dark gradient so the title is always readable.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: <Color>[Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: _toggleFavorite,
                tooltip: _isFavorite
                    ? 'Remove from favourites'
                    : 'Add to favourites',
                icon: Icon(
                  _isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: _isFavorite ? Colors.redAccent : Colors.white,
                ),
              ),
              const SizedBox(width: 8),
            ],
          ),

          // ----- The information of the destination -----
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Category badge + best season
                  Row(
                    children: <Widget>[
                      _CategoryBadge(destination: destination),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Best season: ${destination.bestSeason}',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Name + location
                  Text(
                    destination.name,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  _LocationRow(location: destination.location),

                  const SizedBox(height: 18),

                  // Three info boxes: rating, price and category
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _InfoBox(
                          icon: Icons.star,
                          iconColor: Colors.amber,
                          value: destination.ratingLabel,
                          label: 'Rating',
                        ),
                      ),
                      Expanded(
                        child: _InfoBox(
                          icon: Icons.payments,
                          iconColor: kPrimaryColor,
                          value: destination.priceLabel,
                          label: 'Price',
                        ),
                      ),
                      Expanded(
                        child: _InfoBox(
                          icon: destination.categoryIcon,
                          iconColor: kPrimaryColor,
                          value: destination.category,
                          label: 'Category',
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'About this place'),
                  const SizedBox(height: 8),
                  Text(
                    destination.description,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 24),
                  const _SectionTitle(title: 'Highlights'),
                  const SizedBox(height: 8),
                  ...destination.highlights.map(
                    (String highlight) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(
                            Icons.check_circle,
                            size: 18,
                            color: kPrimaryColor,
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(highlight)),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Favourite button + back button
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _toggleFavorite,
                          icon: Icon(
                            _isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                          label: Text(
                            _isFavorite
                                ? 'Remove from favourites'
                                : 'Add to favourites',
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      OutlinedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.arrow_back),
                        label: const Text('Back'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Opens the "Plan your trip" form (with validation).
                  OutlinedButton.icon(
                    onPressed: _openTripPlanner,
                    icon: const Icon(Icons.edit_calendar),
                    label: const Text('Plan your trip'),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Opens the form screen with Navigator.push (third screen of the app).
  void _openTripPlanner() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) =>
            TripPlannerScreen(destination: widget.destination),
      ),
    );
  }
}

/// Small titled box used on the details screen (rating / price / category).
class _InfoBox extends StatelessWidget {
  const _InfoBox({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: kPrimaryColor.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: <Widget>[
          Icon(icon, color: iconColor),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }
}

/// Title of a section on the details screen, with a small coloured line.
class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(width: 5, height: 20, color: kPrimaryColor),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ============================================================================
//  SECTION 8 - "PLAN A TRIP" FORM SCREEN (form validation)
// -----------------------------------------------------------------------------
//  This screen proves the "proper form/UI validation" requirement. It uses a
//  Flutter Form + TextFormField widgets with custom validators:
//    * Full name  -> required, at least 3 characters
//    * Email      -> required, must look like a valid email address
//    * Travellers -> required, a whole number between 1 and 20
//    * Date       -> required, cannot be a date in the past
// ============================================================================

class TripPlannerScreen extends StatefulWidget {
  const TripPlannerScreen({super.key, required this.destination});

  final Destination destination;

  @override
  State<TripPlannerScreen> createState() => _TripPlannerScreenState();
}

class _TripPlannerScreenState extends State<TripPlannerScreen> {
  // The key gives access to the FormState, needed to run the validation.
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _travellersController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _selectedDate;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _travellersController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  // --------------------------------------------------------------------------
  //  VALIDATORS - each one returns null when the value is valid, or a String
  //  with the error message when it is not.
  // --------------------------------------------------------------------------

  /// Full name: required + at least 3 characters.
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters long';
    }
    return null;
  }

  /// Email: required + simple email pattern check.
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    // A simple (student level) email pattern.
    final RegExp emailPattern = RegExp(r'^[\w.+-]+@[\w-]+\.[\w.-]+$');
    if (!emailPattern.hasMatch(value.trim())) {
      return 'Please enter a valid email (e.g. name@gmail.com)';
    }
    return null;
  }

  /// Number of travellers: required, whole number between 1 and 20.
  String? _validateTravellers(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter how many people are travelling';
    }
    final int? number = int.tryParse(value.trim());
    if (number == null) {
      return 'Please enter a whole number (e.g. 2)';
    }
    if (number < 1 || number > 20) {
      return 'The number of travellers must be between 1 and 20';
    }
    return null;
  }

  /// Travel date: required + cannot be in the past.
  String? _validateDate(DateTime? date) {
    if (date == null) {
      return 'Please choose a travel date';
    }
    final DateTime today = DateTime.now();
    final DateTime midnight = DateTime(today.year, today.month, today.day);
    if (date.isBefore(midnight)) {
      return 'The date cannot be in the past';
    }
    return null;
  }

  // --------------------------------------------------------------------------
  //  DATE PICKER
  // --------------------------------------------------------------------------
  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now,
      // The user cannot choose a past date.
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 3),
    );
    if (picked != null) {
      // Re-validate the form so the error message disappears immediately.
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // --------------------------------------------------------------------------
  //  SUBMIT: first validate everything, then show the success message.
  // --------------------------------------------------------------------------
  Future<void> _submitForm() async {
    // Run all the validators at once.
    final bool isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) {
      return; // the error messages are already visible under the fields
    }

    // Pretend we are sending the booking to the server.
    setState(() {
      _isSubmitting = true;
    });
    await Future<void>.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }
    setState(() {
      _isSubmitting = false;
    });

    // Success: show a dialog and go back to the details screen.
    await showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        icon: const Icon(Icons.check_circle, color: Colors.green, size: 48),
        title: const Text('Trip request sent!'),
        content: Text(
          'Your trip to ${widget.destination.name} has been requested.\n\n'
          'Travellers: ${_travellersController.text}\n'
          'Date: ${_selectedDate!.day}/${_selectedDate!.month}/'
          '${_selectedDate!.year}\n'
          'We will contact you at ${_emailController.text}.',
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime date) => '${date.day}/${date.month}/${date.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan your trip'),
        // Back navigation with Navigator.pop().
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey, // the key used by _formKey.currentState.validate()
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            children: <Widget>[
              // ----- Small header card with the chosen destination -----
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        width: 60,
                        height: 60,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: _DestinationImage(
                            url: widget.destination.imageUrl,
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.destination.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.destination.location,
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'From ${widget.destination.priceLabel} '
                              'per person',
                              style: const TextStyle(
                                fontSize: 12,
                                color: kPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ----- Full name -----
              TextFormField(
                controller: _nameController,
                validator: _validateName,
                textCapitalization: TextCapitalization.words,
                keyboardType: TextInputType.name,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  hintText: 'e.g. Ali Khan',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ----- Email -----
              TextFormField(
                controller: _emailController,
                validator: _validateEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email address',
                  hintText: 'e.g. name@gmail.com',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ----- Number of travellers -----
              TextFormField(
                controller: _travellersController,
                validator: _validateTravellers,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number of travellers',
                  hintText: 'e.g. 2',
                  prefixIcon: Icon(Icons.group),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // ----- Travel date -----
              // FormField is used here because the value is a DateTime chosen
              // with a date picker instead of text typed by the user.
              FormField<DateTime>(
                validator: _validateDate,
                initialValue: _selectedDate,
                // FormFieldBuilder takes ONE argument (the FormFieldState).
                builder: (FormFieldState<DateTime> field) {
                  return InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Travel date',
                      prefixIcon: const Icon(Icons.calendar_month),
                      border: const OutlineInputBorder(),
                      errorText: field.errorText,
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            field.value == null
                                ? 'No date selected'
                                : _formatDate(field.value!),
                            style: TextStyle(
                              fontSize: 16,
                              color: field.value == null
                                  ? Colors.grey
                                  : Colors.black87,
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            _pickDate().then((_) {
                              // Give the new value to the FormField.
                              field.didChange(_selectedDate);
                              _formKey.currentState?.validate();
                            });
                          },
                          child: const Text('Pick date'),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),

              // ----- Optional notes (no validator: the field is optional) -----
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Special requests (optional)',
                  hintText: 'Hotel, food, guide...',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.notes),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              // ----- Submit button -----
              FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitForm,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.send),
                label: Text(_isSubmitting ? 'Sending...' : 'Request this trip'),
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
