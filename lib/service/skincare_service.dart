import '../model/product_model.dart';
import '../repo/skincare_repository.dart';

class SkincareService {
  final SkincareRepository _repo = SkincareRepository();

  Future<List<SkincareProduct>> readAll() {
    return _repo.fetchAll();
  }

  Future<List<SkincareProduct>> readByCategory(String categoryName) {
    return _repo.fetchByCategory(categoryName);
  }

  Future<List<SkincareProduct>> search(String query) {
    return _repo.search(query);
  }

  Future<List<SkincareProduct>> readFeatured() {
    return _repo.fetchFeatured();
  }
}