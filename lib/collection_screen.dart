import 'package:flutter/material.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';
import 'sidemenu_screen.dart';

// ============================================================
// COLLECTION DATA
// ============================================================

final List<Map<String, String>> wantToReadBooks = [
  {
    'title': 'Heated Rivalry',
    'image': 'assets/images/heated_rivalry.jpg',
  },
  {
    'title': 'Little Women',
    'image': 'assets/images/little_women.jpg',
  },
  {
    'title': 'Credence',
    'image': 'assets/images/credence.jpg',
  },
  {
    'title': 'Pride and Prejudice',
    'image': 'assets/images/pride_and_prejudice.jpg',
  },
];

final List<Map<String, String>> readingBooks = [
  {
    'title': 'Bridgerton',
    'image': 'assets/images/bridgerton.jpg',
  },
  {
    'title': 'One Day',
    'image': 'assets/images/one_day.jpg',
  },
];

final List<Map<String, String>> alreadyReadBooks = [
  {
    'title': 'Pride and Prejudice',
    'image': 'assets/images/pride_and_prejudice.jpg',
  },
  {
    'title': 'Mockingjay',
    'image': 'assets/images/mockingjay.jpg',
  },
  {
    'title': 'Harry Potter and the Chamber of Secrets',
    'image':
        'assets/images/harry_potter_chamber_of_secrets.jpg',
  },
];

// ============================================================
// COLLECTION SCREEN
// ============================================================

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key});

  @override
  State<CollectionScreen> createState() =>
      _CollectionScreenState();
}

class _CollectionScreenState
    extends State<CollectionScreen> {
  static const Color cream =
      Color(0xFFF9E8A2);

  static const Color maroon =
      Color(0xFF7A1F2B);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroon,

      drawer: const SideMenu(),

      body: SafeArea(
        child: Column(
          children: [
            _buildTopNavigation(context),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.only(
                  bottom: 30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 34),

                    // ==================================================
                    // TITLE
                    // ==================================================

                    const Center(
                      child: Text(
                        'Collection',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Georgia',
                          fontSize: 25,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // ==================================================
                    // DESCRIPTION
                    // ==================================================
                    //
                    // The SizedBox gives the text a centered area
                    // across the page, while textAlign centers both
                    // lines inside that area.
                    //

                    Center(
                      child: SizedBox(
                        width: 340,
                        child: const Text(
                          'Manage your reading lists and easily track books\n'
                          'you want to read, are reading, and have finished.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Georgia',
                            fontSize: 12,
                            fontStyle:
                                FontStyle.italic,
                            height: 1.45,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 34),

                    // ==================================================
                    // I WANT TO READ
                    // ==================================================

                    _buildSection(
                      title: 'I want to read',
                      books: wantToReadBooks,
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // I'M READING
                    // ==================================================

                    _buildSection(
                      title: "I'm reading",
                      books: readingBooks,
                    ),

                    const SizedBox(height: 18),

                    // ==================================================
                    // I ALREADY READ
                    // ==================================================

                    _buildSection(
                      title: 'I already read',
                      books: alreadyReadBooks,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
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
          // HAMBURGER
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

          // TOP / HISTORY / FAVORITES
          Expanded(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                _navText(
                  'Top',
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

          // RIGHT SIDE ICONS
          SizedBox(
            width: 114,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.end,
              children: [
                // NOTIFICATIONS
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

                // SHARE
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

                // SEARCH
                SizedBox(
                  width: 38,
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.search,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const SearchScreen(),
                        ),
                      );
                    },
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
        style: const TextStyle(
          color: maroon,
          fontFamily: 'Georgia',
          fontSize: 14,
        ),
      ),
    );
  }

  // ============================================================
  // COLLECTION SECTION
  // ============================================================

  Widget _buildSection({
    required String title,
    required List<Map<String, String>> books,
  }) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        // SECTION TITLE
        Padding(
          padding:
              const EdgeInsets.only(
            left: 48,
            bottom: 12,
          ),
          child: Text(
            '$title (All ${books.length})',
            style: const TextStyle(
              color: Colors.white,
              fontFamily: 'Georgia',
              fontSize: 12,
              fontWeight:
                  FontWeight.bold,
              decoration:
                  TextDecoration.underline,
            ),
          ),
        ),

        // ==================================================
        // HORIZONTAL BOOK LIST
        // ==================================================

        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection:
                Axis.horizontal,
            padding:
                const EdgeInsets.only(
              left: 28,
              right: 28,
            ),
            itemCount: books.length,
            separatorBuilder:
                (context, index) {
              return const SizedBox(
                width: 15,
              );
            },
            itemBuilder:
                (context, index) {
              return _buildBookCover(
                books[index],
              );
            },
          ),
        ),
      ],
    );
  }

  // ============================================================
  // BOOK COVER
  // ============================================================

  Widget _buildBookCover(
    Map<String, String> book,
  ) {
    final String image =
        book['image'] ?? '';

    final String title =
        book['title'] ?? '';

    return GestureDetector(
      onTap: () {
        _showBookOptions(title);
      },
      child: Container(
        width: 84,
        height: 118,
        decoration: BoxDecoration(
          color: cream,
          borderRadius:
              BorderRadius.circular(1),
        ),
        clipBehavior:
            Clip.antiAlias,
        child: Image.asset(
          image,
          fit: BoxFit.cover,
          errorBuilder:
              (
                context,
                error,
                stackTrace,
              ) {
            return const Center(
              child: Icon(
                Icons.menu_book,
                color: maroon,
                size: 42,
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // BOOK OPTIONS
  // ============================================================

  void _showBookOptions(
    String title,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: cream,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(18),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 25,
              vertical: 20,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  title,
                  textAlign:
                      TextAlign.center,
                  style: const TextStyle(
                    color: maroon,
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  'Book options',
                  style: TextStyle(
                    color: maroon,
                    fontFamily: 'Georgia',
                    fontSize: 13,
                  ),
                ),

                const SizedBox(height: 15),

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}