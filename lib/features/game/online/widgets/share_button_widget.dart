import 'package:flutter/material.dart';

class ShareButtonWidget extends StatelessWidget {
  const ShareButtonWidget({
    required this.showShareButton,
    required this.onShare,
    super.key,
  });

  final bool showShareButton;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) => const SizedBox.shrink();

  static List<Widget>? actions({
    required bool showShareButton,
    required VoidCallback onShare,
  }) {
    if (!showShareButton) return null;

    return [
      IconButton(
        onPressed: onShare,
        icon: const Icon(Icons.share_rounded),
        tooltip: 'Share room',
      ),
    ];
  }
}
