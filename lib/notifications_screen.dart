import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'sidemenu_screen.dart';

class NotificationsScreen
    extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState
    extends State<NotificationsScreen> {
  static const Color cream =
      Color(0xFFF9E8A2);

  static const Color maroon =
      Color(0xFF7A1F2B);

  final List<Map<String, dynamic>>
      notifications = [];

  bool isLoadingNotifications = true;

  String activeNav = '';

  // ============================================================
  // LOAD NOTIFICATIONS
  // ============================================================

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        if (!mounted) return;

        setState(() {
          isLoadingNotifications = false;
        });

        return;
      }

      final data = await supabase
          .from('user_books')
          .select(
            'book_title, rating, collection_status, is_favorite, last_read_at, created_at',
          )
          .eq('user_id', user.id)
          .order(
            'created_at',
            ascending: false,
          );

      if (!mounted) return;

      final List<Map<String, dynamic>>
          loadedNotifications = [];

      for (final row in data) {
        final title =
            row['book_title']?.toString() ??
                'Unknown book';

        final rating = row['rating'];

        final collectionStatus =
            row['collection_status']
                ?.toString();

        final isFavorite =
            row['is_favorite'] == true;

        final lastReadAt =
            row['last_read_at'];

        final createdAt =
            row['created_at'];

        // --------------------------------------------------------
        // FAVORITE NOTIFICATION
        // --------------------------------------------------------

        if (isFavorite) {
          loadedNotifications.add({
            'icon': Icons.favorite,
            'title': 'Added to Favorites',
            'message':
                '$title was added to your favorites.',
            'time': _formatRelativeTime(
              createdAt,
            ),
            'date': _parseDate(createdAt),
          });
        }

        // --------------------------------------------------------
        // COLLECTION NOTIFICATION
        // --------------------------------------------------------

        if (collectionStatus != null) {
          String collectionText;

          switch (collectionStatus) {
            case 'want_to_read':
              collectionText =
                  'Want to Read';
              break;

            case 'reading':
              collectionText =
                  'Reading';
              break;

            case 'already_read':
              collectionText =
                  'Already Read';
              break;

            default:
              collectionText =
                  'Collection';
          }

          loadedNotifications.add({
            'icon':
                Icons.collections_bookmark,
            'title':
                'Added to Collection',
            'message':
                '$title was added to your $collectionText list.',
            'time': _formatRelativeTime(
              createdAt,
            ),
            'date': _parseDate(createdAt),
          });
        }

        // --------------------------------------------------------
        // RATING NOTIFICATION
        // --------------------------------------------------------

        if (rating != null) {
          final ratingValue =
              (rating as num).toDouble();

          loadedNotifications.add({
            'icon': Icons.star,
            'title': 'Book Rated',
            'message':
                'You rated $title ${ratingValue.toStringAsFixed(1)}.',
            'time': _formatRelativeTime(
              createdAt,
            ),
            'date': _parseDate(createdAt),
          });
        }

        // --------------------------------------------------------
        // READING HISTORY NOTIFICATION
        // --------------------------------------------------------

        if (lastReadAt != null) {
          loadedNotifications.add({
            'icon': Icons.menu_book,
            'title': 'Reading History',
            'message':
                'You opened $title.',
            'time': _formatRelativeTime(
              lastReadAt,
            ),
            'date': _parseDate(lastReadAt),
          });
        }
      }

      // ----------------------------------------------------------
      // SORT NEWEST FIRST
      // ----------------------------------------------------------

      loadedNotifications.sort(
        (a, b) {
          final DateTime dateA =
              a['date'] as DateTime;

          final DateTime dateB =
              b['date'] as DateTime;

          return dateB.compareTo(dateA);
        },
      );

      setState(() {
        notifications
          ..clear()
          ..addAll(
            loadedNotifications,
          );

        isLoadingNotifications = false;
      });
    } catch (error) {
      debugPrint(
        'Could not load notifications: $error',
      );

      if (!mounted) return;

      setState(() {
        isLoadingNotifications = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content: Text(
            'Could not load notifications: $error',
          ),
        ),
      );
    }
  }

  // ============================================================
  // PARSE DATE
  // ============================================================

  DateTime _parseDate(
    dynamic value,
  ) {
    if (value == null) {
      return DateTime.fromMillisecondsSinceEpoch(
        0,
      );
    }

    try {
      return DateTime.parse(
        value.toString(),
      ).toLocal();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(
        0,
      );
    }
  }

  // ============================================================
  // FORMAT RELATIVE TIME
  // ============================================================

  String _formatRelativeTime(
    dynamic value,
  ) {
    final date = _parseDate(value);

    if (date.millisecondsSinceEpoch == 0) {
      return '';
    }

    final now = DateTime.now();

    final difference =
        now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      final minutes =
          difference.inMinutes;

      return minutes == 1
          ? '1 minute ago'
          : '$minutes minutes ago';
    }

    if (difference.inHours < 24) {
      final hours =
          difference.inHours;

      return hours == 1
          ? '1 hour ago'
          : '$hours hours ago';
    }

    if (difference.inDays < 7) {
      final days =
          difference.inDays;

      return days == 1
          ? 'Yesterday'
          : '$days days ago';
    }

    return _formatDate(date);
  }

  // ============================================================
  // FORMAT DATE
  // ============================================================

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

    return '${months[date.month - 1]} '
        '${date.day}, '
        '${date.year}';
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
              child: ListView(
                padding: const EdgeInsets.only(
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
                      'Notifications',
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
                      'Stay updated on your reading journey and favorite books.',
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

                  if (isLoadingNotifications)
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
                  else if (notifications.isEmpty)
                    const Padding(
                      padding:
                          EdgeInsets.only(
                        top: 30,
                      ),
                      child: Center(
                        child: Text(
                          'No notifications yet.',
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
                    ...notifications.map(
                      (notification) =>
                          _notificationCard(
                        notification,
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
  // TOP NAVIGATION
  // ============================================================

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
                      Icons.notifications,
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

  // ============================================================
  // NOTIFICATION CARD
  // ============================================================

  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Container(
        padding:
            const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cream,
          borderRadius:
              BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Icon(
              notification['icon'],
              color: maroon,
              size: 24,
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    notification['title'],
                    style:
                        const TextStyle(
                      color: maroon,
                      fontFamily:
                          'Georgia',
                      fontSize: 14,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    notification['message'],
                    style:
                        const TextStyle(
                      color: maroon,
                      fontFamily:
                          'Georgia',
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    notification['time'],
                    style:
                        const TextStyle(
                      color: maroon,
                      fontFamily:
                          'Georgia',
                      fontSize: 10,
                      fontStyle:
                          FontStyle.italic,
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
}