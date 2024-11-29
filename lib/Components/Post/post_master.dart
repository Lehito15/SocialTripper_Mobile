import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:social_tripper_mobile/Components/Post/BuildingBlocks/post_photo.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';

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
  int _currentPage = 0; // Śledzenie aktualnej strony w PageView

  @override
  void initState() {
    super.initState();
    likeCount = widget.model.numLikes;
    commentCount = widget.model.numComments;
    isLiked = widget.model.isLiked;
    _pageController = PageController();
    // Wczytujemy listę URI zdjęć
    photoURIs = widget.model.photoURIs ?? [];

    // Ładujemy obrazy wstępnie
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: TripMasterTopBar(widget.model.author, widget.model.postedDate),
              ),
              SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: PostTextContent(content: widget.model.content),
              ),
              // Display image slider if more than one photo URI exists
              widget.model.photoURIs != null && widget.model.photoURIs!.length == 1 ?
                AspectRatio(
                  aspectRatio: 3 / 4,
                  child: CachedNetworkImage(
                    imageUrl: widget.model.photoURIs![0],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Icon(Icons.error, color: Colors.red),
                    ),
                    fadeInDuration: Duration(milliseconds: 300),
                    fadeOutDuration: Duration(milliseconds: 300),
                  ),
                ) : Container(),
              widget.model.photoURIs != null && widget.model.photoURIs!.length > 1
                  ? Container(
                height: MediaQuery.of(context).size.width * (4 / 3), // 3:4 ratio
                child: Column(
                  children: [
                    // PageView z aktualizacją stanu
                    Expanded(
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: widget.model.photoURIs!.length,
                        itemBuilder: (context, index) {
                          return CachedNetworkImage(
                            imageUrl: widget.model.photoURIs![index],
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
                    // Wskaźniki na dole
                    SizedBox(height: 9,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        widget.model.photoURIs!.length,
                            (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _currentPage == index
                                ? Colors.blue // Kolor aktywnego wskaźnika
                                : Colors.grey, // Kolor nieaktywnego wskaźnika
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: Interactions(likeCount, commentCount, isLiked, _toggleLike, _toggleComment),
              ),
              SizedBox(height: 9),
              Padding(
                padding: const EdgeInsets.only(left: 9, right: 9),
                child: PostMasterBottom(widget.model.author.pictureURI),
              ),
            ],
          ),
        ),
      ),
    );
  }
}