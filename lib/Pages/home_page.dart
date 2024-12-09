import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Models/User/current_user.dart';
import 'package:social_tripper_mobile/Pages/config/data_retrieving_config.dart';
import 'package:social_tripper_mobile/Pages/config/post_page_build_config.dart';
import 'package:social_tripper_mobile/Pages/config/scrolling_treshholds.dart';
import 'package:social_tripper_mobile/Repositories/post_repository.dart';
import 'package:social_tripper_mobile/Services/post_service.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Post/post_generator.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/system_entity_photo_generator.dart';
import '../Components/Post/post_master.dart';
import 'generic_content_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late GenericContentPage2<PostMasterModel> content;
  final ScrollController _scrollController = ScrollController();

  Future<void> placeholderOnRefresh() async {
    await Future.value(0);
  }

  @override
  void initState() {
    PostService service = PostService();
    super.initState();
    content = GenericContentPage2(
      retrieveContent: service.loadAllPostsStream,
      buildItem: PostPageBuildConfig.buildItem,
      precachingStrategy: PostPageBuildConfig.cachingStrategy,
    );
  }

  void scrollToTop() {
    if (_scrollController.position.pixels == 0) {
    } else {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return content;
  }
}
