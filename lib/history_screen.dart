import 'package:flutter/material.dart';
import 'topbooks_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  static const Color cream = Color(0xFFF9E8A2);
  static const Color maroon = Color(0xFF7A1F2B);

  final List<Map<String, dynamic>> historyBooks = const [
    {
      'title': 'The Seven Husbands of Evelyn Hugo',
      'author': 'Taylor Jenkins Reid',
      'rating': 5.0,
      'lastRead': 'September 28, 2026',
    },
    {
      'title': 'Heated Rivalry',
      'author': 'Rachel Reid',
      'rating': 4.5,
      'lastRead': 'September 24, 2026',
      'image': 'assets/images/heated_rivalry.jpg',
    },
    {
      'title': 'Fourth Wing',
      'author': 'Rebecca Yarros',
      'rating': 4.0,
      'lastRead': 'September 20, 2026',
    },
    {
      'title': 'The Song of Achilles',
      'author': 'Madeline Miller',
      'rating': 4.5,
      'lastRead': 'September 15, 2026',
    },
    {
      'title': 'It Ends with Us',
      'author': 'Colleen Hoover',
      'rating': 3.5,
      'lastRead': 'September 10, 2026',
    },
    {
      'title': 'A Court of Thorns and Roses',
      'author': 'Sarah J. Maas',
      'rating': 4.0,
      'lastRead': 'September 5, 2026',
    },
    {
      'title': 'The Love Hypothesis',
      'author': 'Ali Hazelwood',
      'rating': 3.5,
      'lastRead': 'August 29, 2026',
    },
    {
      'title': 'Verity',
      'author': 'Colleen Hoover',
      'rating': 3.0,
      'lastRead': 'August 22, 2026',
    },
  ];

  String activeNav = 'History';

  @override
  Widget build(BuildContext context) {
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
                      'History',
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
                      "Explore your past reads and see how far you've come as a reader.",
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

                  ...historyBooks.map(
                    (book) => _historyBookCard(book),
                  ),
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
                  activeNav == 'Top 10',
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
                  activeNav == 'History',
                  () {
                    setState(() {
                      activeNav = 'History';
                    });
                  },
                ),

                const SizedBox(width: 20),

                _navText(
                  'Favorites',
                  activeNav == 'Favorites',
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

  Widget _historyBookCard(
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

                const SizedBox(height: 8),

                Text(
                  'Last read: ${book['lastRead']}',
                  style: const TextStyle(
                    color: Colors.white,
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