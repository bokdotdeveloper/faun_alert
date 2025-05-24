import 'package:faun_alert/admin/animals/animal_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final CollectionReference<Map<String, dynamic>> _animalCollection =
      FirebaseFirestore.instance.collection('animals');

  final CollectionReference<Map<String, dynamic>> _incidentsCollection =
      FirebaseFirestore.instance.collection('reports');

  Map<String, String> _animalNames = {};

  String? get currentUserId => FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 180,
                child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _animalCollection.snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: const Text('Loading...'));
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final animals = snapshot.data?.docs ?? [];
                    // Build the animalId -> name map
                    _animalNames = {
                      for (var doc in animals)
                        doc.id: (doc.data()['name'] ?? '').toString(),
                    };
                    if (animals.isEmpty) {
                      return const Text('No animals found.');
                    }
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: animals.length,
                        scrollDirection: Axis.horizontal,
                        separatorBuilder:
                            (context, index) => const SizedBox(width: 2),
                        itemBuilder: (context, index) {
                          final animal = animals[index];
                          final data = animal.data();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 4.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            AnimalProfile(animalData: data),
                                  ),
                                );
                              },
                              child: Card(
                                shadowColor: Colors.lightGreen,
                                child: Column(
                                  children: [
                                    SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Container(
                                          child:
                                              data['image_url'] != null &&
                                                      data['image_url']
                                                          .toString()
                                                          .isNotEmpty
                                                  ? ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          8,
                                                        ),
                                                    child: Image.network(
                                                      data['image_url'],
                                                      width: 50,
                                                      fit: BoxFit.cover,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) => const Icon(
                                                            Icons
                                                                .image_not_supported,
                                                            size: 50,
                                                          ),
                                                    ),
                                                  )
                                                  : const Icon(
                                                    Icons.image,
                                                    size: 50,
                                                  ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (data['name'] ?? '')
                                          .toString()
                                          .toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Inter Bold',
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "MY INCIDENTS",
                style: TextStyle(fontSize: 20, fontFamily: 'Inter Bold'),
              ),
              const SizedBox(height: 5),
              Expanded(
                child:
                    currentUserId == null
                        ? const Center(child: Text('Not logged in'))
                        : StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                          stream:
                              _incidentsCollection
                                  .where('uid', isEqualTo: currentUserId)
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
                                return Container(
                                  height: 150,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 8.0,
                                    vertical: 8.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                      color: const Color(0xFFE0E0E0),
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
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
                                                        Theme.of(
                                                          context,
                                                        ).textTheme.bodySmall,
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                                        ? Colors.blue.withAlpha(
                                                          (0.2 * 255).toInt(),
                                                        )
                                                        : (data['status'] ==
                                                            'false information')
                                                        ? Colors.red.withAlpha(
                                                          (0.2 * 255).toInt(),
                                                        )
                                                        : Colors.orange
                                                            .withAlpha(
                                                              (0.2 * 255)
                                                                  .toInt(),
                                                            ),
                                                borderRadius:
                                                    BorderRadius.circular(3),
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
                                                  fontWeight: FontWeight.bold,
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
                                          borderRadius: BorderRadius.circular(
                                            8.0,
                                          ),
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
    );
  }
}
