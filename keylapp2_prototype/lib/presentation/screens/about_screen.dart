import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../application/app_links.dart';

/// The About / Support screen — preserves the original Keylapp informational
/// content (support via PayPal, community/Discord links). URLs come from the
/// central `AppLinks` config layer, not hardcoded in the UI.
class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  Future<void> _open(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12121E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E2E),
        title: const Text('Keylapp', style: TextStyle(color: Colors.white)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Center(
            child: Column(children: [
              Text('Keylapp', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: 4),
              Text('Explore and compare alternative keyboard layouts',
                  style: TextStyle(color: Colors.white54, fontSize: 13), textAlign: TextAlign.center),
              SizedBox(height: 20),
            ]),
          ),
          for (final link in AppLinks.supportItems)
            Card(
              color: const Color(0xFF1E1E2E),
              child: ListTile(
                leading: Icon(link.icon, color: Colors.white70),
                title: Text(link.label, style: const TextStyle(color: Colors.white, fontSize: 14)),
                trailing: const Icon(Icons.open_in_new, color: Colors.white38, size: 16),
                onTap: () => _open(link.url),
              ),
            ),
        ],
      ),
    );
  }
}