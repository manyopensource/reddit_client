import 'dart:io';

import 'package:draw/draw.dart';
import 'package:flutter/material.dart';
import 'package:reddit_client/widgets/comment/comment_list.dart';
import 'package:reddit_client/widgets/post_content/post_content.dart';
import 'package:reddit_client/widgets/post_info.dart';

class PostDetails extends StatefulWidget {
  final Submission post;

  const PostDetails(this.post);

  @override
  _PostDetailsState createState() => _PostDetailsState();
}

class _PostDetailsState extends State<PostDetails> {
  Submission _post;

  @override
  void initState() {
    super.initState();
    refreshPost();
  }

  Future<void> refreshPost() => widget.post.refresh().then((post) {
        final Submission updatedPost = post.first;
        if (mounted)
          setState(() {
            _post = updatedPost;
          });
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkResponse(
          child: Icon(Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
          onTap: () => Navigator.of(context).pop(_post),
        ),
      ),
      body: _post == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: refreshPost,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _post.title,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          PostContent(_post),
                          SizedBox(height: 8.0),
                          PostInfo(_post),
                          SizedBox(height: 4.0),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      child: Text(
                        'COMMENTS',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    CommentList(post: _post),
                  ],
                ),
              ),
            ),
    );
  }
}
