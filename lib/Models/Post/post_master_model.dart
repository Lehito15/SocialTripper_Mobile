import 'package:social_tripper_mobile/Models/Post/post_master_author.dart';

class PostMasterModel {
  PostMasterAuthor author;
  DateTime postedDate;
  String content;
  List<String>? photoURIs;
  int numLikes;
  int numComments;
  bool isLiked;

  PostMasterModel(this.author, this.postedDate, this.content, this.photoURIs,
      this.numLikes, this.numComments, {this.isLiked = false});
}
