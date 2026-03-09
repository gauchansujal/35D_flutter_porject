import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/admin/domain/entites/admin_user_entity.dart';
import 'package:flutter_application_1/features/admin/presentation/provider/state/admin_user_state.dart';
import 'package:flutter_application_1/features/admin/presentation/viewmodel/admin_user_viewmodel.dart';
import 'package:flutter_application_1/features/admin/presentation/widget/admin_user_widget.dart';
import 'package:flutter_application_1/features/admin/presentation/widget/user_form_dialog.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(adminUserViewModelProvider.notifier).fetchAllUsers(page: 1); // ✅
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateDialog() {
    showDialog(context: context, builder: (_) => const UserFormDialog());
  }

  void _showEditDialog(UserEntity user) {
    showDialog(context: context, builder: (_) => UserFormDialog(user: user));
  }

  void _confirmDelete(String id, String username) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Delete User'),
            content: Text('Are you sure you want to delete "$username"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                onPressed: () {
                  Navigator.of(context).pop();
                  ref.read(adminUserViewModelProvider.notifier).deleteUser(id);
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminUserViewModelProvider);

    ref.listen<AdminUserState>(adminUserViewModelProvider, (prev, next) {
      if (next.successMessage != null &&
          next.successMessage != prev?.successMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.successMessage!),
            backgroundColor: Colors.green,
          ),
        );
      }
      if (next.isError && next.errorMessage != prev?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin — Users',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed:
                () => ref
                    .read(adminUserViewModelProvider.notifier)
                    .fetchAllUsers(page: 1), // ✅
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateDialog,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add User'),
      ),
      body: Column(
        children: [
          // ── Search — hits backend ✅ ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              controller: _searchController,
              onChanged: (v) {
                ref
                    .read(adminUserViewModelProvider.notifier)
                    .fetchAllUsers(
                      page: 1,
                      search: v.trim(),
                    ); // ✅ backend search
              },
              decoration: InputDecoration(
                hintText: 'Search by username or email…',
                prefixIcon: const Icon(Icons.search),
                suffixIcon:
                    _searchController.text.isNotEmpty
                        ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref
                                .read(adminUserViewModelProvider.notifier)
                                .fetchAllUsers(page: 1); // ✅ clear search
                          },
                        )
                        : null,
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // ── Stats ✅ — total from backend ──
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _StatChip(
                  label: 'Total',
                  count: state.totalItems, // ✅ from backend (34)
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Admins',
                  count: state.users.where((u) => u.isAdmin).length,
                  color: Colors.deepPurple,
                ),
                const SizedBox(width: 8),
                _StatChip(
                  label: 'Users',
                  count: state.users.where((u) => u.isUser).length,
                  color: Colors.teal,
                ),
              ],
            ),
          ),
          const Divider(height: 16),

          // ── Body ──
          Expanded(
            child: switch (state.status) {
              AdminUserStatus.loading when state.users.isEmpty => const Center(
                child: CircularProgressIndicator(),
              ),

              AdminUserStatus.error when state.users.isEmpty => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 52,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      state.errorMessage ?? 'Something went wrong',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 14),
                    ElevatedButton.icon(
                      onPressed:
                          () => ref
                              .read(adminUserViewModelProvider.notifier)
                              .fetchAllUsers(page: 1),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Retry'),
                    ),
                  ],
                ),
              ),

              _ when state.users.isEmpty => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_outline,
                      size: 64,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'No users found.',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              _ => RefreshIndicator(
                onRefresh:
                    () => ref
                        .read(adminUserViewModelProvider.notifier)
                        .fetchAllUsers(page: state.currentPage),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: state.users.length, // ✅ no local filter
                  itemBuilder: (_, i) {
                    final user = state.users[i];
                    return UserCardWidget(
                      user: user,
                      onEdit: () => _showEditDialog(user),
                      onDelete: () => _confirmDelete(user.id, user.username),
                    );
                  },
                ),
              ),
            },
          ),

          // ── Pagination bar ✅ ──
          if (state.totalPages > 1)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed:
                        state.hasPrevPage
                            ? () => ref
                                .read(adminUserViewModelProvider.notifier)
                                .fetchAllUsers(page: state.currentPage - 1)
                            : null,
                  ),
                  Text(
                    'Page ${state.currentPage} of ${state.totalPages}  ·  ${state.totalItems} users',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed:
                        state.hasNextPage
                            ? () => ref
                                .read(adminUserViewModelProvider.notifier)
                                .fetchAllUsers(page: state.currentPage + 1)
                            : null,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$count',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 15,
            ),
          ),
          const SizedBox(width: 4),
          Text(label, style: TextStyle(color: color, fontSize: 12)),
        ],
      ),
    );
  }
}
