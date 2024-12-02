import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:social_tripper_mobile/Components/Post/BuildingBlocks/post_photo.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Utilities/Retrievers/icon_retriever.dart';

import '../../Models/Post/post_master_author.dart';
import '../../Utilities/DataGenerators/generated_user.dart';
import '../Shared/interactions.dart';
import 'BuildingBlocks/post_master_bottom.dart';
import 'BuildingBlocks/post_text_content.dart';
import 'BuildingBlocks/trip_master_top_bar.dart';

class PostMaster extends StatefulWidget {
  final PostMasterModel model;

  PostMaster(this.model);

  @override
  _PostMasterState createState() => _PostMasterState();
}

class _PostMasterState extends State<PostMaster> {
  late PageController _pageController;
  late int likeCount;
  late int commentCount;
  late bool isLiked;
  late List<String> photoURIs;
  late List<Widget> preloadedImages = [];
  int _currentPage = 0;
  bool _isAnimatingLike = false;

  @override
  void initState() {
    super.initState();
    likeCount = widget.model.numLikes;
    commentCount = widget.model.commentsNumber;
    isLiked = widget.model.isLiked;
    _pageController = PageController();
    photoURIs = widget.model.postMultimediaUrls ?? [];

    preloadedImages = [];
    _preloadImages();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Funkcja do wstępnego ładowania obrazów
  Future<void> _preloadImages() async {
    if (photoURIs.isNotEmpty) {
      await Future.wait(photoURIs.map((uri) async {
        final image = CachedNetworkImageProvider(uri);
        await image.resolve(ImageConfiguration());
      }));
    }
  }

  void _toggleLike() {
    setState(() {
      if (isLiked) {
        likeCount--;
      } else {
        likeCount++;
        _isAnimatingLike = true;
        Future.delayed(Duration(milliseconds: 600), () {
          print("delayed");
          setState(() {
            _isAnimatingLike = false; // Zakończ animację po 600 ms
          });
        });
      }
      isLiked = !isLiked;
      widget.model.isLiked = isLiked; // Update model's like status
      widget.model.numLikes = likeCount; // Update like count in model

    });
  }

  void _toggleComment() {
    print("Comment clicked");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: _toggleLike, // Action on double tap
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 9, bottom: 9),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: TripMasterTopBar(
                  widget.model.author,
                  widget.model.postedDate,
                ),
              ),
              SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: PostTextContent(
                  content: widget.model.content,
                ),
              ),
              PostMedia(widget.model.postMultimediaUrls),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: Interactions(
                  likeCount,
                  commentCount,
                  isLiked,
                  _toggleLike,
                  _toggleComment,
                ),
              ),
              SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: PostMasterBottom(widget.model.author.profilePictureUrl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostMedia(List<String>? urls) {
    Widget content = Placeholder();
    if (urls == null || urls.isEmpty) {
      content = Container();
    } else if (urls.length == 1) {
      content = PostPhoto(urls[0]);
    } else if (urls.length > 1) {
      content = PhotoSlider(context, _pageController, urls);
    } else {
      content = Container();
    }


    if (urls == null || urls.isEmpty) {
      return content;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        content,
        AnimatedOpacity(
          opacity: _isAnimatingLike ? 1.0 : 0.0, // Jeśli animacja trwa, opacity = 1
          duration: Duration(milliseconds: 150), // Długość animacji przezroczystości
          child: AnimatedScale(
            scale: _isAnimatingLike ? 1.2 : 0.2, // Zamiast 0.2 używamy 1.0, aby animacja była płynniejsza
            duration: Duration(milliseconds: 300), // Długość animacji zmiany rozmiaru
            curve: Curves.easeInOut, // Płynniejszy efekt
            child: Container(
              width: 120,
              height: 120,
              child: SvgPicture.asset("assets/interactions/like_active.svg"),
            ),
          ),
        ),
      ],
    );
  }

  Container PhotoSlider(
    BuildContext context,
    PageController controller,
    List<String> urls,
  ) {
    return Container(
      height: MediaQuery.of(context).size.width * (4 / 3), // 3:4 ratio
      child: Column(
        children: [
          // PageView z aktualizacją stanu
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: urls.length,
              itemBuilder: (context, index) {
                return CachedNetworkImage(
                  imageUrl: urls[index],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(Icons.error, color: Colors.red),
                  ),
                  fadeInDuration: Duration(milliseconds: 300),
                  fadeOutDuration: Duration(milliseconds: 300),
                );
              },
              onPageChanged: _onPageChanged, // Obsługuje zmianę strony
            ),
          ),
          SizedBox(
            height: 9,
          ),
          PhotoSliderBottomIndicator(
              colorActive: Color(0xffBDF271),
              colorInactive: Colors.black,
              radius: 6.0),
        ],
      ),
    );
  }

  Row PhotoSliderBottomIndicator({
    double radius = 8.0,
    Color colorActive = Colors.blue,
    Color colorInactive = Colors.grey,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        widget.model.postMultimediaUrls!.length,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: radius,
          height: radius,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _currentPage == index ? colorActive : colorInactive,
          ),
        ),
      ),
    );
  }
}
