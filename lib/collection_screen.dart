import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'notifications_screen.dart';
import 'search_screen.dart';
import 'sidemenu_screen.dart';

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

  // ============================================================
  // COLLECTION DATA
  // ============================================================

  final List<Map<String, String>> wantToReadBooks = [];
  final List<Map<String, String>> readingBooks = [];
  final List<Map<String, String>> alreadyReadBooks = [];

  bool isLoadingCollection = true;

  // ============================================================
  // BOOK IMAGE LOOKUP
  // ============================================================
  //
  // These are only used to find the local cover image.
  // The actual collection belongs to the logged-in user
  // and comes from Supabase.
  //

  final Map<String, String> bookImages = {
    'Heated Rivalry':
        'assets/images/heated_rivalry.jpg',

    'Little Women':
        'assets/images/little_women.jpg',

    'Credence':
        'assets/images/credence.jpg',

    'Pride and Prejudice':
        'assets/images/pride_and_prejudice.jpg',

    'Bridgerton':
        'assets/images/bridgerton.jpg',

    'One Day':
        'assets/images/one_day.jpg',

    'Mockingjay':
        'assets/images/mockingjay.jpg',

    'Harry Potter and the Chamber of Secrets':
        'assets/images/harry_potter_chamber_of_secrets.jpg',
  };

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadCollection();
  }

  // ============================================================
  // LOAD COLLECTION FROM SUPABASE
  // ============================================================

  Future<void> _loadCollection() async {
    try {
      final supabase =
          Supabase.instance.client;

      final user =
          supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoadingCollection = false;
        });

        return;
      }

      final data = await supabase
          .from('user_books')
          .select(
            'book_title, book_author, book_image, collection_status',
          )
          .eq('user_id', user.id)
          .not(
            'collection_status',
            'is',
            null,
          );

      if (!mounted) return;

      wantToReadBooks.clear();
      readingBooks.clear();
      alreadyReadBooks.clear();

      for (final row in data) {
        final title =
            row['book_title'] as String?;

        if (title == null ||
            title.isEmpty) {
          continue;
        }

        final author =
            row['book_author'] as String? ?? '';

        final databaseImage =
            row['book_image'] as String? ?? '';

        final localImage =
            bookImages[title] ?? '';

        final image =
            databaseImage.isNotEmpty
                ? databaseImage
                : localImage;

        final book = {
          'title': title,
          'author': author,
          'image': image,
        };

        final status =
            row['collection_status']
                as String?;

        if (status == 'want_to_read') {
          wantToReadBooks.add(book);
        } else if (status == 'reading') {
          readingBooks.add(book);
        } else if (status == 'already_read') {
          alreadyReadBooks.add(book);
        }
      }

      setState(() {
        isLoadingCollection = false;
      });
    } catch (error) {
      debugPrint(
        'Could not load collection: $error',
      );

      if (!mounted) return;

      setState(() {
        isLoadingCollection = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Could not load your collection.',
          ),
        ),
      );
    }
  }

  // ============================================================
  // REMOVE BOOK FROM COLLECTION
  // ============================================================

  Future<void> _removeFromCollection(
    String title,
  ) async {
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

      await supabase
          .from('user_books')
          .update({
        'collection_status': null,
      })
          .eq(
            'user_id',
            user.id,
          )
          .eq(
            'book_title',
            title,
          );

      if (!mounted) return;

      await _loadCollection();

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Removed from collection.',
          ),
        ),
      );
    } catch (error) {
      debugPrint(
        'Could not remove book: $error',
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not remove the book: $error',
          ),
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
                padding:
                    const EdgeInsets.only(
                  bottom: 30,
                ),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 34),

                    const Center(
                      child: Text(
                        'Collection',
                        textAlign:
                            TextAlign.center,
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

                    Center(
                      child: SizedBox(
                        width: 340,
                        child: const Text(
                          'Manage your reading lists and easily track books\n'
                          'you want to read, are reading, and have finished.',
                          textAlign:
                              TextAlign.center,
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

                    if (isLoadingCollection)
                      const Center(
                        child: Padding(
                          padding:
                              EdgeInsets.only(
                            top: 20,
                            bottom: 20,
                          ),
                          child:
                              CircularProgressIndicator(
                            color: cream,
                          ),
                        ),
                      )
                    else ...[
                      _buildSection(
                        title: 'I want to read',
                        books:
                            wantToReadBooks,
                      ),

                      const SizedBox(height: 18),

                      _buildSection(
                        title: "I'm reading",
                        books:
                            readingBooks,
                      ),

                      const SizedBox(height: 18),

                      _buildSection(
                        title: 'I already read',
                        books:
                            alreadyReadBooks,
                      ),
                    ],
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
          fontWeight: isActive
              ? FontWeight.bold
              : FontWeight.normal,
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

        if (books.isEmpty)
          const Padding(
            padding:
                EdgeInsets.only(
              left: 48,
              right: 48,
            ),
            child: Text(
              'No books yet.',
              style: TextStyle(
                color: Colors.white70,
                fontFamily: 'Georgia',
                fontSize: 11,
                fontStyle:
                    FontStyle.italic,
              ),
            ),
          )
        else
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
        child: image.isEmpty
            ? const Center(
                child: Icon(
                  Icons.menu_book,
                  color: maroon,
                  size: 42,
                ),
              )
            : image.startsWith('http')
                ? Image.network(
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
                  )
                : Image.asset(
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
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding:
                const EdgeInsets.all(20),
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
                    fontSize: 18,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                ListTile(
                  leading: const Icon(
                    Icons.menu_book,
                    color: maroon,
                  ),
                  title: const Text(
                    'View Book',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(
                      sheetContext,
                    );
                  },
                ),

                ListTile(
                  leading: const Icon(
                    Icons.delete_outline,
                    color: maroon,
                  ),
                  title: const Text(
                    'Remove from Collection',
                    style: TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                    ),
                  ),
                  onTap: () async {
                    Navigator.pop(
                      sheetContext,
                    );

                    await _removeFromCollection(
                      title,
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
}