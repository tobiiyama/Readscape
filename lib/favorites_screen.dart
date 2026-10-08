import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';
import 'sidemenu_screen.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {
  static const Color cream =
      Color(0xFFF9E8A2);

  static const Color maroon =
      Color(0xFF7A1F2B);

  final List<Map<String, dynamic>>
      favoriteBooks = [];

  bool isLoadingFavorites = true;

  String activeNav = 'Favorites';

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    try {
      final supabase =
          Supabase.instance.client;

      final user =
          supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoadingFavorites = false;
        });

        return;
      }

      final data = await supabase
          .from('user_books')
          .select(
            'book_title, book_author, book_image, is_favorite',
          )
          .eq('user_id', user.id)
          .eq('is_favorite', true);

      if (!mounted) return;

      setState(() {
        favoriteBooks.clear();

        for (final row in data) {
          favoriteBooks.add({
            'title':
                row['book_title'] ??
                    'Unknown title',
            'author':
                row['book_author'] ??
                    'Unknown author',
            'image':
                row['book_image'],
          });
        }

        isLoadingFavorites = false;
      });
    } catch (error) {
      debugPrint(
        'Could not load favorites: $error',
      );

      if (!mounted) return;

      setState(() {
        isLoadingFavorites = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not load Favorites: $error',
          ),
        ),
      );
    }
  }

  Future<void> _removeFavorite(
    Map<String, dynamic> book,
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
        'is_favorite': false,
      })
          .eq('user_id', user.id)
          .eq(
            'book_title',
            book['title'],
          );

      if (!mounted) return;

      setState(() {
        favoriteBooks.remove(book);
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Removed from Favorites.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not remove favorite: $error',
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
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 22),

                    const Text(
                      'Favorites',
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

                    const SizedBox(height: 8),

                    const Padding(
                      padding:
                          EdgeInsets.symmetric(
                        horizontal: 45,
                      ),
                      child: Text(
                        'Save the books that captured your heart and made your favorites list',
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

                    const SizedBox(height: 22),

                    if (isLoadingFavorites)
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
                    else if (favoriteBooks.isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.only(
                          top: 30,
                        ),
                        child: Text(
                          'No favorite books yet.',
                          style: TextStyle(
                            color:
                                Colors.white,
                            fontFamily:
                                'Georgia',
                            fontSize: 12,
                          ),
                        ),
                      )
                    else
                      Padding(
                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal: 48,
                        ),
                        child:
                            GridView.builder(
                          shrinkWrap: true,
                          physics:
                              const NeverScrollableScrollPhysics(),
                          itemCount:
                              favoriteBooks
                                  .length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 28,
                            mainAxisSpacing: 10,
                            childAspectRatio:
                                0.72,
                          ),
                          itemBuilder:
                              (context,
                                  index) {
                            return _favoriteBook(
                              favoriteBooks[
                                  index],
                            );
                          },
                        ),
                      ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _favoriteBook(
    Map<String, dynamic> book,
  ) {
    return GestureDetector(
      onTap: () {
        _removeFavorite(book);
      },
      child: SizedBox(
        height: 155,
        child: Stack(
          clipBehavior:
              Clip.none,
          children: [
            Center(
              child: Container(
                width: 88,
                height: 132,
                decoration: BoxDecoration(
                  color: cream,
                  borderRadius:
                      BorderRadius.circular(
                    2,
                  ),
                  boxShadow:
                      const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset:
                          Offset(1, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    2,
                  ),
                  child:
                      _buildBookImage(
                    book,
                  ),
                ),
              ),
            ),

            Positioned(
              left: 4,
              bottom: 2,
              child: Icon(
                Icons.favorite,
                color:
                    Colors.red.shade700,
                size: 36,
              ),
            ),
          ],
        ),
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
            BorderRadius.circular(
          2,
        ),
        child: Image.network(
          image,
          width: 88,
          height: 132,
          fit: BoxFit.cover,
          errorBuilder:
              (context, error,
                  stackTrace) {
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
          BorderRadius.circular(
        2,
      ),
      child: Image.asset(
        image,
        width: 88,
        height: 132,
        fit: BoxFit.cover,
        errorBuilder:
            (context, error,
                stackTrace) {
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
              builder:
                  (drawerContext) {
                return IconButton(
                  icon:
                      const Icon(
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
                  MainAxisAlignment
                      .center,
              children: [
                _navText(
                  'Top 10',
                  false,
                  () {
                    Navigator
                        .pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const TopBooksScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  width: 20,
                ),

                _navText(
                  'History',
                  false,
                  () {
                    Navigator
                        .pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                const HistoryScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(
                  width: 20,
                ),

                _navText(
                  'Favorites',
                  true,
                  () {},
                ),
              ],
            ),
          ),

          SizedBox(
            width: 114,
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .end,
              children: [
                SizedBox(
                  width: 38,
                  child:
                      IconButton(
                    padding:
                        EdgeInsets.zero,
                    icon:
                        const Icon(
                      Icons
                          .notifications_none,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator
                          .pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  const NotificationsScreen(),
                        ),
                      );
                    },
                  ),
                ),

                SizedBox(
                  width: 38,
                  child:
                      IconButton(
                    padding:
                        EdgeInsets.zero,
                    icon:
                        const Icon(
                      Icons
                          .share_outlined,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                ),

                SizedBox(
                  width: 38,
                  child:
                      IconButton(
                    padding:
                        EdgeInsets.zero,
                    icon:
                        const Icon(
                      Icons.search,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: () {
                      Navigator
                          .pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
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
      style:
          TextButton.styleFrom(
        padding:
            const EdgeInsets
                .symmetric(
          horizontal: 4,
        ),
        minimumSize:
            Size.zero,
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
}