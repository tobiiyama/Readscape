import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'ratedbooks_screen.dart';
import 'collection_screen.dart';
import 'main.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  static const Color darkMaroon =
      Color(0xFF3B1512);

  String username = 'User';
  String? avatarUrl;

  bool isLoadingProfile = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // ============================================================
  // LOAD PROFILE FROM SUPABASE
  // ============================================================

  Future<void> _loadProfile() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoadingProfile = false;
        });

        return;
      }

      final data = await supabase
          .from('profiles')
          .select('username, avatar_url')
          .eq('id', user.id)
          .maybeSingle();

      if (!mounted) return;

      if (data != null) {
        setState(() {
          username =
              (data['username'] as String?) ?? 'User';

          avatarUrl =
              data['avatar_url'] as String?;

          isLoadingProfile = false;
        });
      } else {
        setState(() {
          isLoadingProfile = false;
        });
      }
    } catch (error) {
      debugPrint(
        'Could not load profile: $error',
      );

      if (!mounted) return;

      setState(() {
        isLoadingProfile = false;
      });
    }
  }

  // ============================================================
  // LOG OUT
  // ============================================================

  Future<void> _logout(
    BuildContext context,
  ) async {
    try {
      await Supabase.instance.client.auth.signOut();

      if (!context.mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              const WelcomeScreen(),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Could not log out: $error',
          ),
        ),
      );
    }
  }

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
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 2,
                    ),
                  ),
                  child: ClipOval(
                    child: avatarUrl != null &&
                            avatarUrl!.isNotEmpty
                        ? Image.network(
                            avatarUrl!,
                            width: 74,
                            height: 74,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (
                                  context,
                                  error,
                                  stackTrace,
                                ) {
                              return const Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 42,
                              );
                            },
                          )
                        : const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 42,
                          ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // ==================================================
              // USERNAME
              // ==================================================

              Center(
                child: isLoadingProfile
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        username,
                        style: const TextStyle(
                          color: Colors.white,
                          fontFamily: 'Georgia',
                          fontSize: 24,
                        ),
                      ),
              ),

              const SizedBox(height: 2),

              // ==================================================
              // NAME REMOVED
              // ==================================================

              const SizedBox.shrink(),

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
                  _logout(context);
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