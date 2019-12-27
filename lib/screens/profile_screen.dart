import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';

import '../utilities/constants.dart';
import '../models/user_model.dart';
import './edit_profile_screen.dart';
import '../models/user_data_provider.dart';
import '../services/database_services.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile-screen';
  final String userId;
  final String currentUserId;

  ProfileScreen({this.currentUserId, this.userId});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isFollowing = false;
  int followerCount = 0;
  int followingCount = 0;

  Future<void> _setIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );

    setState(() {
      isFollowing = isFollowingUser;
    });
  }

  Future<void> _setUpFollower() async {
    int userFollowerCount = await DatabaseService.numFollowers(widget.userId);

    setState(() {
      followerCount = userFollowerCount;
    });
  }

  Future<void> _setUpFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId);

    setState(() {
      followingCount = userFollowingCount;
    });
  }

  _followOrUnfollow() {
    if (isFollowing) {
      _unfollowUser();
    }else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(widget.currentUserId, widget.userId);

    setState(() {
      isFollowing = false;
      followerCount--;
    });
  }

  _followUser() {
    DatabaseService.followUser(widget.currentUserId, widget.userId);

    setState(() {
      isFollowing = true;
      followerCount++;
    });
  }

  Widget _displayUser(User user) {
    return user.id != Provider.of<UserData>(context).currentUserId
        ? Container(
            width: 200,
            height: 25,
            child: FlatButton(
              textColor: isFollowing ? Colors.black : Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(
                isFollowing ? 'Unfollow' : 'Follow',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: _followOrUnfollow,
              color: isFollowing ? Colors.grey[200] : Colors.blue,
            ),
          )
        : Container(
            width: 200,
            height: 25,
            child: FlatButton(
              textColor: Colors.white,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              child: Text(
                'Edit Profile',
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => EditProfileScreen(
                    user: user,
                  ),
                ),
              ),
              color: Colors.blue,
            ),
          );
  }

  @override
  void initState() {
    super.initState();

    _setIsFollowing();
    _setUpFollower();
    _setUpFollowing();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      body: FutureBuilder(
        future: userRef.document(widget.userId).get(),
        builder: (ctx, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          User user = User.fromDoc(snapshot.data);
          return ListView(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 0.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 50.0,
                      backgroundImage: user.profileImageUrl.isEmpty
                          ? AssetImage(
                              'assets/images/user_profile_placeholder.png')
                          : CachedNetworkImageProvider(
                              user.profileImageUrl,
                            ),
                    ),
                    Expanded(
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Text(
                                    '0',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Posts',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '$followerCount',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Followers',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: <Widget>[
                                  Text(
                                    '$followingCount',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Following',
                                    style: TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 8.0,
                          ),
                          _displayUser(user),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30.0,
                  vertical: 10.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 80,
                      child: Text(
                        user.bio,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
