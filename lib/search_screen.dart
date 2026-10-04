import 'package:flutter/material.dart';
import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';

// Shared search history.
// This stays available when SearchScreen is recreated.
final List<String> searchHistory = [];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color cream = Color(0xFFF9E8A2);
  static const Color maroon = Color(0xFF7A1F2B);

  final TextEditingController searchController =
      TextEditingController();

  final List<Map<String, dynamic>> books = const [
    {
      'title': 'The Seven Husbands of Evelyn Hugo',
      'author': 'Taylor Jenkins Reid',
      'rating': 5.0,
    },
    {
      'title': 'Heated Rivalry',
      'author': 'Rachel Reid',
      'rating': 4.5,
      'image': 'assets/images/heated_rivalry.jpg',
    },
    {
      'title': 'Fourth Wing',
      'author': 'Rebecca Yarros',
      'rating': 4.0,
    },
    {
      'title': 'The Song of Achilles',
      'author': 'Madeline Miller',
      'rating': 3.5,
    },
    {
      'title': 'It Ends with Us',
      'author': 'Colleen Hoover',
      'rating': 3.0,
    },
    {
      'title': 'A Court of Thorns and Roses',
      'author': 'Sarah J. Maas',
      'rating': 4.5,
    },
    {
      'title': 'The Love Hypothesis',
      'author': 'Ali Hazelwood',
      'rating': 3.0,
    },
    {
      'title': 'Verity',
      'author': 'Colleen Hoover',
      'rating': 2.5,
    },
    {
      'title': 'Red, White & Royal Blue',
      'author': 'Casey McQuiston',
      'rating': 4.0,
    },
    {
      'title': 'The Midnight Library',
      'author': 'Matt Haig',
      'rating': 3.5,
    },
  ];

  List<Map<String, dynamic>> searchResults = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void performSearch([String? value]) {
    final search = (value ?? searchController.text)
        .trim()
        .toLowerCase();

    if (search.isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }

    if (!searchHistory.contains(search)) {
      searchHistory.insert(0, search);
    }

    final results = search.length < 2
        ? <Map<String, dynamic>>[]
        : books.where((book) {
            final title =
                book['title'].toString().toLowerCase();
            final author =
                book['author'].toString().toLowerCase();

            return title.contains(search) ||
                author.contains(search);
          }).toList();

    setState(() {
      searchResults = results;
      searchController.text = search;
      searchController.selection =
          TextSelection.fromPosition(
        TextPosition(
          offset: searchController.text.length,
        ),
      );
    });
  }

  void removeHistoryItem(String item) {
    setState(() {
      searchHistory.remove(item);
    });
  }

  void clearHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final hasSearched =
        searchController.text.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: maroon,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopNavigation(context),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(
                  top: 24,
                  bottom: 24,
                ),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      'Search',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      'Find your next escape through books.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: TextField(
                      controller: searchController,
                      onSubmitted: performSearch,
                      style: const TextStyle(
                        color: maroon,
                        fontFamily: 'Georgia',
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Search books or authors',
                        hintStyle: const TextStyle(
                          color: maroon,
                          fontFamily: 'Georgia',
                          fontSize: 13,
                        ),
                        filled: true,
                        fillColor: cream,
                        prefixIcon: const Icon(
                          Icons.search,
                          color: maroon,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(
                            Icons.arrow_forward,
                            color: maroon,
                          ),
                          onPressed: performSearch,
                        ),
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (hasSearched)
                    if (searchResults.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                        child: Text(
                          'No results found.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Georgia',
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      ...searchResults.map(
                        (book) => _bookCard(book),
                      ),

                  if (!hasSearched &&
                      searchHistory.isNotEmpty)
                    _buildSearchHistory(),

                  if (!hasSearched &&
                      searchHistory.isEmpty)
                    const SizedBox.shrink(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation(BuildContext context) {
    return Container(
      height: 64,
      color: cream,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: IconButton(
              icon: const Icon(
                Icons.menu,
                color: maroon,
              ),
              onPressed: () {},
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navText(
                  'Top 10',
                  false,
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const TopBooksScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 20),

                _navText(
                  'History',
                  false,
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const HistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(width: 20),

                _navText(
                  'Favorites',
                  false,
                  () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const FavoritesScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          SizedBox(
            width: 114,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 38,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.notifications_none,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 38,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.share_outlined,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                ),

                SizedBox(
                  width: 38,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.search,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _navText(
    String text,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        minimumSize: Size.zero,
        tapTargetSize:
            MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: maroon,
          fontFamily: 'Georgia',
          fontSize: 14,
          fontWeight:
              isActive
                  ? FontWeight.bold
                  : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSearchHistory() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Search History',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Georgia',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              TextButton(
                onPressed: clearHistory,
                child: const Text(
                  'Clear All',
                  style: TextStyle(
                    color: cream,
                    fontFamily: 'Georgia',
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          ...searchHistory.map(
            (item) => ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.history,
                color: cream,
                size: 20,
              ),
              title: Text(
                item,
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Georgia',
                  fontSize: 12,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.close,
                  color: cream,
                  size: 18,
                ),
                onPressed: () {
                  removeHistoryItem(item);
                },
              ),
              onTap: () {
                searchController.text = item;
                performSearch(item);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _bookCard(
    Map<String, dynamic> book,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            height: 110,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(4),
            ),
            child: book['image'] != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(4),
                    child: Image.asset(
                      book['image'],
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.menu_book,
                    color: maroon,
                    size: 32,
                  ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  book['author'],
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    ..._ratingStars(book['rating']),
                    const SizedBox(width: 6),
                    Text(
                      '${book['rating']}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _ratingStars(double rating) {
    List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(
          const Icon(
            Icons.star,
            color: cream,
            size: 16,
          ),
        );
      } else if (rating >= i - 0.5) {
        stars.add(
          const Icon(
            Icons.star_half,
            color: cream,
            size: 16,
          ),
        );
      } else {
        stars.add(
          const Icon(
            Icons.star_border,
            color: cream,
            size: 16,
          ),
        );
      }
    }

    return stars;
  }
}