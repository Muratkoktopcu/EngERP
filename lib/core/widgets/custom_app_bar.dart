// lib/core/widgets/custom_app_bar.dart

import 'package:flutter/material.dart';
import 'package:eng_erp/core/theme/theme.dart';

/// 🎨 Custom AppBar Widget
/// Tüm sayfalarda tutarlı görünüm sağlayan paylaşılan AppBar
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showMenuButton;
  final VoidCallback? onMenuPressed;
  final Widget? leading;
  final bool centerTitle;
  final double elevation;
  
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.showMenuButton = true,
    this.onMenuPressed,
    this.leading,
    this.centerTitle = false,
    this.elevation = 0,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Container(
          height: kToolbarHeight,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            children: [
              // Leading widget (menu button or custom)
              if (leading != null)
                leading!
              else if (showMenuButton)
                _buildMenuButton(context),
              
              const SizedBox(width: 8),
              
              // Title
              if (centerTitle)
                const Spacer(),
              
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    letterSpacing: 0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              
              if (centerTitle)
                const Spacer(),
              
              // Actions
              if (actions != null) ...[
                ...actions!.map((action) => _wrapAction(action)),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuButton(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onMenuPressed ?? () => Scaffold.of(context).openDrawer(),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.menu_rounded,
            color: AppColors.primary,
            size: 24,
          ),
        ),
      ),
    );
  }

  Widget _wrapAction(Widget action) {
    // IconButton'ları stil ile sar
    if (action is IconButton) {
      return Padding(
        padding: const EdgeInsets.only(left: 4),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: action.onPressed,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.grey200,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                (action.icon as Icon).icon,
                color: AppColors.grey600,
                size: 20,
              ),
            ),
          ),
        ),
      );
    }
    return action;
  }
}

/// 🎨 Page Header Widget
/// AppBar olmadan sayfa içi başlık widget'ı
class PageHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget>? actions;

  const PageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withOpacity(0.5),
          ),
        ),
      ),
      child: Row(
        children: [
          // Title section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (subtitle != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      subtitle!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Actions
          if (actions != null) ...actions!,
        ],
      ),
    );
  }
}
