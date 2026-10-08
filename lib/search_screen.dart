import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

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
  bool isSearching = false;

  List<Map<String, dynamic>> searchResults = [];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEARCH
  // ============================================================

  Future<void> performSearch([String? value]) async {
    final entered =
        (value ?? searchController.text).trim();

    if (entered.isEmpty) {
      return;
    }

    searchHistory.removeWhere(
      (item) =>
          item.toLowerCase() ==
          entered.toLowerCase(),
    );

    searchHistory.insert(0, entered);

    setState(() {
      hasSearched = true;
      isSearching = true;
      searchResults = [];
    });

    try {
      final url = Uri.https(
        'openlibrary.org',
        '/search.json',
        {
          'q': entered,
          'limit': '20',
          'fields':
              'title,author_name,cover_i,'
              'key,first_publish_year,'
              'ratings_average',
        },
      );

      final response = await http.get(
        url,
        headers: const {
          'User-Agent': 'Readscape School Project',
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Search request failed.',
        );
      }

      final data =
          jsonDecode(response.body)
              as Map<String, dynamic>;

      final docs =
          data['docs'] as List<dynamic>? ?? [];

      final List<Map<String, dynamic>>
          loadedResults = [];

      for (final item in docs) {
        final book =
            item as Map<String, dynamic>;

        final title =
            book['title']?.toString();

        if (title == null ||
            title.trim().isEmpty) {
          continue;
        }

        String author = 'Unknown author';

        final authors =
            book['author_name'];

        if (authors is List &&
            authors.isNotEmpty) {
          author = authors.first.toString();
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

        loadedResults.add({
          'title': title,
          'author': author,
          'image': image,
          'rating': rating,
        });
      }

      if (!mounted) return;

      setState(() {
        searchResults = loadedResults;
        isSearching = false;
      });
    } catch (error) {
      debugPrint(
        'Could not search books: $error',
      );

      if (!mounted) return;

      setState(() {
        searchResults = [];
        isSearching = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not search books: $error',
          ),
        ),
      );
    }
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
  // SAVE BOOK TO READING HISTORY
  // ============================================================

  Future<void> _saveReadingHistory({
    required String title,
    required String author,
    required String? image,
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

      final bookData = {
        'book_author': author,
        'book_image': image,
        'last_read_at':
            DateTime.now()
                .toUtc()
                .toIso8601String(),
      };

      if (existing != null) {
        await supabase
            .from('user_books')
            .update(bookData)
            .eq('id', existing['id']);
      } else {
        await supabase
            .from('user_books')
            .insert({
          'user_id': user.id,
          'book_title': title,
          ...bookData,
        });
      }
    } catch (error) {
      debugPrint(
        'Could not save reading history: $error',
      );
    }
  }

  // ============================================================
  // SAVE COLLECTION STATUS
  // ============================================================

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

      final bookData = {
        'book_author': author,
        'book_image': image,
        'collection_status': status,
      };

      if (existing != null) {
        await supabase
            .from('user_books')
            .update(bookData)
            .eq('id', existing['id']);
      } else {
        await supabase
            .from('user_books')
            .insert({
          'user_id': user.id,
          'book_title': title,
          ...bookData,
        });
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _collectionStatusText(status),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not save the book: $error',
          ),
        ),
      );
    }
  }

  String _collectionStatusText(
    String status,
  ) {
    switch (status) {
      case 'want_to_read':
        return 'Added to Want to Read.';

      case 'reading':
        return 'Added to Reading.';

      case 'already_read':
        return 'Added to Already Read.';

      default:
        return 'Book saved.';
    }
  }

  // ============================================================
  // SAVE FAVORITE
  // ============================================================

  Future<void> _toggleFavorite({
    required String title,
    required String author,
    required String? image,
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
          .select('id, is_favorite')
          .eq('user_id', user.id)
          .eq('book_title', title)
          .maybeSingle();

      if (existing != null) {
        final currentlyFavorite =
            existing['is_favorite'] == true;

        await supabase
            .from('user_books')
            .update({
          'book_author': author,
          'book_image': image,
          'is_favorite':
              !currentlyFavorite,
        })
            .eq(
              'id',
              existing['id'],
            );

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          SnackBar(
            content: Text(
              currentlyFavorite
                  ? 'Removed from Favorites.'
                  : 'Added to Favorites.',
            ),
          ),
        );
      } else {
        await supabase
            .from('user_books')
            .insert({
          'user_id': user.id,
          'book_title': title,
          'book_author': author,
          'book_image': image,
          'is_favorite': true,
        });

        if (!mounted) return;

        ScaffoldMessenger.of(context)
            .showSnackBar(
          const SnackBar(
            content: Text(
              'Added to Favorites.',
            ),
          ),
        );
      }
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not update Favorites: $error',
          ),
        ),
      );
    }
  }

  // ============================================================
  // BOOK OPTIONS
  // ============================================================

  Future<void> _showBookOptions(
    Map<String, dynamic> book,
  ) async {
    await _saveReadingHistory(
      title: book['title'].toString(),
      author: book['author'].toString(),
      image: book['image']?.toString(),
    );

    if (!mounted) return;

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
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(
              vertical: 14,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Text(
                  book['title'].toString(),
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color: maroon,
                    fontFamily: 'Georgia',
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  book['author'].toString(),
                  textAlign:
                      TextAlign.center,
                  style:
                      const TextStyle(
                    color: maroon,
                    fontFamily: 'Georgia',
                    fontSize: 12,
                  ),
                ),

                const SizedBox(height: 12),

                ListTile(
                  leading: const Icon(
                    Icons.bookmark_border,
                    color: maroon,
                  ),
                  title: const Text(
                    'Want to Read',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(
                      sheetContext,
                    );

                    await _saveCollectionStatus(
                      title:
                          book['title']
                              .toString(),
                      author:
                          book['author']
                              .toString(),
                      image:
                          book['image']
                              ?.toString(),
                      status:
                          'want_to_read',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                    color: maroon,
                  ),
                  title: const Text(
                    'Reading',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(
                      sheetContext,
                    );

                    await _saveCollectionStatus(
                      title:
                          book['title']
                              .toString(),
                      author:
                          book['author']
                              .toString(),
                      image:
                          book['image']
                              ?.toString(),
                      status: 'reading',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.check_circle_outline,
                    color: maroon,
                  ),
                  title: const Text(
                    'Already Read',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(
                      sheetContext,
                    );

                    await _saveCollectionStatus(
                      title:
                          book['title']
                              .toString(),
                      author:
                          book['author']
                              .toString(),
                      image:
                          book['image']
                              ?.toString(),
                      status:
                          'already_read',
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.favorite_border,
                    color: maroon,
                  ),
                  title: const Text(
                    'Add to Favorites',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(
                      sheetContext,
                    );

                    await _toggleFavorite(
                      title:
                          book['title']
                              .toString(),
                      author:
                          book['author']
                              .toString(),
                      image:
                          book['image']
                              ?.toString(),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
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
                            const EdgeInsets
                                .symmetric(
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
                                TextInputAction
                                    .search,
                            style:
                                const TextStyle(
                              color: Colors.white,
                              fontFamily: 'Georgia',
                              fontSize: 12,
                            ),
                            decoration:
                                InputDecoration(
                              hintText:
                                  'Search',
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
                      child:
                          GestureDetector(
                        onTap: () {
                          searchController
                              .text = item;

                          performSearch(item);
                        },
                        child: Text(
                          item,
                          maxLines: 1,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            color: Colors.white,
                            fontFamily:
                                'Georgia',
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ),

                    GestureDetector(
                      onTap: () {
                        removeHistoryItem(
                          item,
                        );
                      },
                      child:
                          const Icon(
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
    if (isSearching) {
      return const Padding(
        padding: EdgeInsets.only(top: 30),
        child: Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      );
    }

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
    final image =
        book['image']?.toString() ?? '';

    return GestureDetector(
      onTap: () {
        _showBookOptions(book);
      },
      child: Container(
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
                color: Colors.white,
              ),
              child: _buildBookImage(
                image,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    book['title'].toString(),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
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
                    book['author'].toString(),
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 11,
                    ),
                  ),

                  const SizedBox(height: 5),

                  if (book['rating'] != null)
                    Text(
                      'Rating: '
                      '${(book['rating'] as num).toStringAsFixed(1)}',
                      style: const TextStyle(
                        color: maroon,
                        fontFamily:
                            'Georgia',
                        fontSize: 9,
                      ),
                    ),

                  const SizedBox(height: 3),

                  const Text(
                    'Tap for options',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 9,
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

  // ============================================================
  // BOOK IMAGE
  // ============================================================

  Widget _buildBookImage(
    String image,
  ) {
    if (image.isEmpty) {
      return const Center(
        child: Icon(
          Icons.menu_book,
          color: maroon,
          size: 28,
        ),
      );
    }

    if (image.startsWith('http')) {
      return ClipRRect(
        borderRadius:
            BorderRadius.circular(2),
        child: Image.network(
          image,
          width: 48,
          height: 70,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error, stackTrace) {
            return const Center(
              child: Icon(
                Icons.menu_book,
                color: maroon,
                size: 28,
              ),
            );
          },
        ),
      );
    }

    return ClipRRect(
      borderRadius:
          BorderRadius.circular(2),
      child: Image.asset(
        image,
        width: 48,
        height: 70,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error, stackTrace) {
          return const Center(
            child: Icon(
              Icons.menu_book,
              color: maroon,
              size: 28,
            ),
          );
        },
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