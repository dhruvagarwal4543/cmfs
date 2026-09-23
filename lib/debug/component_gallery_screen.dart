// TEMPORARY — Phase 1 component gallery. Not wired into real navigation;
// reachable only via the debug-only button on the Firebase-check screen
// (kDebugMode). Delete or hide once Phase 2 starts.
import 'package:flutter/material.dart';

import '../theme/theme.dart';
import '../widgets/glass_app_bar.dart';
import '../widgets/glass_bottom_bar.dart';
import '../widgets/glass_button.dart';
import '../widgets/glass_card.dart';
import '../widgets/grouped_list_row.dart';
import '../widgets/segmented_control.dart';

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() =>
      _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  int _segment = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CfmsColors.bg0,
      appBar: const GlassAppBar(title: 'Component Gallery'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 24),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
            child: Text('SEGMENTED CONTROL', style: CfmsTheme.sectionHeader),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SegmentedControl(
              labels: const ['All', 'In Progress', 'Ready', 'Archived'],
              selectedIndex: _segment,
              onChanged: (i) => setState(() => _segment = i),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text('GROUPED LIST ROWS', style: CfmsTheme.sectionHeader),
          ),
          GroupedRows(
            rows: [
              GroupedListRow(
                title: 'Syllabus.pdf',
                subtitle: 'Uploaded 2 days ago',
                icon: Icons.description_outlined,
                iconColor: GroupedListRowIconColor.brand,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CfmsColors.label3,
                  size: 18,
                ),
              ),
              GroupedListRow(
                title: 'Assignment 1 rubric',
                subtitle: 'Ready',
                icon: Icons.check_circle_outline,
                iconColor: GroupedListRowIconColor.success,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CfmsColors.label3,
                  size: 18,
                ),
              ),
              GroupedListRow(
                title: 'Attendance sheet',
                subtitle: 'Upload failed — retry',
                icon: Icons.error_outline,
                iconColor: GroupedListRowIconColor.error,
                trailing: const Icon(
                  Icons.chevron_right,
                  color: CfmsColors.label3,
                  size: 18,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text('GLASS CARD', style: CfmsTheme.sectionHeader),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GlassCard(
              child: Text(
                'Used for sheets/modals only — never content rows or list '
                'cards.',
                style: const TextStyle(color: CfmsColors.label2, fontSize: 13),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
            child: Text('GLASS BUTTON', style: CfmsTheme.sectionHeader),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                GlassButton(label: 'Primary action', onPressed: () {}),
                const SizedBox(height: 10),
                GlassButton(
                  label: 'Secondary action',
                  variant: GlassButtonVariant.secondary,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                const GlassButton(label: 'Disabled'),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: GlassBottomBar(
        child: GlassButton(label: 'Bottom action bar', onPressed: () {}),
      ),
    );
  }
}
