import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';
import 'sidemenu_screen.dart';

// ============================================================
// RATED BOOKS SCREEN
// ============================================================

class RatedBooksScreen extends StatefulWidget {
  const RatedBooksScreen({super.key});

  @override
  State<RatedBooksScreen> createState() => _RatedBooksScreenState();
}

class _RatedBooksScreenState extends State<RatedBooksScreen> {
  static const Color cream = Color(0xFFF9E8A2);
  static const Color maroon = Color(0xFF7A1F2B);

  // Books rated by the currently logged-in user.
  final List<Map<String, dynamic>> ratedBooks = [];

  bool isLoadingRatings = true;

  @override
  void initState() {
    super.initState();
    _loadRatings();
  }

  // ============================================================
  // LOAD ONLY THE CURRENT USER'S RATED BOOKS
  // ============================================================

  Future<void> _loadRatings() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          ratedBooks.clear();
          isLoadingRatings = false;
        });

        return;
      }

      final data = await supabase
          .from('user_books')
          .select('book_title, book_author, book_image, rating')
          .eq('user_id', user.id)
          .not('rating', 'is', null)
          .order('book_title');

      if (!mounted) return;

      setState(() {
        ratedBooks
          ..clear()
          ..addAll(
            data.map((row) => Map<String, dynamic>.from(row)),
          );

        isLoadingRatings = false;
      });
    } catch (error) {
      debugPrint('Could not load ratings: $error');

      if (!mounted) return;

      setState(() {
        isLoadingRatings = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load your rated books.'),
        ),
      );
    }
  }

  // ============================================================
  // SAVE RATING
  // ============================================================

  Future<void> _saveRating({
    required String title,
    required String author,
    required double rating,
  }) async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in.');
      }

      final existing = await supabase
          .from('user_books')
          .select('id')
          .eq('user_id', user.id)
          .eq('book_title', title)
          .maybeSingle();

      if (existing != null) {
        await supabase.from('user_books').update({
          'rating': rating,
          'book_author': author,
        }).eq('id', existing['id']);
      } else {
        await supabase.from('user_books').insert({
          'user_id': user.id,
          'book_title': title,
          'book_author': author,
          'rating': rating,
        });
      }

      if (!mounted) return;

      setState(() {
        final index = ratedBooks.indexWhere(
          (book) => book['book_title'] == title,
        );

        final updatedBook = <String, dynamic>{
          'book_title': title,
          'book_author': author,
          'rating': rating,
        };

        if (index >= 0) {
          ratedBooks[index] = {
            ...ratedBooks[index],
            ...updatedBook,
          };
        } else {
          ratedBooks.add(updatedBook);
          ratedBooks.sort(
            (a, b) => (a['book_title'] as String)
                .compareTo(b['book_title'] as String),
          );
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Rating saved!')),
      );
    } catch (error) {
      debugPrint('Could not save rating: $error');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not save your rating: $error'),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

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
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Rated Books',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 45),
                      child: Text(
                        'View your rated books and reflect on your reading experiences',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Georgia',
                          fontSize: 12,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),

                    if (isLoadingRatings)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 30),
                        child: CircularProgressIndicator(color: cream),
                      )
                    else if (ratedBooks.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 35,
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.star_border_rounded,
                              color: cream,
                              size: 55,
                            ),
                            SizedBox(height: 12),
                            Text(
                              'No Rated Books Yet',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: 'Georgia',
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Books you rate will appear here.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white70,
                                fontFamily: 'Georgia',
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      )
                    else
                      ...ratedBooks.map(_ratedBookCard),

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

  Widget _buildTopNavigation(BuildContext context) {
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
                  icon: const Icon(Icons.menu, color: maroon),
                  onPressed: () {
                    Scaffold.of(drawerContext).openDrawer();
                  },
                );
              },
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _navText('Top 10', false, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopBooksScreen(),
                    ),
                  );
                }),
                const SizedBox(width: 20),
                _navText('History', false, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                }),
                const SizedBox(width: 20),
                _navText('Favorites', false, () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FavoritesScreen(),
                    ),
                  );
                }),
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
                    icon: const Icon(Icons.search, color: maroon, size: 22),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
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
  // NAV TEXT
  // ============================================================

  Widget _navText(
    String text,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        text,
        style: TextStyle(
          color: maroon,
          fontFamily: 'Georgia',
          fontSize: 14,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // ============================================================
  // RATED BOOK CARD
  // ============================================================

  Widget _ratedBookCard(Map<String, dynamic> book) {
    final String title = book['book_title'] as String? ?? 'Untitled';
    final String author = book['book_author'] as String? ?? 'Unknown Author';
    final double rating = (book['rating'] as num?)?.toDouble() ?? 0.0;
    final String? image = book['book_image'] as String?;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 42, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 83,
            height: 126,
            decoration: BoxDecoration(
              color: cream,
              borderRadius: BorderRadius.circular(2),
            ),
            clipBehavior: Clip.antiAlias,
            child: image != null && image.isNotEmpty
                ? Image.network(
                    image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.menu_book,
                        color: maroon,
                        size: 48,
                      );
                    },
                  )
                : const Icon(
                    Icons.menu_book,
                    color: maroon,
                    size: 48,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _ratingStars(rating),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 27,
                  child: ElevatedButton(
                    onPressed: () => _showRatingDialog(book),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: cream,
                      foregroundColor: maroon,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Change Your Rating',
                      style: TextStyle(
                        fontFamily: 'Georgia',
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
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

  void _showRatingDialog(Map<String, dynamic> book) {
    final String title = book['book_title'] as String;
    final String author = book['book_author'] as String? ?? 'Unknown Author';

    double selectedRating = (book['rating'] as num?)?.toDouble() ?? 0.0;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: cream,
              title: const Text(
                'Change Your Rating',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: maroon,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final double starValue = index + 1.0;

                      return IconButton(
                        onPressed: () {
                          setDialogState(() {
                            selectedRating = starValue;
                          });
                        },
                        icon: Icon(
                          selectedRating >= starValue
                              ? Icons.star
                              : Icons.star_border,
                          color: maroon,
                          size: 30,
                        ),
                      );
                    }),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: selectedRating == 0
                      ? null
                      : () async {
                          await _saveRating(
                            title: title,
                            author: author,
                            rating: selectedRating,
                          );

                          if (!context.mounted) return;

                          Navigator.pop(dialogContext);
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: maroon,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontFamily: 'Georgia'),
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

  List<Widget> _ratingStars(double rating) {
    final List<Widget> stars = [];

    for (int i = 1; i <= 5; i++) {
      if (rating >= i) {
        stars.add(
          const Icon(Icons.star, color: cream, size: 18),
        );
      } else if (rating >= i - 0.5) {
        stars.add(
          const Icon(Icons.star_half, color: cream, size: 18),
        );
      } else {
        stars.add(
          const Icon(Icons.star_border, color: cream, size: 18),
        );
      }
    }

    return stars;
  }
}