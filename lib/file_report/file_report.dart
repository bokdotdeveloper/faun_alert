import 'package:faun_alert/file_report/exploitation.dart';
import 'package:faun_alert/file_report/habitat_destruction.dart';
import 'package:faun_alert/file_report/illegal_hunting.dart';
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
          style: TextStyle(fontSize: 18, fontFamily: 'Inter', fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.notifications, color: Colors.black),
              onPressed: () {
          // Add notification logic here
          debugPrint('Notification bell pressed'); // Use debugPrint for logging
              },
            ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Select Incident Type',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, fontFamily: 'Inter'),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _buildGridButton(
                        image: 'assets/sighting.png',
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
                        image: 'assets/exploitation.png',
                        label: 'Exploitation',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Exploitation();
                              },
                            ),
                          );
                        },
                      ),
                      _buildGridButton(
                        image: 'assets/illegal_hunting.png',
                        label: 'Illegal Hunting',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return IllegalHunting();
                              },
                            ),
                          );
                        },
                      ),
                      _buildGridButton(
                        image: 'assets/habitat_destruction.png',
                        label: 'Habitat Destruction',
                        onPressed: () {
                           Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return HabitatDestruction();
                              },
                            ),
                          );
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
    required String image,
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
          Image.asset(image, height: 60, width: 60),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, fontFamily: 'Inter'),
          ),
        ],
      ),
    );
  }
}
