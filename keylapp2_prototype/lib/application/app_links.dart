import 'package:flutter/material.dart';

/// Central content/configuration layer for external links and support URLs.
///
/// This keeps community/support URLs out of unrelated UI components, per the
/// product requirement. Views read from here; adding/editing a link is a
/// one-line change here, never a UI change.
class AppLinks {
  /// Support the developer (PayPal, from the original Keylapp).
  static const String paypal = 'https://paypal.me/etaosin';

  /// Community / Discord for alternative keyboard layouts (original Keylapp).
  static const String discord = 'https://discord.gg/alternative-keyboard-layouts';

  /// Additional project/community resource.
  static const String community = 'https://www.google.com/search?q=alternative+keyboard+layouts+community';

  /// All links grouped for the About/Support screen.
  static const List<SupportLink> supportItems = [
    SupportLink(label: 'Support the developer', url: paypal, icon: Icons.paid),
    SupportLink(label: 'Join the community (Discord)', url: discord, icon: Icons.forum),
    SupportLink(label: 'Keyboard layout community', url: community, icon: Icons.groups),
  ];
}

class SupportLink {
  final String label;
  final String url;
  final IconData icon;
  const SupportLink({required this.label, required this.url, required this.icon});
}