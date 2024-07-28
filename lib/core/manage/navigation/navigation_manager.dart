abstract class INavigationService {
  Future<void> navigateToPage({required String path, Object? object});

  Future<void> navigateToPageRemovedUntil(
      {required String path, Object? object});

  Future<void> navigateToPushReplacement(
      {required String path, Object? object});
}
