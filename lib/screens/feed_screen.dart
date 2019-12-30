import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/database_services.dart';
import '../models/user_model.dart';
import '../widgets/post_view.dart';

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed-screen';
  final String currentUserId;

  FeedScreen({this.currentUserId});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Post> _posts = [];
  var _isLoading = false;

  Future<void> _setUpFeed() async {
    _isLoading = true;
    List<Post> postsData =
        await DatabaseService.getFeedPosts(widget.currentUserId);

    setState(() {
      _posts = postsData;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    _setUpFeed();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> stories = [
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
      'assets/images/user_profile_placeholder.png',
    ];

    return Scaffold(
      backgroundColor: Color(0xFFEDF0F6),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Instagram',
          style: TextStyle(
            color: Colors.black,
            fontFamily: 'Madame',
            fontSize: 40.0,
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              Icons.live_tv,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Icon(Icons.send),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _posts.length <= 0
              ? Center(
                  child: Text(
                    'No posts available',
                    style: TextStyle(fontSize: 18.0),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => _setUpFeed(),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        height: 100.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: stories.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              width: 60.0,
                              height: 60.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black45,
                                    blurRadius: 6.0,
                                    offset: Offset(0, 2),
                                  )
                                ],
                              ),
                              margin: const EdgeInsets.all(10.0),
                              child: CircleAvatar(
                                child: ClipOval(
                                  child: Image(
                                    image: AssetImage(
                                      stories[index],
                                    ),
                                    fit: BoxFit.cover,
                                    height: 60.0,
                                    width: 60.0,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          physics: AlwaysScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: _posts.length,
                          itemBuilder: (ctx, index) {
                            Post post = _posts[index];
                            return FutureBuilder(
                              future:
                                  DatabaseService.getUserWithId(post.authorId),
                              builder: (ctx, snapshot) {
                                if (!snapshot.hasData) {
                                  return SizedBox.shrink();
                                }
                                User author = snapshot.data;
                                return PostView(
                                  currentUserId: widget.currentUserId,
                                  post: post,
                                  author: author,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
