abstract final class AppRoutes {
  static const String home = '/';
  static const String posts = '/posts';
  static const String users = '/users';
  static const String favorites = '/favorites';
  static const String postDetailsSegment = ':postId';
  static String postDetails(int postId) => '$posts/$postId';
  static const String postCreateSegment = 'create';
  static const String postCreate = '$posts/create';
  static const String postEditSegment = 'edit';
  static String postEdit(int postId) => '${postDetails(postId)}/edit';
  static const String userProfileSegment = ':userId';
  static String userProfile(int userId) => '$users/$userId';
}
