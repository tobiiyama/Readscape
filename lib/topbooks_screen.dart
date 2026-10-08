import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

import 'search_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'sidemenu_screen.dart';

class TopBooksScreen extends StatefulWidget {
  const TopBooksScreen({super.key});

  @override
  State<TopBooksScreen> createState() => _TopBooksScreenState();
}

class _TopBooksScreenState extends State<TopBooksScreen> {
  static const Color cream = Color(0xFFF9E8A2);
  static const Color maroon = Color(0xFF7A1F2B);

  String activeNav = 'Top 10';

  List<Map<String, dynamic>> books = [];

  bool isLoadingBooks = true;

  @override
  void initState() {
    super.initState();
    _loadTopBooks();
  }

  Future<void> _loadTopBooks() async {
    try {
      final trendingUrl = Uri.parse(
        'https://openlibrary.org/trending/daily.json?limit=10',
      );

      final trendingResponse = await http.get(
        trendingUrl,
        headers: const {
          'User-Agent': 'Readscape School Project',
        },
      );

      if (trendingResponse.statusCode != 200) {
        throw Exception(
          'Could not load trending books.',
        );
      }

      final trendingData =
          jsonDecode(trendingResponse.body)
              as Map<String, dynamic>;

      final works =
          trendingData['works'] as List<dynamic>? ?? [];

      final List<Map<String, dynamic>> loadedBooks = [];

      for (int i = 0;
          i < works.length && i < 10;
          i++) {
        final work =
            works[i] as Map<String, dynamic>;

        final trendingTitle =
            work['title']?.toString() ??
                'Unknown Title';

        final details =
            await _searchBookDetails(
          trendingTitle,
        );

        final title =
            details['title']?.toString() ??
                trendingTitle;

        final author =
            details['author']?.toString() ??
                'Unknown Author';

        final image =
            details['image']?.toString();

        final rating =
            details['rating'] is num
                ? (details['rating'] as num)
                    .toDouble()
                : 0.0;

        loadedBooks.add({
          'rank': i + 1,
          'title': title,
          'author': author,
          'rating': rating,
          'image': image,
        });
      }

      if (!mounted) return;

      setState(() {
        books = loadedBooks;
        isLoadingBooks = false;
      });
    } catch (error) {
      debugPrint(
        'Could not load top books: $error',
      );

      if (!mounted) return;

      setState(() {
        isLoadingBooks = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not load books: $error',
          ),
        ),
      );
    }
  }

  Future<Map<String, dynamic>> _searchBookDetails(
    String title,
  ) async {
    try {
      final url = Uri.https(
        'openlibrary.org',
        '/search.json',
        {
          'title': title,
          'limit': '1',
          'fields':
              'title,author_name,cover_i,'
              'ratings_average,ratings_count',
        },
      );

      final response = await http.get(
        url,
        headers: const {
          'User-Agent': 'Readscape School Project',
        },
      );

      if (response.statusCode != 200) {
        return {};
      }

      final data =
          jsonDecode(response.body)
              as Map<String, dynamic>;

      final docs =
          data['docs'] as List<dynamic>? ?? [];

      if (docs.isEmpty) {
        return {};
      }

      final book =
          docs.first as Map<String, dynamic>;

      String? author;

      final authorNames =
          book['author_name'];

      if (authorNames is List &&
          authorNames.isNotEmpty) {
        author =
            authorNames.first.toString();
      }

      String? image;

      final coverId =
          book['cover_i'];

      if (coverId != null) {
        image =
            'https://covers.openlibrary.org/b/id/'
            '$coverId-L.jpg';
      }

      double? rating;

      final ratingsAverage =
          book['ratings_average'];

      if (ratingsAverage is num) {
        rating =
            ratingsAverage.toDouble();
      }

      return {
        'title':
            book['title']?.toString(),
        'author': author,
        'image': image,
        'rating': rating,
      };
    } catch (error) {
      debugPrint(
        'Could not get details for "$title": $error',
      );

      return {};
    }
  }

  Future<void> _saveCollectionStatus({
    required String title,
    required String author,
    required String? image,
    required String status,
  }) async {
    try {
      final supabase =
          Supabase.instance.client;

      final user =
          supabase.auth.currentUser;

      if (user == null) {
        throw Exception(
          'User not logged in.',
        );
      }

      final existing = await supabase
          .from('user_books')
          .select('id')
          .eq('user_id', user.id)
          .eq('book_title', title)
          .maybeSingle();

      if (existing != null) {
        await supabase
            .from('user_books')
            .update({
          'book_author': author,
          'book_image': image,
          'collection_status': status,
        }).eq(
          'id',
          existing['id'],
        );
      } else {
        await supabase
            .from('user_books')
            .insert({
          'user_id': user.id,
          'book_title': title,
          'book_author': author,
          'book_image': image,
          'collection_status': status,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '$title added to your collection.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not add book: $error',
          ),
        ),
      );
    }
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
                      'Top 10 Books',
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
                      "Browse today's most popular and trending books",
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

                  if (isLoadingBooks)
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: Center(
                        child:
                            CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (books.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(
                        top: 30,
                      ),
                      child: Center(
                        child: Text(
                          'No books found.',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Georgia',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    ...books.map(
                      (book) => _bookCard(book),
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
                  activeNav == 'Top 10',
                  () {
                    setState(() {
                      activeNav = 'Top 10';
                    });
                  },
                ),

                const SizedBox(width: 20),

                _navText(
                  'History',
                  activeNav == 'History',
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
          fontWeight: isActive
              ? FontWeight.bold
              : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _bookCard(
    Map<String, dynamic> book,
  ) {
    final image = book['image'];

    final rating =
        (book['rating'] as num).toDouble();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 32,
            child: Text(
              '${book['rank']}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(width: 12),

          Container(
            width: 75,
            height: 110,
            decoration: BoxDecoration(
              borderRadius:
                  BorderRadius.circular(4),
              color: cream,
            ),
            child: image != null &&
                    image.toString().isNotEmpty
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(4),
                    child: Image.network(
                      image.toString(),
                      fit: BoxFit.cover,
                      errorBuilder:
                          (
                            context,
                            error,
                            stackTrace,
                          ) {
                        return const Icon(
                          Icons.menu_book,
                          color: maroon,
                          size: 32,
                        );
                      },
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
                  book['title'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  book['author'].toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 8),

                Row(
                  children: [
                    ..._ratingStars(rating),

                    const SizedBox(width: 6),

                    Text(
                      rating > 0
                          ? rating.toStringAsFixed(1)
                          : 'No rating',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _saveCollectionStatus(
                          title:
                              book['title'].toString(),
                          author:
                              book['author'].toString(),
                          image:
                              image?.toString(),
                          status: 'want_to_read',
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: cream,
                        foregroundColor: maroon,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                      ),
                      child: const Text(
                        'Want to read',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 11,
                        ),
                      ),
                    ),

                    ElevatedButton(
                      onPressed: () {
                        _saveCollectionStatus(
                          title:
                              book['title'].toString(),
                          author:
                              book['author'].toString(),
                          image:
                              image?.toString(),
                          status: 'already_read',
                        );
                      },
                      style:
                          ElevatedButton.styleFrom(
                        backgroundColor: cream,
                        foregroundColor: maroon,
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        minimumSize: Size.zero,
                        tapTargetSize:
                            MaterialTapTargetSize
                                .shrinkWrap,
                      ),
                      child: const Text(
                        'Add to Collection',
                        style: TextStyle(
                          fontFamily: 'Georgia',
                          fontSize: 11,
                        ),
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