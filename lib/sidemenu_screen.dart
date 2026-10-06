import 'package:flutter/material.dart';

import 'ratedbooks_screen.dart';
import 'collection_screen.dart';
import 'main.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  static const Color darkMaroon =
      Color(0xFF3B1512);

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        width: 200,
        height: screenHeight * 0.73,
        decoration: const BoxDecoration(
          color: darkMaroon,
        ),
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),

              // ==================================================
              // PROFILE ICON
              // ==================================================

              Center(
                child: Container(
                  width: 74,
                  height: 74,
                  decoration:
                      BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 42,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // USERNAME
              // ==================================================

              const Center(
                child: Text(
                  'lowe',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 24,
                  ),
                ),
              ),

              const SizedBox(height: 2),

              // ==================================================
              // NAME
              // ==================================================

              const Center(
                child: Text(
                  'Chloe Cabrera',
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Georgia',
                    fontSize: 14,
                  ),
                ),
              ),

              const SizedBox(height: 55),

              // ==================================================
              // RATED BOOKS
              // ==================================================

              _menuItem(
                context,
                Icons.star_border,
                'Rated Books',
                () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const RatedBooksScreen(),
                    ),
                  );
                },
              ),

              // ==================================================
              // COLLECTION
              // ==================================================

              _menuItem(
                context,
                Icons.bookmark_border,
                'Collection',
                () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const CollectionScreen(),
                    ),
                  );
                },
              ),

              // ==================================================
              // HELP
              // ==================================================

              _menuItem(
                context,
                Icons.help_outline,
                'Help',
                () {
                  Navigator.pop(context);
                },
              ),

              // ==================================================
              // SETTINGS
              // ==================================================

              _menuItem(
                context,
                Icons.settings_outlined,
                'Settings',
                () {
                  Navigator.pop(context);
                },
              ),

              // ==================================================
              // LOG OUT
              // ==================================================

              _menuItem(
                context,
                Icons.logout,
                'Log Out',
                () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // MENU ITEM
  // ============================================================

  Widget _menuItem(
    BuildContext context,
    IconData icon,
    String title,
    VoidCallback onPressed,
  ) {
    return SizedBox(
      height: 48,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          alignment:
              Alignment.centerLeft,
          foregroundColor:
              Colors.white,
          minimumSize: Size.zero,
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 21,
            ),

            const SizedBox(width: 10),

            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Georgia',
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}