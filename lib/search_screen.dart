import 'package:flutter/material.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'sidemenu_screen.dart';

// ============================================================
// SEARCH HISTORY
// ============================================================

final List<String> searchHistory = [];

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() =>
      _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  static const Color cream = Color(0xFFF9E8A2);
  static const Color maroon = Color(0xFF7A1F2B);

  final TextEditingController searchController =
      TextEditingController();

  bool hasSearched = false;

  // ============================================================
  // BOOKS
  // ============================================================

  final List<Map<String, dynamic>> books = [
    {
      'title': 'Harry Potter and the Chamber of Secrets',
      'author': 'J.K. Rowling',
      'image':
          'assets/images/harry_potter_chamber_of_secrets.jpg',
    },
    {
      'title': 'Credence',
      'author': 'Penelope Douglas',
      'image': 'assets/images/credence.jpg',
    },
    {
      'title': 'Song of Ice and Fire',
      'author': 'George R.R. Martin',
      'image':
          'assets/images/song_of_ice_and_fire.jpg',
    },
    {
      'title': 'Fire and Blood',
      'author': 'George R.R. Martin',
      'image':
          'assets/images/fire_and_blood.jpg',
    },
  ];

  List<Map<String, dynamic>> searchResults = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  void performSearch([String? value]) {
    final entered =
        (value ?? searchController.text).trim();

    if (entered.isEmpty) {
      return;
    }

    final search = entered.toLowerCase();

    searchHistory.removeWhere(
      (item) => item.toLowerCase() == search,
    );

    searchHistory.insert(0, entered);

    final results = books.where((book) {
      final title =
          book['title'].toString().toLowerCase();

      final author =
          book['author'].toString().toLowerCase();

      return title.contains(search) ||
          author.contains(search);
    }).toList();

    setState(() {
      hasSearched = true;
      searchResults = results;
    });
  }

  // ============================================================
  // RETURN TO SEARCH SCREEN
  // ============================================================

  void returnToSearch() {
    setState(() {
      hasSearched = false;
      searchResults = [];
      searchController.clear();
    });
  }

  // ============================================================
  // REMOVE ONE HISTORY ITEM
  // ============================================================

  void removeHistoryItem(String item) {
    setState(() {
      searchHistory.remove(item);
    });
  }

  // ============================================================
  // CLEAR ALL HISTORY
  // ============================================================

  void clearHistory() {
    setState(() {
      searchHistory.clear();
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !hasSearched,
      onPopInvokedWithResult:
          (didPop, result) {
        if (!didPop && hasSearched) {
          returnToSearch();
        }
      },
      child: Scaffold(
        backgroundColor: maroon,
        drawer: const SideMenu(),
        body: SafeArea(
          child: Column(
            children: [
              _buildTopNavigation(context),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 28),

                      // SEARCH BAR
                      Padding(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 32,
                        ),
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            controller:
                                searchController,
                            onSubmitted:
                                performSearch,
                            textInputAction:
                                TextInputAction.search,
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Georgia',
                              fontSize: 12,
                            ),
                            decoration:
                                InputDecoration(
                              hintText: 'Search',
                              hintStyle:
                                  const TextStyle(
                                color: Colors.white,
                                fontFamily:
                                    'Georgia',
                                fontSize: 12,
                              ),
                              prefixIcon:
                                  const Icon(
                                Icons.search,
                                color:
                                    Colors.white,
                                size: 19,
                              ),
                              contentPadding:
                                  const EdgeInsets
                                      .symmetric(
                                vertical: 0,
                              ),
                              enabledBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                                borderSide:
                                    const BorderSide(
                                  color:
                                      Colors.white,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  20,
                                ),
                                borderSide:
                                    const BorderSide(
                                  color:
                                      Colors.white,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 14),

                      if (!hasSearched)
                        _buildSearchHistory(),

                      if (hasSearched)
                        _buildSearchResults(),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // SEARCH HISTORY
  // ============================================================

  Widget _buildSearchHistory() {
    if (searchHistory.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 25),
        child: Text(
          'No recent searches.',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontSize: 12,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 52,
      ),
      child: Column(
        children: [
          ...searchHistory.map(
            (item) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.history,
                      color: Colors.white,
                      size: 18,
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          searchController.text =
                              item;

                          performSearch(item);
                        },
                        child: Text(
                          item,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontFamily: 'Georgia',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        removeHistoryItem(item);
                      },
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          const SizedBox(height: 15),

          GestureDetector(
            onTap: clearHistory,
            child: const Text(
              'Clear All',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
                fontSize: 10,
                decoration:
                    TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SEARCH RESULTS
  // ============================================================

  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Text(
          'No results found.',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Georgia',
            fontSize: 12,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
      ),
      child: Column(
        children: searchResults
            .map(
              (book) => _bookCard(book),
            )
            .toList(),
      ),
    );
  }

  // ============================================================
  // BOOK CARD
  // ============================================================

  Widget _bookCard(
    Map<String, dynamic> book,
  ) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cream,
        borderRadius:
            BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 70,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(2),
            ),
            child: Image.asset(
              book['image'],
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) {
                return const Icon(
                  Icons.menu_book,
                  color: maroon,
                );
              },
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'],
                  style: const TextStyle(
                    color: maroon,
                    fontFamily: 'Georgia',
                    fontSize: 13,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  book['author'],
                  style: const TextStyle(
                    color: maroon,
                    fontFamily: 'Georgia',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // TOP NAVIGATION
  // ============================================================

  Widget _buildTopNavigation(
    BuildContext context,
  ) {
    return Container(
      height: 64,
      color: cream,
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Builder(
              builder: (drawerContext) {
                return IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: maroon,
                  ),
                  onPressed: () {
                    Scaffold.of(
                      drawerContext,
                    ).openDrawer();
                  },
                );
              },
            ),
          ),

          Expanded(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
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
              mainAxisAlignment:
                  MainAxisAlignment.end,
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

  // ============================================================
  // NAVIGATION TEXT
  // ============================================================

  Widget _navText(
    String text,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding:
            const EdgeInsets.symmetric(
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
}