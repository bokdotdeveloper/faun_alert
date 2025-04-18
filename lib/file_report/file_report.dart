import 'package:faun_alert/file_report/sighting_page.dart';
import 'package:flutter/material.dart';

class FileReport extends StatefulWidget {
  const FileReport({super.key});

  @override
  State<FileReport> createState() => _FileReportState();
}

class _FileReportState extends State<FileReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: const Text(
          'File Report',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Image.network(
              'https://placehold.co/200x200/000000/FFFFFF/png', // Replace with your logo asset path
              height: 40,
              width: 40,
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select Incident Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridButton(
                        icon: Icons.visibility,
                        label: 'Sighting',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SightingPage();
                              },
                            ),
                          );
                        },
                      ),
                      _buildGridButton(
                        icon: Icons.lock,
                        label: 'Exploitation',
                        onPressed: () {
                          // Handle Exploitation action
                        },
                      ),
                      _buildGridButton(
                        icon: Icons.track_changes_outlined,
                        label: 'Illegal Hunting',
                        onPressed: () {
                          // Handle Illegal Hunting action
                        },
                      ),
                      _buildGridButton(
                        icon: Icons.forest,
                        label: 'Habitat Destruction',
                        onPressed: () {
                          // Handle Habitat Destruction action
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGridButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green[100],
        foregroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: Colors.green[800]),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
