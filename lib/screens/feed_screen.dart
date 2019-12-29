import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/post_model.dart';
import '../services/database_services.dart';
import '../models/user_model.dart';
import './profile_screen.dart';

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

  Container _buildPost(Post post, User author) {
    return Container(
      margin: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.white,
      ),
      child: Column(
        children: <Widget>[
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (ctx) => ProfileScreen(
                  currentUserId: widget.currentUserId,
                  userId: post.authorId,
                ),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 15.0,
                horizontal: 12.0,
              ),
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.blue,
                    backgroundImage: author.profileImageUrl.isEmpty
                        ? AssetImage('assets/images/user_placeholder_image.png')
                        : CachedNetworkImageProvider(author.profileImageUrl),
                  ),
                  SizedBox(
                    width: 8.0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        author.name,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text('5 min'),
                    ],
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25.0),
              child: Container(
                height: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: CachedNetworkImageProvider(post.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                          ),
                          iconSize: 30.0,
                          onPressed: () {},
                        ),
                        Text(
                          '0 likes',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: IconButton(
                            icon: Icon(
                              Icons.comment,
                            ),
                            iconSize: 30.0,
                            onPressed: () {},
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.bookmark_border,
                      ),
                      iconSize: 30.0,
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 4.0),
                Row(
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(left: 12.0, right: 6.0),
                      child: Text(
                        author.name,
                        style: TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        post.caption,
                        style: TextStyle(fontSize: 16.0),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0),
              ],
            ),
          ),
        ],
      ),
    );
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
                                return _buildPost(post, author);
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
