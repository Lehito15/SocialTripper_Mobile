import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Services/comment_service.dart';
import 'package:social_tripper_mobile/Utilities/Converters/date_converter.dart';

import '../../Models/Comment/post_comment.dart';
import '../../Models/Shared/interaction.dart';
import '../../Services/account_service.dart';
import '../Shared/bordered_user_picture.dart';
import '../Shared/expandable_text.dart';
import '../Shared/interaction.dart';

class PostCommentWidget extends StatefulWidget {
  final PostComment postComment;

  const PostCommentWidget({Key? key, required this.postComment}) : super(key: key);

  @override
  _PostCommentWidgetState createState() => _PostCommentWidgetState();
}

class _PostCommentWidgetState extends State<PostCommentWidget> {
  late bool isLiked;
  late int reactionsNumber;


  @override
  void initState() {
    super.initState();
    isLiked = widget.postComment.isLiked;
    reactionsNumber = widget.postComment.reactionsNumber;
    print("is liked: $isLiked");
  }

  void _toggleLike() async {
    final String accountUUID =
        await AccountService().getSavedAccountUUID() ?? "";
    final String commentUUID = widget.postComment.uuid;

    setState(() {
      if (isLiked) {
        isLiked = false;
        reactionsNumber--;
        CommentService().unlikeComment(commentUUID, accountUUID);
      } else {
        isLiked = true;
        reactionsNumber++;
        CommentService().likeComment(commentUUID, accountUUID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BorderedUserPicture(
          radius: 34,
          pictureURI: widget.postComment.author.profilePictureUrl,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: GestureDetector(
            onDoubleTap: _toggleLike,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF0F2F5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 9, right: 9, top: 2, bottom: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.postComment.author.nickname,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: "Source Sans 3",
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        ExpandableDescriptionText(
                          description: widget.postComment.content,
                          textStyle: TextStyle(
                            fontSize: 13,
                            fontFamily: "Source Sans 3",
                            fontWeight: FontWeight.w400,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 9),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Interaction(
                          type: isLiked ? InteractionType.LIKE_ACTIVE : InteractionType.LIKE,
                          interactionCount: reactionsNumber,
                          onToggleInteraction: _toggleLike,
                          width: 16,
                          height: 16,
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.topRight,
                            child: Text(
                              DateConverter.convertDatetimeToString(widget.postComment.timestamp),
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontFamily: "Source Sans 3",
                                fontSize: 12,
                                color: Colors.black.withOpacity(0.5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}