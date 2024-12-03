import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Pages/config/data_retrieving_config.dart';
import 'package:social_tripper_mobile/Pages/config/post_page_build_config.dart';
import 'package:social_tripper_mobile/Pages/config/scrolling_treshholds.dart';
import 'package:social_tripper_mobile/Repositories/post_repository.dart';
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
  late GenericContentPage<PostMasterModel> content;
  final ScrollController _scrollController = ScrollController();

  Future<void> placeholderOnRefresh() async {
    await Future.value(0);
  }

  Future<void> _getUserData() async {
    try {
      // Pobierz aktualnie zalogowanego użytkownika
      final user = await Amplify.Auth.getCurrentUser();

      // Możesz teraz używać danych użytkownika (np. email, username)
      print("User is logged in: ${user.username}");

      // Jeśli chcesz pobrać więcej szczegółowych informacji o użytkowniku, np. attributes
      final userAttributes = await Amplify.Auth.fetchUserAttributes();
      print("User attributes: $userAttributes");

      // Dalsze operacje, np. pobieranie danych z backendu, jak posty
      // Możesz tu również załadować dane związane z użytkownikiem, np. posty
    } catch (e) {
      print("Error getting user data: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _getUserData();
    content = GenericContentPage(
      onRefresh: DataRetrievingConfig.source == Source.BACKEND ? PostRepository.initialize : placeholderOnRefresh,
      scrollTresholdFunction: getLinearThreshold,
      precachingStrategy: PostPageBuildConfig.cachingStrategy,
      retrieveContent: DataRetrievingConfig.source == Source.BACKEND ? PostPageBuildConfig.retrieveBackendElement : PostPageBuildConfig.retrieveGeneratedElement,
      buildItem: PostPageBuildConfig.buildItem,
      scrollController: _scrollController,
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
    print("building home page");
    return content;
  }
}
