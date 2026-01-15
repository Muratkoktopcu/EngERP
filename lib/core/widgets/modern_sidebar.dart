// lib/core/widgets/modern_sidebar.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// Navigation item model
class NavItem {
  final IconData icon;
  final IconData? activeIcon;
  final String label;
  final String route;

  const NavItem({
    required this.icon,
    this.activeIcon,
    required this.label,
    required this.route,
  });
}

/// 🎨 Modern Sidebar Widget
/// Premium tasarımlı, animasyonlu navigation drawer
class ModernSidebar extends StatelessWidget {
  final String? userDisplayName;
  final String? userEmail;
  final String? userRole;
  final String currentRoute;
  final void Function(String route) onNavigate;
  final VoidCallback onLogout;

  const ModernSidebar({
    super.key,
    this.userDisplayName,
    this.userEmail,
    this.userRole,
    required this.currentRoute,
    required this.onNavigate,
    required this.onLogout,
  });

  static const List<NavItem> _navItems = [
    NavItem(
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2,
      label: 'Stok Yönetimi',
      route: '/stock',
    ),
    NavItem(
      icon: Icons.calendar_month_outlined,
      activeIcon: Icons.calendar_month,
      label: 'Rezervasyon',
      route: '/reservation',
    ),
    NavItem(
      icon: Icons.check_circle_outline,
      activeIcon: Icons.check_circle,
      label: 'Satış Yönetimi',
      route: '/sales',
    ),
    NavItem(
      icon: Icons.cancel_outlined,
      activeIcon: Icons.cancel,
      label: 'İptal',
      route: '/cancel',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
        ),
      ),
      child: Column(
        children: [
          // Header with gradient
          _buildHeader(context),
          
          // User info card
          _buildUserCard(),
          
          const SizedBox(height: 8),
          
          // Navigation items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              itemCount: _navItems.length,
              itemBuilder: (context, index) {
                final item = _navItems[index];
                final isActive = currentRoute == item.route;
                return _NavItemTile(
                  item: item,
                  isActive: isActive,
                  onTap: () {
                    Navigator.pop(context);
                    if (!isActive) {
                      onNavigate(item.route);
                    }
                  },
                );
              },
            ),
          ),
          
          // Divider
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Divider(color: AppColors.border.withOpacity(0.5)),
          ),
          
          // Logout button
          _buildLogoutButton(context),
          
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        bottom: 24,
        left: 20,
        right: 20,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary,
            AppColors.primaryDark,
          ],
        ),
      ),
      child: Row(
        children: [
          // Logo container
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.business,
              color: AppColors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          // Brand name
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'AFSUAM',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                'Stok Yönetim Sistemi',
                style: TextStyle(
                  color: AppColors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primaryDark,
                ],
              ),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                _getInitials(),
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // User info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userDisplayName ?? userEmail ?? 'Kullanıcı',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (userRole != null && userRole!.isNotEmpty)
                  Text(
                    userRole!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Kullanıcı adından baş harfleri alır
  String _getInitials() {
    final name = userDisplayName ?? userEmail ?? '';
    if (name.isEmpty) return '?';
    
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  Widget _buildLogoutButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            onLogout();
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.error.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.error.withOpacity(0.2)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  'Çıkış Yap',
                  style: TextStyle(
                    color: AppColors.error,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Navigation item tile with hover and active states
class _NavItemTile extends StatefulWidget {
  final NavItem item;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItemTile({
    required this.item,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_NavItemTile> createState() => _NavItemTileState();
}

class _NavItemTileState extends State<_NavItemTile> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.isActive;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primary.withOpacity(0.12)
                : _isHovered
                    ? AppColors.grey200
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isActive
                ? Border.all(color: AppColors.primary.withOpacity(0.3))
                : null,
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  children: [
                    // Active indicator
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 4,
                      height: isActive ? 24 : 0,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    // Icon
                    Icon(
                      isActive
                          ? (widget.item.activeIcon ?? widget.item.icon)
                          : widget.item.icon,
                      color: isActive ? AppColors.primary : AppColors.grey600,
                      size: 22,
                    ),
                    const SizedBox(width: 14),
                    // Label
                    Text(
                      widget.item.label,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                        color: isActive ? AppColors.primary : AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    // Arrow for active item
                    if (isActive)
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        size: 14,
                        color: AppColors.primary.withOpacity(0.6),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
