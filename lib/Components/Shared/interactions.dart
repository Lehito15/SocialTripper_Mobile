import 'package:flutter/material.dart';
import '../../Models/Shared/interaction.dart';
import 'interaction.dart';


class Interactions extends StatelessWidget {
  final int likeCount;
  final int commentCount;
  final bool isLiked;
  final VoidCallback onClickLikeInteraction;
  final VoidCallback onClickCommentInteraction;


  Interactions(this.likeCount, this.commentCount, this.isLiked,
      this.onClickLikeInteraction, this.onClickCommentInteraction);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black.withOpacity(0.1),
            width: 1.0,
          ),
        ),
      ),
      child: Row(
        children: [
          Interaction(
            type: isLiked ? InteractionType.LIKE_ACTIVE : InteractionType.LIKE,
            interactionCount: likeCount,
            onToggleInteraction: onClickLikeInteraction,
          ),
          SizedBox(width: 15),
          Interaction(
            type: InteractionType.COMMENT,
            interactionCount: commentCount,
            onToggleInteraction: onClickCommentInteraction,
          ),
        ],
      ),
    );
  }
}