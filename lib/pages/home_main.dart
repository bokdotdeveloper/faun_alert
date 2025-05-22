import 'package:faun_alert/admin/animals/animal_profile.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeMain extends StatefulWidget {
  const HomeMain({super.key});

  @override
  State<HomeMain> createState() => _HomeMainState();
}

class _HomeMainState extends State<HomeMain> {
  final CollectionReference<Map<String, dynamic>> _animalCollection =
      FirebaseFirestore.instance.collection('animals');

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
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    final animals = snapshot.data?.docs ?? [];
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
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AnimalProfile(
                                      animalData: data,
                                    ),
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
                                                    borderRadius: BorderRadius.circular(
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
                                                            Icons.image_not_supported,
                                                            size: 50,
                                                          ),
                                                    ),
                                                  )
                                                  : const Icon(Icons.image, size: 50),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      (data['name'] ?? '').toString().toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Inter Bold'
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
                child: ListView.builder(
                  itemCount: _articles.length,
                  itemBuilder: (BuildContext context, int index) {
                    final item = _articles[index];
                    return Container(
                      height: 136,
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color(0xFFE0E0E0)),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "${item.author} · ${item.postedOn}",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children:
                                      [
                                        Icons.bookmark_border_rounded,
                                        Icons.share,
                                        Icons.more_vert,
                                      ].map((e) {
                                        return InkWell(
                                          onTap: () {},
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              right: 8.0,
                                            ),
                                            child: Icon(e, size: 16),
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(item.imageUrl),
                              ),
                            ),
                          ),
                        ],
                      ),
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

  Widget buildCard() => SizedBox(
    width: 140,
    child: Image.network('https://placehold.co/200x200/000000/FFFFFF/png'),
  );
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
