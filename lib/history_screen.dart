import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'topbooks_screen.dart';
import 'search_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'sidemenu_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() =>
      _HistoryScreenState();
}

class _HistoryScreenState
    extends State<HistoryScreen> {
  static const Color cream =
      Color(0xFFF9E8A2);

  static const Color maroon =
      Color(0xFF7A1F2B);

  final List<Map<String, dynamic>> historyBooks =
      [];

  bool isLoadingHistory = true;

  String activeNav = 'History';

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final supabase =
          Supabase.instance.client;

      final user =
          supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoadingHistory = false;
        });

        return;
      }

      final data = await supabase
          .from('user_books')
          .select(
            'book_title, book_author, book_image, rating, last_read_at',
          )
          .eq('user_id', user.id)
          .not('last_read_at', 'is', null)
          .order(
            'last_read_at',
            ascending: false,
          );

      if (!mounted) return;

      setState(() {
        historyBooks.clear();

        for (final row in data) {
          final lastRead =
              row['last_read_at'];

          historyBooks.add({
            'title':
                row['book_title'] ??
                    'Unknown title',
            'author':
                row['book_author'] ??
                    'Unknown author',
            'image':
                row['book_image'],
            'rating':
                row['rating'] != null
                    ? (row['rating'] as num)
                        .toDouble()
                    : 0.0,
            'lastRead':
                lastRead != null
                    ? _formatDate(
                        DateTime.parse(
                          lastRead.toString(),
                        ),
                      )
                    : '',
          });
        }

        isLoadingHistory = false;
      });
    } catch (error) {
      debugPrint(
        'Could not load history: $error',
      );

      if (!mounted) return;

      setState(() {
        isLoadingHistory = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not load History: $error',
          ),
        ),
      );
    }
  }

  String _formatDate(
    DateTime date,
  ) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    final localDate =
        date.toLocal();

    return '${months[localDate.month - 1]} '
        '${localDate.day}, '
        '${localDate.year}';
  }

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
              child: ListView(
                padding:
                    const EdgeInsets.only(
                  top: 24,
                  bottom: 24,
                ),
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      'History',
                      textAlign:
                          TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding:
                        EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      "Explore your past reads and see how far you've come as a reader.",
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

                  const SizedBox(height: 24),

                  if (isLoadingHistory)
                    const Padding(
                      padding:
                          EdgeInsets.only(
                        top: 30,
                      ),
                      child: Center(
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (historyBooks.isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.only(
                        top: 30,
                      ),
                      child: Center(
                        child: Text(
                          'No reading history yet.',
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontFamily:
                                'Georgia',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    ...historyBooks.map(
                      (book) =>
                          _historyBookCard(
                        book,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

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
                  true,
                  () {},
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
        padding:
            const EdgeInsets.symmetric(
          horizontal: 4,
        ),
        minimumSize: Size.zero,
        tapTargetSize:
            MaterialTapTargetSize
                .shrinkWrap,
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
    final double rating =
        (book['rating'] as num?)
                ?.toDouble() ??
            0.0;

    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 75,
            height: 110,
            decoration: BoxDecoration(
              color: cream,
              borderRadius:
                  BorderRadius.circular(4),
            ),
            child: _buildBookImage(book),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  book['title'] ??
                      'Unknown title',
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  book['author'] ??
                      'Unknown author',
                  style:
                      const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 12,
                  ),
                ),

                if (rating > 0) ...[
                  const SizedBox(height: 8),

                  Row(
                    children: [
                      ..._ratingStars(
                        rating,
                      ),

                      const SizedBox(width: 6),

                      Text(
                        rating
                            .toStringAsFixed(
                          1,
                        ),
                        style:
                            const TextStyle(
                          color: Colors.white,
                          fontFamily:
                              'Georgia',
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 8),

                Text(
                  'Last read: ${book['lastRead']}',
                  style:
                      const TextStyle(
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

  Widget _buildBookImage(
    Map<String, dynamic> book,
  ) {
    final image =
        book['image']?.toString() ?? '';

    if (image.isEmpty) {
      return const Center(
        child: Icon(
          Icons.menu_book,
          color: maroon,
          size: 32,
        ),
      );
    }

    if (image.startsWith('http')) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(4),
        child: Image.network(
          image,
          width: 75,
          height: 110,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.menu_book,
                color: maroon,
                size: 32,
              ),
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(4),
      child: Image.asset(
        image,
        width: 75,
        height: 110,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.menu_book,
              color: maroon,
              size: 32,
            ),
          );
        },
      ),
    );
  }

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