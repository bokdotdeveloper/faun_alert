import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReportsSummary extends StatefulWidget {
  final Map<String, dynamic> reportData;
  final String reportId;
  const ReportsSummary({super.key, required this.reportData, required this.reportId});

  @override
  State<ReportsSummary> createState() => _ReportsSummaryState();
}

class _StatusRadioList extends StatelessWidget {
  final List<String> categories;
  final String? selectedCategory;
  final void Function(String? value) onChanged;

  const _StatusRadioList({
    Key? key,
    required this.categories,
    required this.selectedCategory,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children:
          categories.map((category) {
            return Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Radio<String>(
                        groupValue: selectedCategory,
                        value: category,
                        onChanged: onChanged,
                        activeColor: Colors.blue,
                      ),
                      Flexible(
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w300,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
    );
  }
}

class _ReportsSummaryState extends State<ReportsSummary> {
  late String selectedCategory = widget.reportData['status'];
  final List<String> statuses = ['on review', 'verified', 'false information'];

  Future<void> saveEdit() async {
    await FirebaseFirestore.instance
        .collection('reports')
        .doc(widget.reportId)
        .update({
          'status': selectedCategory,
          'updated_at': DateTime.now(),
        });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Updated successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = widget.reportData;
    final animal = widget.reportData['animal'];
    final user = widget.reportData['user'];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actionsPadding: EdgeInsets.all(8),
        title: Text(
          'Report Summary',
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
          Image.asset(
            'assets/AppLogo.png', // Ensure the path is correct
            height: 40, // Adjust height as needed
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (data['incident_type'] == 'sighting') ...[
                            Row(
                              children: [
                                Image.asset('assets/sighting.png', width: 20),
                                const SizedBox(width: 4),
                                const Text(
                                  'Animal Sighting',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ] else if (data['incident_type'] ==
                              'exploitation') ...[
                            Row(
                              children: [
                                Image.asset(
                                  'assets/exploitation.png',
                                  width: 20,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Exploitation',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ] else if (data['incident_type'] ==
                              'illegal hunting') ...[
                            Row(
                              children: [
                                Image.asset(
                                  'assets/illegal_hunting.png',
                                  width: 20,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Illegal Hunting',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ] else if (data['incident_type'] ==
                              'habitat destruction') ...[
                            Row(
                              children: [
                                Image.asset(
                                  'assets/habitat_destruction.png',
                                  width: 20,
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'Habitat Destruction',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.brown,
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ],
                            ),
                          ],

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                                  (data['status'] == 'verified')
                                      ? Colors.green.withAlpha(
                                        (0.2 * 255).toInt(),
                                      )
                                      : (data['status'] == 'on review')
                                      ? Colors.blue.withAlpha(
                                        (0.2 * 255).toInt(),
                                      )
                                      : (data['status'] == 'false information')
                                      ? Colors.red.withAlpha(
                                        (0.2 * 255).toInt(),
                                      )
                                      : Colors.orange.withAlpha(
                                        (0.2 * 255).toInt(),
                                      ),
                              borderRadius: BorderRadius.circular(3),
                            ),
                            child: Text(
                              data['status'] ?? 'Pending',
                              style: TextStyle(
                                color:
                                    (data['status'] == 'verified')
                                        ? Colors.green
                                        : (data['status'] == 'on review')
                                        ? Colors.blue
                                        : (data['status'] ==
                                            'false information')
                                        ? Colors.red
                                        : Colors.orange,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.pets_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            animal?['name'] ?? 'Unknown Animal',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              fontFamily: 'Inter Bold',
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.date_range_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data['incident_date'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              data['location'] ?? '',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.description_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            data['additional_info'] ?? '',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline_outlined,
                            size: 16,
                            color: Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            user != null
                                ? '${user['firstname'] ?? ''} ${user['lastname'] ?? ''}'
                                    .trim()
                                : 'Unknown User',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap:
                            data['image_url'] != null
                                ? () {
                                  showDialog(
                                    context: context,
                                    builder:
                                        (context) => Dialog(
                                          backgroundColor: Colors.transparent,
                                          child: GestureDetector(
                                            onTap:
                                                () =>
                                                    Navigator.of(context).pop(),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                border: Border.all(
                                                  color: const Color(
                                                    0xFFE0E0E0,
                                                  ),
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                              padding: const EdgeInsets.all(8),
                                              child: InteractiveViewer(
                                                minScale: 1,
                                                maxScale: 5,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                  child: Image.network(
                                                    data['image_url'],
                                                    fit: BoxFit.fitHeight,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                  );
                                }
                                : null,
                        child: Container(
                          height: 250,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: const Color(0xFFE0E0E0)),
                            borderRadius: BorderRadius.circular(8.0),
                            image:
                                data['image_url'] != null
                                    ? DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(data['image_url']),
                                    )
                                    : null,
                          ),
                          child:
                              data['image_url'] == null
                                  ? const Icon(Icons.image, size: 50)
                                  : null,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Status:',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 80,
                        child: _StatusRadioList(
                          categories: statuses,
                          selectedCategory: selectedCategory,
                          onChanged: (value) {
                            setState(() {
                              selectedCategory = value as String;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                GestureDetector(
                  onTap: saveEdit,
                  child: Container(
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        'Update Status',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.bold,
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
    );
  }
}
