import 'package:flutter/material.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';
import 'sidemenu_screen.dart';

// ============================================================
// SHARED USER RATINGS
// ============================================================
//
// These ratings are shared outside the screen so they don't
// reset whenever RatedBooksScreen is opened again.
//
// Later, this can be replaced with your actual database.
//

final Map<String, double> userRatings = {
  'A Court of Mist and Fury': 4.5,
  'Pride and Prejudice': 4.5,
  'A Court of Thorns and Roses': 5.0,
};

// ============================================================
// RATED BOOKS SCREEN
// ============================================================

class RatedBooksScreen extends StatefulWidget {
  const RatedBooksScreen({super.key});

  @override
  State<RatedBooksScreen> createState() =>
      _RatedBooksScreenState();
}

class _RatedBooksScreenState
    extends State<RatedBooksScreen> {
  static const Color cream =
      Color(0xFFF9E8A2);

  static const Color maroon =
      Color(0xFF7A1F2B);

  // ============================================================
  // TEMPORARY BOOK DATA
  // ============================================================
  //
  // The books themselves are temporary for now.
  // Later, these will come from your database.
  //

  final List<Map<String, dynamic>> ratedBooks = [
    {
      'title': 'A Court of Mist and Fury',
      'author': 'Sarah J. Maas',
    },
    {
      'title': 'Pride and Prejudice',
      'author': 'Jane Austen',
    },
    {
      'title': 'A Court of Thorns and Roses',
      'author': 'Sarah J. Maas',
    },
  ];

  String activeNav = '';

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maroon,

      // SIDE MENU
      drawer: const SideMenu(),

      body: SafeArea(
        child: Column(
          children: [
            _buildTopNavigation(context),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),

                    // TITLE
                    const Text(
                      'Rated Books',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    // SUBTITLE
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 45,
                      ),
                      child: Text(
                        'View your rated books and reflect on your reading experiences',
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Georgia',
                          fontSize: 12,
                          fontStyle:
                              FontStyle.italic,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    // BOOKS
                    ...ratedBooks.map(
                      (book) =>
                          _ratedBookCard(book),
                    ),

                    const SizedBox(height: 25),
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

          // MAIN NAVIGATION
          Expanded(
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              children: [
                _navText(
                  'Top',
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

          // RIGHT-SIDE ICONS
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

  // ============================================================
  // RATED BOOK CARD
  // ============================================================

  Widget _ratedBookCard(
    Map<String, dynamic> book,
  ) {
    final String title =
        book['title'] as String;

    final String author =
        book['author'] as String;

    // Get the CURRENT rating from the shared map.
    final double rating =
        userRatings[title] ?? 0.0;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 42,
        vertical: 12,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          // ====================================================
          // TEMPORARY BOOK ICON
          // ====================================================
          //
          // Later this will be replaced by the book cover
          // supplied by your database.
          //

          Container(
            width: 83,
            height: 126,
            decoration: BoxDecoration(
              color: cream,
              borderRadius:
                  BorderRadius.circular(2),
            ),
            child: const Icon(
              Icons.menu_book,
              color: maroon,
              size: 48,
            ),
          ),

          const SizedBox(width: 14),

          // ====================================================
          // BOOK INFORMATION
          // ====================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                // BOOK TITLE
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 14,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                // AUTHOR
                Text(
                  'by $author',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 11,
                  ),
                ),

                const SizedBox(height: 6),

                // CURRENT RATING
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center,
                  children:
                      _ratingStars(rating),
                ),

                const SizedBox(height: 8),

                // CHANGE RATING BUTTON
                SizedBox(
                  height: 27,
                  child: ElevatedButton(
                    onPressed: () {
                      _showRatingDialog(book);
                    },
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor: cream,
                      foregroundColor: maroon,
                      elevation: 0,
                      padding:
                          const EdgeInsets
                              .symmetric(
                        horizontal: 20,
                      ),
                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(
                          15,
                        ),
                      ),
                    ),
                    child: const Text(
                      'Change Your Rating',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 10,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
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
  // CHANGE RATING DIALOG
  // ============================================================

  void _showRatingDialog(
    Map<String, dynamic> book,
  ) {
    final String title =
        book['title'] as String;

    double selectedRating =
        userRatings[title] ?? 0.0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder:
              (
                dialogContext,
                setDialogState,
              ) {
            return AlertDialog(
              backgroundColor: cream,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(12),
              ),

              // DIALOG TITLE
              title: const Text(
                'Change Your Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: maroon,
                  fontFamily: 'Georgia',
                  fontSize: 18,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),

              content: Column(
                mainAxisSize:
                    MainAxisSize.min,
                children: [
                  // BOOK TITLE
                  Text(
                    title,
                    textAlign:
                        TextAlign.center,
                    style: const TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // RATING STARS
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (index) {
                        final int
                            starNumber =
                            index + 1;

                        return IconButton(
                          padding:
                              EdgeInsets.zero,
                          constraints:
                              const BoxConstraints(
                            minWidth: 38,
                            minHeight: 38,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              selectedRating =
                                  starNumber
                                      .toDouble();
                            });
                          },
                          icon: Icon(
                            selectedRating >=
                                    starNumber
                                ? Icons.star
                                : Icons.star_border,
                            color: maroon,
                            size: 30,
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  // RATING NUMBER
                  Text(
                    '${selectedRating.toStringAsFixed(1)} / 5.0',
                    style: const TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 13,
                    ),
                  ),
                ],
              ),

              actionsAlignment:
                  MainAxisAlignment.center,

              actions: [
                // CANCEL
                TextButton(
                  onPressed: () {
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),

                // SAVE
                ElevatedButton(
                  onPressed: () {
                    // ==================================================
                    // THIS IS THE IMPORTANT PART.
                    //
                    // Save the new rating to the shared map.
                    // ==================================================

                    userRatings[title] =
                        selectedRating;

                    // Rebuild Rated Books screen
                    // so the new stars appear.
                    setState(() {});

                    // Close dialog.
                    Navigator.pop(
                      dialogContext,
                    );
                  },
                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: cream,
                  ),
                  child: const Text(
                    'Save Rating',
                    style: TextStyle(
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // RATING STARS
  // ============================================================

  List<Widget> _ratingStars(
    double rating,
  ) {
    final List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(
          const Icon(
            Icons.star,
            color: cream,
            size: 19,
          ),
        );
      } else if (rating >= i - 0.5) {
        stars.add(
          const Icon(
            Icons.star_half,
            color: cream,
            size: 19,
          ),
        );
      } else {
        stars.add(
          const Icon(
            Icons.star_border,
            color: cream,
            size: 19,
          ),
        );
      }
    }

    return stars;
  }
}