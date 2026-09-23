// Matches reference_screens/04-faculty-course-files-all.html `.rows` / `.row`
// / `.ico`. Flat, opaque surface — never blurred (CLAUDE.md §3).
import 'package:flutter/material.dart';

import '../theme/theme.dart';

enum GroupedListRowIconColor { neutral, brand, success, warning, error }

class _IconColors {
  const _IconColors(this.background, this.foreground);
  final Color background;
  final Color foreground;
}

const _iconColorMap = {
  GroupedListRowIconColor.neutral: _IconColors(
    CfmsColors.surface2,
    CfmsColors.label2,
  ),
  GroupedListRowIconColor.brand: _IconColors(
    Color(0x2B4B6FA5), // rgba(75,111,165,.17)
    CfmsColors.brandHi,
  ),
  GroupedListRowIconColor.success: _IconColors(
    Color(0x294F9E74), // rgba(79,158,116,.16)
    CfmsColors.success,
  ),
  GroupedListRowIconColor.warning: _IconColors(
    Color(0x29C79A45), // rgba(199,154,69,.16)
    CfmsColors.warning,
  ),
  GroupedListRowIconColor.error: _IconColors(
    Color(0x29B8635C), // rgba(184,99,92,.16)
    CfmsColors.error,
  ),
};

/// A single row inside a [GroupedRows] container.
class GroupedListRow extends StatelessWidget {
  const GroupedListRow({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.iconColor = GroupedListRowIconColor.neutral,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;
  final GroupedListRowIconColor iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = _iconColorMap[iconColor]!;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: colors.background,
                  borderRadius: BorderRadius.circular(CfmsRadii.iconBadge),
                ),
                child: Icon(icon, size: 14, color: colors.foreground),
              ),
              const SizedBox(width: 13),
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      letterSpacing: -0.225,
                      fontWeight: FontWeight.w500, // CSS font-weight: 450
                      color: CfmsColors.label,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Text(
                        subtitle!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: CfmsColors.label2,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }
}

/// Container for a group of [GroupedListRow]s — flat surface1 background
/// with inset hairline dividers between rows, matching `.rows`/`.row+.row`.
///
/// Renders edge-to-edge with 0 radius by default, matching every reference
/// mockup (confirmed with the project owner — CLAUDE.md §3's "12px grouped
/// list block" radius never actually shows because mockups have no side
/// margin). Pass [radius]/[margin] to opt into an inset, rounded variant.
class GroupedRows extends StatelessWidget {
  const GroupedRows({
    super.key,
    required this.rows,
    this.radius = CfmsRadii.groupedListDefault,
    this.margin = EdgeInsets.zero,
  });

  final List<GroupedListRow> rows;
  final double radius;
  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: CfmsColors.surface1,
        borderRadius: BorderRadius.circular(radius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < rows.length; i++) ...[
            if (i > 0)
              const Padding(
                padding: EdgeInsets.only(left: 52),
                child: ColoredBox(
                  color: CfmsColors.hairline,
                  child: SizedBox(height: 0.5, width: double.infinity),
                ),
              ),
            rows[i],
          ],
        ],
      ),
    );
  }
}
