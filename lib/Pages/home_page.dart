import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Post/post_generator.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/system_entity_photo_generator.dart';
import '../Components/Post/post_master.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final GlobalKey<_HomePageState> homePageKey =
  GlobalKey<_HomePageState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<PostMasterModel>> postsFuture; // Zmieniamy na Future

  // Asynchroniczne ładowanie postów w initState
  @override
  void initState() {
    super.initState();
    postsFuture = _loadPosts(); // Wywołanie funkcji do załadowania postów
  }

  // Asynchroniczna funkcja do generowania postów
  Future<List<PostMasterModel>> _loadPosts() async {
    List<PostMasterModel> posts = [];
    for (int i = 0; i < 15; i++) {
      PostMasterModel post = await PostGenerator.generatePost();
      posts.add(post);

      // Załaduj obrazy dla każdego posta w tle
      _preloadImagesForPost(post);
    }
    return posts;
  }


  // Funkcja do wstępnego ładowania obrazów dla pojedynczego posta
  Future<void> _preloadImagesForPost(PostMasterModel post) async {
    if (post.photoURIs != null && post.photoURIs!.isNotEmpty) {
      await Future.wait(post.photoURIs!.map((uri) async {
        final image = CachedNetworkImageProvider(uri);
        await image.resolve(ImageConfiguration());
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          postsFuture = _loadPosts(); // Odświeżamy zawartość postów
        });
      },
      child: FutureBuilder<List<PostMasterModel>>(
        future: postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<PostMasterModel> posts = snapshot.data!;
            return ListView.builder(
              itemCount: posts.length, // Liczba postów
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9),
                  child: PostMaster(posts[index]),
                );
              },
            );
          } else {
            return Center(child: Text('Brak danych.'));
          }
        },
      ),
    );
  }
}