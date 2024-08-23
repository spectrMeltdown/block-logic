import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BlSegmentedButton extends ConsumerStatefulWidget {
  final Set selected;
  final List<ButtonSegment<dynamic>> segments;
  final void Function(Set<dynamic>)? onSelectionChanged;
  const BlSegmentedButton({
    required this.selected,
    required this.segments,
    required this.onSelectionChanged,
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _BlSegmentedButtonState();
}

class _BlSegmentedButtonState extends ConsumerState<BlSegmentedButton> {
  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      segments: widget.segments,
      selected: widget.selected,
      onSelectionChanged: widget.onSelectionChanged,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.white.withOpacity(0.4); // Selected color
            }
            return null;
          },
        ),
        foregroundColor: WidgetStateProperty.resolveWith<Color?>(
          (Set<WidgetState> states) {
            if (states.contains(WidgetState.selected)) {
              return Colors.black; // Text color for selected
            }
            return null; // Text color for unselected
          },
        ),
      ),
    );
  }
}
