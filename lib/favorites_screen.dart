import 'package:flutter/material.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'search_screen.dart';
import 'notifications_screen.dart';
import 'sidemenu_screen.dart';

// ============================================================
// FAVORITE BOOKS
// ============================================================

final List<Map<String, dynamic>> favoriteBooks = [
  {
    'title': 'Fire and Blood',
    'image': 'assets/images/fire_and_blood.jpg',
  },
  {
    'title': 'A Game of Thrones',
    'image': 'assets/images/a_game_of_thrones.jpg',
  },
  {
    'title':
        'Harry Potter and the Chamber of Secrets',
    'image':
        'assets/images/harry_potter_chamber_of_secrets.jpg',
  },
  {
    'title': 'Mockingjay',
    'image': 'assets/images/mockingjay.jpg',
  },
  {
    'title': 'One of Us Is Lying',
    'image':
        'assets/images/one_of_us_is_lying.jpg',
  },
];

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
                      textAlign: TextAlign.center,
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

                    if (favoriteBooks.isEmpty)
                      const Padding(
                        padding:
                            EdgeInsets.only(
                          top: 30,
                        ),
                        child: Text(
                          'No favorite books yet.',
                          style: TextStyle(
                            color: Colors.white,
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
        setState(() {
          favoriteBooks.remove(book);
        });
      },
      child: SizedBox(
        height: 155,
        child: Stack(
          clipBehavior: Clip.none,
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
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(1, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(
                    2,
                  ),
                  child: Image.asset(
                    book['image'],
                    width: 88,
                    height: 132,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context,
                            error,
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
                ),
              ),
            ),

            Positioned(
              left: 4,
              bottom: 2,
              child: Icon(
                Icons.favorite,
                color: Colors.red.shade700,
                size: 36,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopNavigation(
      BuildContext context) {
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
                      Navigator.push(
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