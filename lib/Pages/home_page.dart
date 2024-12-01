import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Pages/config/post_page_build_config.dart';
import 'package:social_tripper_mobile/Pages/config/scrolling_treshholds.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/Post/post_generator.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/system_entity_photo_generator.dart';
import '../Components/Post/post_master.dart';
import 'generic_content_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static final GlobalKey<_HomePageState> homePageKey =
      GlobalKey<_HomePageState>();

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late GenericContentPage<PostMasterModel> content;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    content = GenericContentPage(
      refreshIndicatorKey: refreshIndicatorKey,
      scrollTresholdFunction: getLinearThreshold,
      precachingStrategy: PostPageBuildConfig.cachingStrategy,
      retrieveContent: PostPageBuildConfig.retrieveElement,
      buildItem: PostPageBuildConfig.buildItem,
      scrollController: _scrollController,
    );
  }

  void scrollToTop() {
    if (_scrollController.position.pixels == 0) {
      refreshIndicatorKey.currentState?.show();
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