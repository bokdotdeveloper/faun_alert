import 'package:faun_alert/file_report/file_report_information.dart';
import 'package:flutter/material.dart';

class FileReportConfirm extends StatefulWidget {
  final String animalId;
  final String incidentType;
  final Map<String, dynamic> initialData;

  const FileReportConfirm({
    Key? key,
    required this.animalId,
    required this.incidentType,
    required this.initialData,
  }) : super(key: key);

  @override
  State<FileReportConfirm> createState() => _FileReportConfirmState();
}

class _FileReportConfirmState extends State<FileReportConfirm> {
  @override
  Widget build(BuildContext context) {
    final data = widget.initialData;
    final animalId = widget.animalId;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: Text(
          'Confirm Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            fontFamily: 'Inter',
          ),
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
              debugPrint(
                'Notification bell pressed',
              ); // Use debugPrint for logging
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            shadowColor: Colors.lightGreen,
            surfaceTintColor: Colors.lightGreen,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (data['image_url'] != null &&
                      data['image_url'].toString().isNotEmpty)
                    Image.network(data['image_url'], width: 350, height: 250),
                  SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data['name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 16.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Scientific Name: ',
                            style: const TextStyle(
                              fontSize: 18,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            data['scientific_name'] ?? '',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (data['category'] != null &&
                      (data['category'] as List).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Category: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 8,
                                children:
                                    (data['category'] as List)
                                        .map<Widget>(
                                          (cat) => Chip(
                                            label: Text(
                                              cat.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(width: 8),
                  if (data['animal_type'] != null &&
                      (data['animal_type'] as List).isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        padding: const EdgeInsets.all(8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Text(
                              'Animal Type: ',
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 8),
                            Flexible(
                              child: Wrap(
                                direction: Axis.horizontal,
                                alignment: WrapAlignment.start,
                                spacing: 8,
                                children:
                                    (data['animal_type'] as List)
                                        .map<Widget>(
                                          (cat) => Chip(
                                            label: Text(
                                              cat.toString(),
                                              style: TextStyle(
                                                fontFamily: 'Inter',
                                                fontSize: 15.0,
                                              ),
                                            ),
                                          ),
                                        )
                                        .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return FileReportInformation(
                                animalId: animalId,
                                incidentType: widget.incidentType,
                                initialData: data,
                              );
                            },
                          ),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(13),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 0, 0, 0),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            'Confirm',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter Bold',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
