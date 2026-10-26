class StoryItem {
  final String id;
  final String authorName;
  final String avatarUrl;
  final bool isLive;
  final bool hasUnseen;

  const StoryItem({
    required this.id,
    required this.authorName,
    required this.avatarUrl,
    this.isLive = false,
    this.hasUnseen = true,
  });
}

class PostItem {
  final String id;
  final String authorName;
  final String authorLocation;
  final String authorAvatar;
  final String communityTag;
  final String text;
  final String? imageUrl;
  int likesCount;
  int commentsCount;
  bool isLiked;
  bool isSaved;
  final DateTime createdAt;
  final List<CommentItem> comments;

  PostItem({
    required this.id,
    required this.authorName,
    required this.authorLocation,
    required this.authorAvatar,
    required this.communityTag,
    required this.text,
    this.imageUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
    this.isSaved = false,
    required this.createdAt,
    List<CommentItem>? comments,
  }) : comments = comments ?? [];
}

class VideoReelItem {
  final String id;
  final String authorName;
  final String authorHandle;
  final String authorAvatar;
  final String title;
  final String platform; // Odysee, YouTube Shorts, TikTok, Kwai, Reels
  final String platformBadge;
  final String thumbnailUrl;
  int likesCount;
  int commentsCount;
  bool isLiked;

  VideoReelItem({
    required this.id,
    required this.authorName,
    required this.authorHandle,
    required this.authorAvatar,
    required this.title,
    required this.platform,
    required this.platformBadge,
    required this.thumbnailUrl,
    this.likesCount = 0,
    this.commentsCount = 0,
    this.isLiked = false,
  });
}

class CommentItem {
  final String id;
  final String authorName;
  final String text;
  final DateTime createdAt;

  CommentItem({
    required this.id,
    required this.authorName,
    required this.text,
    required this.createdAt,
  });
}
