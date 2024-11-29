import 'dart:math';

import 'package:social_tripper_mobile/Models/Post/post_master_author.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/date_generator.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/generated_user.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/lorem_ipsum.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/system_entity_photo_generator.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/user_generator.dart';

class PostGenerator {
  static Future<PostMasterModel> generatePost() async {
    Random random = Random();

    // Generate a random author
    PostMasterAuthor postMaster = PostMasterAuthor.fromGeneratedUser(UserGenerator.getRandomUser());

    // Generate a random post date
    DateTime randomDate = DateGenerator.generateRandomDate();

    // Generate random content
    String content = LoremIpsumGenerator.generate(maxLength: random.nextInt(10000));

    // Randomly determine how many photos to include (0 to 7)
    int numberOfPhotos = random.nextInt(8);  // 0 to 7 photos
    List<String> photoURIs = [];

    // If we have photos, generate URIs
    for (int i = 0; i < numberOfPhotos; i++) {
      String photoURI = await SystemEntityPhotoGenerator.fetchRandomImage();
      photoURIs.add(photoURI);
    }

    // Random likes and comments count
    int likesCount = random.nextInt(100000);
    int commentsCount = random.nextInt(100000);

    // Create and return the post
    return PostMasterModel(
        postMaster,
        randomDate,
        content,
        photoURIs.isEmpty ? null : photoURIs,  // If there are no photos, set photoURIs to null
        likesCount,
        commentsCount
    );
  }
}