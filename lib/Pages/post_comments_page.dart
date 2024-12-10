import 'package:flutter/material.dart';
import 'package:social_tripper_mobile/Components/Comments/post_comment.dart';
import 'package:social_tripper_mobile/Components/Shared/bordered_user_picture.dart';
import 'package:social_tripper_mobile/Components/Shared/expandable_text.dart';
import 'package:social_tripper_mobile/Components/Shared/interaction.dart';
import 'package:social_tripper_mobile/Components/Shared/interactions.dart';
import 'package:social_tripper_mobile/Components/Shared/send_input.dart';
import 'package:social_tripper_mobile/Models/Comment/post_comment.dart';
import 'package:social_tripper_mobile/Models/Post/post_master_model.dart';
import 'package:social_tripper_mobile/Models/Shared/interaction.dart';
import 'package:social_tripper_mobile/Services/account_service.dart';
import 'package:social_tripper_mobile/Services/comment_service.dart';
import 'package:social_tripper_mobile/Utilities/DataGenerators/lorem_ipsum.dart';

// List<PostComment> comments = await CommentService().loadPostComments(widget.model.uuid);

class PostCommentsPage extends StatefulWidget {
  final PostMasterModel model;
  final void Function() onLikeClick;
  final void Function() commentCallback;

  const PostCommentsPage(this.model, this.onLikeClick, this.commentCallback,
      {super.key});

  @override
  State<PostCommentsPage> createState() => _PostCommentsPageState();
}

class _PostCommentsPageState extends State<PostCommentsPage> {
  late int numLikes;
  late int numComments;
  late bool isLiked;
  late List<PostComment> _comments = []; // Zmieniamy z Future na List
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();
    numLikes = widget.model.reactionsNumber;
    numComments = widget.model.commentsNumber;
    isLiked = widget.model.isLiked;
    _loadComments(); // Ładujemy komentarze podczas inicjalizacji
  }

  // Funkcja do załadowania komentarzy
  Future<void> _loadComments() async {
    isLoading = true;
    try {
      final comments =
          await CommentService().loadPostComments(widget.model.uuid);
      final commentsWithLikes = await _checkAllLikes(comments);
      setState(() {
        _comments = commentsWithLikes;
      });
      isLoading = false;
    } catch (e) {
      print("Error loading comments: $e");
    }
  }

  // Sprawdzamy, czy użytkownik polubił komentarz
  Future<List<PostComment>> _checkAllLikes(List<PostComment> comments) async {
    final userUUID = await AccountService().getSavedAccountUUID();

    for (var comment in comments) {
      bool isLiked =
          await CommentService().didUserLikeComment(comment.uuid, userUUID!);
      comment.isLiked = isLiked;
    }

    return comments;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.only(left: 9, right: 9),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopBar(),
              Expanded(
                child: isLoading
                    ? Center(
                        child:
                            CircularProgressIndicator()) // Sprawdzamy, czy lista jest pusta
                    : (_comments.isEmpty
                        ? Center(
                            child: Text("No comments"),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(top: 9),
                            child: ListView.builder(
                              itemCount: _comments.length,
                              itemBuilder: (context, index) {
                                return PostCommentWidget(
                                    postComment: _comments[index]);
                              },
                            ),
                          )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 9.0),
                child: SendInput(onSend: (val) async {
                  final userUUID = await AccountService().getSavedAccountUUID();
                  final post = widget.model;
                  final postUUID = post.uuid;
                  final author =
                      await AccountService().getAccountByUUID(userUUID!);
                  final PostComment comment = PostComment(
                      "", val, DateTime(2020, 0, 0, 0, 0), 0, post, author);

                  CommentService()
                      .createPostComment(postUUID, userUUID, comment);

                  // Dodajemy nowy komentarz do lokalnej listy
                  setState(() {
                    _comments.add(comment);
                    widget.commentCallback();
                    numComments++;
                  });
                },
                authorFuture: AccountService().getMyAccount(),),
              )
            ],
          ),
        ),
      ),
    );
  }

  void onLikeClickWrapper() {
    print("wrapper");

    // Aktualizowanie danych
    if (isLiked) {
      numLikes--;
    } else {
      numLikes++;
    }
    isLiked = !isLiked;

    // Wywołanie setState, aby zaktualizować UI
    setState(() {});

    // Wywołanie callbacku
    widget.onLikeClick();
  }

  Interactions TopBar() {
    return Interactions(
      numLikes,
      numComments,
      isLiked,
      onLikeClickWrapper,
      () {},
    );
  }
} /**/
