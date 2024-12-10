import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:social_tripper_mobile/Components/BottomNavigation/bottom_navigation.dart';
import 'package:social_tripper_mobile/Components/Post/BuildingBlocks/post_photo.dart';
import 'package:social_tripper_mobile/Models/Account/account.dart';
import 'package:social_tripper_mobile/Models/Comment/post_comment.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';
import 'package:social_tripper_mobile/Services/comment_service.dart';
import 'package:social_tripper_mobile/Services/post_service.dart';
import 'package:video_player/video_player.dart';

import '../Shared/interactions.dart';
import 'BuildingBlocks/post_master_bottom.dart';
import 'BuildingBlocks/post_text_content.dart';
import 'BuildingBlocks/post_master_top_bar.dart';

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
  late Set<String> photoURIs;
  late List<Widget> preloadedImages = [];
  int _currentPage = 0;
  bool _isAnimatingLike = false;
  PostService postService = PostService();
  AccountService accountService = AccountService();

  @override
  void initState() {
    super.initState();
    likeCount = widget.model.reactionsNumber;
    commentCount = widget.model.commentsNumber;
    isLiked = widget.model.isLiked;
    _pageController = PageController();
    photoURIs = widget.model.postMultimediaUrls ?? Set<String>();

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
        if (_isVideo(uri)) {
          final controller = VideoPlayerController.network(uri);
          await controller.initialize(); // Buforowanie wideo
          controller.dispose(); // Zwolnienie kontrolera po preładowaniu
        } else {
          final image = CachedNetworkImageProvider(uri);
          await image.resolve(ImageConfiguration());
        }
      }));
    }
  }

  bool _isVideo(String uri) {
    final lowerUri = uri.toLowerCase();
    return lowerUri.endsWith('.mp4') ||
        lowerUri.endsWith('.mov') ||
        lowerUri.endsWith('.avi');
  }

  void _toggleLike() async {
    final String accountUUID =
        await AccountService().getSavedAccountUUID() ?? "";
    setState(() {
      if (isLiked) {
        likeCount--;
        isLiked = false;
        widget.model.isLiked = isLiked;
        widget.model.reactionsNumber = likeCount;
        postService.unlikePost(accountUUID, widget.model.uuid).then((success) {
          if (!success) {
            print("Failed to unlike post.");
          } else {
            print("Unliked the post");
          }
        }).catchError((e) {
          print("Error while liking post: $e");
        });
      } else {
        postService.likePost(accountUUID, widget.model.uuid).then((success) {
          if (!success) {
            print("Failed to like post.");
          }
        }).catchError((e) {
          print("Error while liking post: $e");
        });
        likeCount++;
        isLiked = true;
        widget.model.isLiked = isLiked;
        widget.model.reactionsNumber = likeCount;
        _isAnimatingLike = true;

        // Animacja po polubieniu
        Future.delayed(Duration(milliseconds: 600), () {
          setState(() {
            _isAnimatingLike = false; // End animation
          });
        });
      }
    });
  }

  void commentCallback() {
    setState(() {
      commentCount ++;
      widget.model.commentsNumber = commentCount;
    });
  }

  Future<void> _toggleComment() async {
    context.push("/post_comments", extra: {
      'model': widget.model,
      'like_callback': _toggleLike,
      'comment_callback': commentCallback
    });
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
                child: PostMasterTopBar(
                  widget.model
                ),
              ),
              SizedBox(height: 9),
              widget.model.content.length > 0
                  ? Padding(
                      padding:
                          const EdgeInsets.only(left: 9, right: 9),
                      child: PostTextContent(
                        content: widget.model.content,
                      ),
                    )
                  : Container(),
              widget.model.postMultimediaUrls.length > 0 ? SizedBox(height: 9,) : SizedBox(height: 0,),
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
                child: PostMasterBottom(
                  widget.model.account.profilePictureUrl,
                  _toggleComment,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget PostMedia(Set<String> urls) {
    Widget content = Placeholder();
    if (urls.isEmpty) {
      content = SizedBox(width: 0, height: 0,);
    } else if (urls.length == 1) {
      content = PostPhoto(url: urls.elementAt(0));
    } else if (urls.length > 1) {
      content = PhotoSlider(context, _pageController, urls);
    } else {
      content = SizedBox(width: 0, height: 0,);
    }

    if (urls == null || urls.isEmpty) {
      return content;
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        content,
        AnimatedOpacity(
          opacity: _isAnimatingLike ? 1.0 : 0.0,
          // Jeśli animacja trwa, opacity = 1
          duration: Duration(milliseconds: 150),
          // Długość animacji przezroczystości
          child: AnimatedScale(
            scale: _isAnimatingLike ? 1.2 : 0.2,
            // Zamiast 0.2 używamy 1.0, aby animacja była płynniejsza
            duration: Duration(milliseconds: 300),
            // Długość animacji zmiany rozmiaru
            curve: Curves.easeInOut,
            // Płynniejszy efekt
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
    Set<String> urls,
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
                  imageUrl: urls.elementAt(index),
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
