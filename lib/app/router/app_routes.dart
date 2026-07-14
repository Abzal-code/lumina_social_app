abstract final class AppRoutes {
  static const String home = '/';
  static const String posts = '/posts';
  static const String users = '/users';
  static const String favorites = '/favorites';
  static const String postDetailsSegment = ':postId';
  static String postDetails(int postId) => '$posts/$postId';
}
