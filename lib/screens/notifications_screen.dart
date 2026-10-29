import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/app_notification.dart';
import '../providers/program_provider.dart';
import '../utils/theme.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgramProvider>();
    final all = provider.notifications;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notifications',
              style: TextStyle(fontWeight: FontWeight.w800)),
          actions: [
            TextButton(
              onPressed: provider.markAllRead,
              child: const Text('Mark all read'),
            ),
          ],
          bottom: TabBar(
            labelColor: AppColors.indigo,
            indicatorColor: AppColors.indigo,
            tabs: [
              const Tab(text: 'All'),
              Tab(text: 'Unread (${provider.unreadCount})'),
              const Tab(text: 'Read'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _NotificationList(items: all),
            _NotificationList(items: all.where((n) => !n.read).toList()),
            _NotificationList(items: all.where((n) => n.read).toList()),
          ],
        ),
      ),
    );
  }
}

class _NotificationList extends StatelessWidget {
  final List<AppNotification> items;
  const _NotificationList({required this.items});

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ProgramProvider>();

    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: provider.reloadNotifications,
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: const Center(
                child: Text('Nothing here', style: TextStyle(color: AppColors.muted)),
              ),
            ),
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: provider.reloadNotifications,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final n = items[i];
          return GestureDetector(
            onTap: () => provider.markRead(n.id),
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: n.read ? Colors.white : const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: AppColors.lavender,
                  child: Icon(n.icon, color: AppColors.indigo, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(n.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.navy)),
                      const SizedBox(height: 2),
                      Text(n.message,
                          style: const TextStyle(
                              fontSize: 13, color: AppColors.muted)),
                      const SizedBox(height: 4),
                      Text(n.timeAgo,
                          style: const TextStyle(
                              fontSize: 11, color: AppColors.muted)),
                    ],
                  ),
                ),
                if (!n.read)
                  const Padding(
                    padding: EdgeInsets.only(top: 6),
                    child: CircleAvatar(
                        radius: 4, backgroundColor: AppColors.indigo),
                  ),
              ],
            ),
          ),
        );
      },
    ),
  );
  }
}
