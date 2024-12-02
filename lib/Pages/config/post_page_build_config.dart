import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Post/post_master.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Repositories/post_repository.dart';
import 'package:social_tripper_mobile/Services/post_service.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Post/post_generator.dart';


class PostPageBuildConfig {
  static Future<void> cachingStrategy(PostMasterModel trip, BuildContext context) async {
    if (trip.postMultimediaUrls != null && trip.postMultimediaUrls!.isNotEmpty) {
      await Future.wait(trip.postMultimediaUrls!.map((uri) async {
        final image = CachedNetworkImageProvider(uri);
        await image.resolve(ImageConfiguration());
      }));
    }
  }

  static Widget buildItem(PostMasterModel? postMasterModel, BuildContext context) {
    if (postMasterModel == null) {
      return const Center(child: Text("Error loading trip"));
    }

    Widget post = Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: PostMaster(postMasterModel),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: post,
    );
  }

  static Future<PostMasterModel> retrieveGeneratedElement() {
    print("generating post");
    return PostGenerator.generatePost();
  }

  static Future<PostMasterModel?> retrieveBackendElement() {
    print("retrieving");
    return PostRepository().retrieve();
  }
}