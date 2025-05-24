import 'package:faun_alert/admin/pages/reports.dart';
import 'package:faun_alert/admin/pages/users.dart';
import 'package:faun_alert/admin/reports/reports_summary.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var items = ["Users", "Reports"];

  var icons = [Icons.person, Icons.report];

  final CollectionReference<Map<String, dynamic>> _animalCollection =
      FirebaseFirestore.instance.collection('animals');

  final CollectionReference<Map<String, dynamic>> _incidentsCollection =
      FirebaseFirestore.instance.collection('reports');

  Map<String, String> _animalNames = {};
  Map<String, String> _userNames = {};

  Future<int> getReportsCount() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('reports').get();
    return snapshot.size;
  }

  Future<int> getUsersCount() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    return snapshot.size;
  }

  Future<int> getVerifiedCount() async {
    final snapshot =
        await FirebaseFirestore.instance
            .collection('reports')
            .where('status', isEqualTo: 'verified')
            .get();
    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) => Users()
                          ),
                        );
                      },
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<int>(
                                    future: getUsersCount(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                          '...',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Inter Bold',
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return const Text(
                                          'Err',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Inter Bold',
                                          ),
                                        );
                                      }
                                      return Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Inter Bold',
                                        ),
                                      );
                                    },
                                  ),
                                  Text(
                                    'Users',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              Icon(Icons.group, size: 28),
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        height: 50,
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE0E0E0)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FutureBuilder<int>(
                                    future: getReportsCount(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Text(
                                          '...',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Inter Bold',
                                          ),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return const Text(
                                          'Err',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontFamily: 'Inter Bold',
                                          ),
                                        );
                                      }
                                      return Text(
                                        '${snapshot.data}',
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontFamily: 'Inter Bold',
                                        ),
                                      );
                                    },
                                  ),
                                  const Text(
                                    'Reports',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Inter',
                                    ),
                                  ),
                                ],
                              ),
                              const Icon(Icons.file_copy, size: 28),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 90,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 8.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FutureBuilder<int>(
                                future: getVerifiedCount(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Text(
                                      '...',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Inter Bold',
                                      ),
                                    );
                                  }
                                  if (snapshot.hasError) {
                                    return const Text(
                                      'Err',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontFamily: 'Inter Bold',
                                      ),
                                    );
                                  }
                                  return Text(
                                    '${snapshot.data}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontFamily: 'Inter Bold',
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'Verified',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                          Icon(Icons.verified, size: 28, color: Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  "RECENT REPORTS",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w100,
                    fontFamily: 'Inter Bold',
                  ),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                    future:
                        FirebaseFirestore.instance.collection('users').get(),
                    builder: (context, userSnapshot) {
                      if (userSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (userSnapshot.hasError) {
                        return Text('Error: ${userSnapshot.error}');
                      }
                      // Build the uid -> name map
                      _userNames = {
                        for (var doc in userSnapshot.data?.docs ?? [])
                          doc.id:
                              (doc
                                              .data()['firstname']
                                              .toString()
                                              .toUpperCase() +
                                          " " +
                                          doc
                                              .data()['lastname']
                                              .toString()
                                              .toUpperCase() ??
                                      '')
                                  .toString(),
                      };
                      return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
                        future: _animalCollection.get(),
                        builder: (context, animalSnapshot) {
                          if (animalSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (animalSnapshot.hasError) {
                            return Text('Error: ${animalSnapshot.error}');
                          }
                          // Build the animalId -> name map
                          _animalNames = {
                            for (var doc in animalSnapshot.data?.docs ?? [])
                              doc.id: (doc.data()['name'] ?? '').toString(),
                          };
                          return StreamBuilder<
                            QuerySnapshot<Map<String, dynamic>>
                          >(
                            stream:
                                _incidentsCollection
                                    .where('status', isNotEqualTo: 'verified')
                                    .orderBy('submitted_at', descending: true)
                                    .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (snapshot.hasError) {
                                return Text('Error: ${snapshot.error}');
                              }
                              final reports = snapshot.data?.docs ?? [];

                              if (reports.isEmpty) {
                                return const Center(
                                  child: Text('No reports found.'),
                                );
                              }
                              return ListView.builder(
                                itemCount: reports.length,
                                itemBuilder: (BuildContext context, int index) {
                                  final data = reports[index].data();
                                  final animalName =
                                      _animalNames[data['animalId']] ??
                                      'Unknown Animal';
                                  final userName =
                                      _userNames[data['uid']] ?? 'Unknown User';
                                  return GestureDetector(
                                    onTap: () async {
                                      // Get the animal and user IDs from the report
                                      final animalId = data['animalId'];
                                      final userId = data['uid'];

                                      // Fetch animal data
                                      final animalDoc =
                                          await FirebaseFirestore.instance
                                              .collection('animals')
                                              .doc(animalId)
                                              .get();
                                      final animalData = animalDoc.data();

                                      // Fetch user data
                                      final userDoc =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(userId)
                                              .get();
                                      final userData = userDoc.data();

                                      // Combine all data into one map
                                      final reportSummaryData = {
                                        ...data,
                                        'animal': animalData,
                                        'user': userData,
                                      };

                                      // Navigate to the summary page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => ReportsSummary(
                                                reportData: reportSummaryData,
                                                reportId: reports[index].id,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height: 180,
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 8.0,
                                        vertical: 8.0,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          color: const Color(0xFFE0E0E0),
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          8.0,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(8),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (data['incident_type'] ==
                                                    'sighting') ...[
                                                  Row(
                                                    children: [
                                                      Image.asset(
                                                        'assets/sighting.png',
                                                        width: 20,
                                                      ),
                                                      const SizedBox(width: 4),
                                                      const Text(
                                                        'Animal Sighting',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          fontWeight:
                                                              FontWeight.bold,
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
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Colors.brown,
                                                          fontFamily: 'Inter',
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
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
                                                      animalName,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16,
                                                        fontFamily:
                                                            'Inter Bold',
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
                                                      data['incident_date'] ??
                                                          '',
                                                      style:
                                                          Theme.of(
                                                            context,
                                                          ).textTheme.bodySmall,
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
                                                        style:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .bodySmall,
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .description_outlined,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      data['additional_info'] ??
                                                          '',
                                                      style:
                                                          Theme.of(
                                                            context,
                                                          ).textTheme.bodySmall,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Row(
                                                  children: [
                                                    Icon(
                                                      Icons
                                                          .person_outline_outlined,
                                                      size: 16,
                                                      color: Colors.grey,
                                                    ),
                                                    const SizedBox(width: 4),
                                                    Text(
                                                      userName,
                                                      style:
                                                          Theme.of(
                                                            context,
                                                          ).textTheme.bodySmall,
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 4),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 8,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color:
                                                        (data['status'] ==
                                                                'verified')
                                                            ? Colors.green
                                                                .withAlpha(
                                                                  (0.2 * 255)
                                                                      .toInt(),
                                                                )
                                                            : (data['status'] ==
                                                                'on review')
                                                            ? Colors.blue
                                                                .withAlpha(
                                                                  (0.2 * 255)
                                                                      .toInt(),
                                                                )
                                                            : (data['status'] ==
                                                                'false information')
                                                            ? Colors.red
                                                                .withAlpha(
                                                                  (0.2 * 255)
                                                                      .toInt(),
                                                                )
                                                            : Colors.orange
                                                                .withAlpha(
                                                                  (0.2 * 255)
                                                                      .toInt(),
                                                                ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          3,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    data['status'] ?? 'Pending',
                                                    style: TextStyle(
                                                      color:
                                                          (data['status'] ==
                                                                  'verified')
                                                              ? Colors.green
                                                              : (data['status'] ==
                                                                  'on review')
                                                              ? Colors.blue
                                                              : (data['status'] ==
                                                                  'false information')
                                                              ? Colors.red
                                                              : Colors.orange,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          Container(
                                            width: 100,
                                            height: 100,
                                            decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                              image:
                                                  data['image_url'] != null
                                                      ? DecorationImage(
                                                        fit: BoxFit.cover,
                                                        image: NetworkImage(
                                                          data['image_url'],
                                                        ),
                                                      )
                                                      : null,
                                            ),
                                            child:
                                                data['image_url'] == null
                                                    ? const Icon(
                                                      Icons.image,
                                                      size: 50,
                                                    )
                                                    : null,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                      );
                    },
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

class Article {
  final String title;
  final String imageUrl;
  final String author;
  final String postedOn;

  Article({
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.postedOn,
  });
}

final List<Article> _articles = [
  Article(
    title: "Instagram quietly limits ‘daily time limit’ option",
    author: "MacRumors",
    imageUrl: "https://picsum.photos/id/1000/960/540",
    postedOn: "Yesterday",
  ),
  Article(
    title: "Google Search dark theme goes fully black for some on the web",
    imageUrl: "https://picsum.photos/id/1010/960/540",
    author: "9to5Google",
    postedOn: "4 hours ago",
  ),
  Article(
    title: "Check your iPhone now: warning signs someone is spying on you",
    author: "New York Times",
    imageUrl: "https://picsum.photos/id/1001/960/540",
    postedOn: "2 days ago",
  ),
  Article(
    title:
        "Amazon’s incredibly popular Lost Ark MMO is ‘at capacity’ in central Europe",
    author: "MacRumors",
    imageUrl: "https://picsum.photos/id/1002/960/540",
    postedOn: "22 hours ago",
  ),
  Article(
    title:
        "Panasonic's 25-megapixel GH6 is the highest resolution Micro Four Thirds camera yet",
    author: "Polygon",
    imageUrl: "https://picsum.photos/id/1020/960/540",
    postedOn: "2 hours ago",
  ),
  Article(
    title: "Samsung Galaxy S22 Ultra charges strangely slowly",
    author: "TechRadar",
    imageUrl: "https://picsum.photos/id/1021/960/540",
    postedOn: "10 days ago",
  ),
  Article(
    title: "Snapchat unveils real-time location sharing",
    author: "Fox Business",
    imageUrl: "https://picsum.photos/id/1060/960/540",
    postedOn: "10 hours ago",
  ),
];
