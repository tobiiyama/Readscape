import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'topbooks_screen.dart';
import 'history_screen.dart';
import 'favorites_screen.dart';
import 'search_screen.dart';
import 'sidemenu_screen.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() =>
      _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  static const Color cream = Color(0xFFF9E8A2);
  static const Color maroon = Color(0xFF7A1F2B);

  final List<Map<String, dynamic>> notifications = [];

  bool isLoadingNotifications = true;
  String activeNav = '';

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  // LOAD NOTIFICATIONS FROM SUPABASE
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
          .from('notifications')
          .select('id, type, title, message, created_at, is_read')
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final List<Map<String, dynamic>> loadedNotifications =
          data.map<Map<String, dynamic>>((row) {
        final type = row['type']?.toString();
        final createdAt = row['created_at'];

        IconData icon;

        switch (type) {
          case 'favorite':
            icon = Icons.favorite;
            break;
          case 'rating':
            icon = Icons.star;
            break;
          case 'history':
            icon = Icons.menu_book;
            break;
          case 'collection':
            icon = Icons.collections_bookmark;
            break;
          default:
            icon = Icons.notifications;
        }

        return {
          'id': row['id'],
          'icon': icon,
          'title': row['title']?.toString() ?? 'Notification',
          'message': row['message']?.toString() ?? '',
          'time': _formatRelativeTime(createdAt),
          'date': _parseDate(createdAt),
          'is_read': row['is_read'] == true,
        };
      }).toList();

      if (!mounted) return;

      setState(() {
        notifications
          ..clear()
          ..addAll(loadedNotifications);

        isLoadingNotifications = false;
      });
    } catch (error) {
      debugPrint('Could not load notifications: $error');

      if (!mounted) return;

      setState(() {
        isLoadingNotifications = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not load notifications: $error'),
        ),
      );
    }
  }

  // MARK NOTIFICATION AS READ
  Future<void> _markAsRead(
    Map<String, dynamic> notification,
  ) async {
    if (notification['is_read'] == true) return;

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;

      if (user == null) {
        throw Exception('User not logged in.');
      }

      await supabase
          .from('notifications')
          .update({'is_read': true})
          .eq('id', notification['id'])
          .eq('user_id', user.id);

      if (!mounted) return;

      setState(() {
        notification['is_read'] = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notification marked as read.'),
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not mark notification as read: $error'),
        ),
      );
    }
  }

  // PARSE DATE
  DateTime _parseDate(dynamic value) {
    if (value == null) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    try {
      return DateTime.parse(value.toString()).toLocal();
    } catch (_) {
      return DateTime.fromMillisecondsSinceEpoch(0);
    }
  }

  // FORMAT RELATIVE TIME
  String _formatRelativeTime(dynamic value) {
    final date = _parseDate(value);

    if (date.millisecondsSinceEpoch == 0) {
      return '';
    }

    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return minutes == 1 ? '1 minute ago' : '$minutes minutes ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return hours == 1 ? '1 hour ago' : '$hours hours ago';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return days == 1 ? 'Yesterday' : '$days days ago';
    }

    return _formatDate(date);
  }

  // FORMAT DATE
  String _formatDate(DateTime date) {
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

    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  // BUILD SCREEN
  @override
  Widget build(BuildContext context) {
    final unreadCount = notifications
        .where((notification) => notification['is_read'] != true)
        .length;

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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Notifications',
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
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Stay updated on your reading journey and favorite books.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Georgia',
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (!isLoadingNotifications &&
                      notifications.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        unreadCount == 0
                            ? 'You are all caught up!'
                            : '$unreadCount unread '
                                '${unreadCount == 1 ? 'notification' : 'notifications'}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: cream,
                          fontFamily: 'Georgia',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  if (isLoadingNotifications)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    )
                  else if (notifications.isEmpty)
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Center(
                        child: Text(
                          'No notifications yet.',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Georgia',
                            fontSize: 12,
                          ),
                        ),
                      ),
                    )
                  else
                    ...notifications.map(
                      (notification) =>
                          _notificationCard(notification),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // TOP NAVIGATION
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
                  icon: const Icon(
                    Icons.menu,
                    color: maroon,
                  ),
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
                _navText('Top 10', activeNav == 'Top 10', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TopBooksScreen(),
                    ),
                  );
                }),
                const SizedBox(width: 20),
                _navText('History', activeNav == 'History', () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                }),
                const SizedBox(width: 20),
                _navText('Favorites', activeNav == 'Favorites', () {
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
                      Icons.notifications,
                      color: maroon,
                      size: 22,
                    ),
                    onPressed: _loadNotifications,
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

  // NAVIGATION TEXT
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
          fontWeight:
              isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // NOTIFICATION CARD
  Widget _notificationCard(
    Map<String, dynamic> notification,
  ) {
    final isRead = notification['is_read'] == true;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: cream,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isRead ? cream : Colors.white,
            width: isRead ? 1 : 2,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              notification['icon'] as IconData,
              color: maroon,
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          notification['title']?.toString() ??
                              'Notification',
                          style: TextStyle(
                            color: maroon,
                            fontFamily: 'Georgia',
                            fontSize: 14,
                            fontWeight: isRead
                                ? FontWeight.normal
                                : FontWeight.bold,
                          ),
                        ),
                      ),
                      if (!isRead)
                        const Text(
                          'NEW',
                          style: TextStyle(
                            color: maroon,
                            fontFamily: 'Georgia',
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message']?.toString() ?? '',
                    style: const TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    notification['time']?.toString() ?? '',
                    style: const TextStyle(
                      color: maroon,
                      fontFamily: 'Georgia',
                      fontSize: 10,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),

                  if (!isRead)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => _markAsRead(notification),
                        icon: const Icon(
                          Icons.check_circle_outline,
                          size: 16,
                          color: maroon,
                        ),
                        label: const Text(
                          'Mark as read',
                          style: TextStyle(
                            color: maroon,
                            fontFamily: 'Georgia',
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                  else
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Read',
                        style: TextStyle(
                          color: maroon,
                          fontFamily: 'Georgia',
                          fontSize: 10,
                          fontStyle: FontStyle.italic,
                        ),
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