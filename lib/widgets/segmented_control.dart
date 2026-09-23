// Matches reference_screens/04-faculty-course-files-all.html `.material.seg`
// / `.thumb`. This is one of the few places §3 permits blur — the container
// carries both the glass blur AND a translucent brand-tinted fill.
import 'dart:ui';

import 'package:flutter/material.dart';

import '../theme/theme.dart';

class SegmentedControl extends StatelessWidget {
  const SegmentedControl({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(CfmsRadii.segmentContainer),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: CfmsGlass.blurSigma,
          sigmaY: CfmsGlass.blurSigma,
        ),
        child: Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: CfmsColors.brandFill,
            borderRadius: BorderRadius.circular(CfmsRadii.segmentContainer),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final segmentWidth =
                  (constraints.maxWidth - 4) / labels.length;
              return SizedBox(
                height: 32,
                child: Stack(
                  children: [
                    AnimatedPositioned(
                      duration: CfmsMotion.segmentThumbDuration,
                      curve: CfmsMotion.segmentThumbCurve,
                      left: segmentWidth * selectedIndex,
                      width: segmentWidth,
                      top: 0,
                      bottom: 0,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            CfmsRadii.segmentThumb,
                          ),
                          gradient: const LinearGradient(
                            begin: Alignment(-0.7, -1),
                            end: Alignment(0.7, 1),
                            colors: [
                              CfmsColors.surface2,
                              Color(0xFF28292E),
                            ],
                          ),
                          border: Border.all(
                            color: CfmsColors.materialHighlight,
                            width: 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: CfmsColors.brand.withValues(alpha: 0.24),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        for (var i = 0; i < labels.length; i++)
                          SizedBox(
                            width: segmentWidth,
                            child: GestureDetector(
                              onTap: () => onChanged(i),
                              child: Center(
                                child: Opacity(
                                  opacity: i == selectedIndex ? 1 : 0.6,
                                  child: Text(
                                    labels[i],
                                    style: const TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w600,
                                      color: CfmsColors.label,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
