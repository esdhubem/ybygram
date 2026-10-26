import 'product.dart';

class UserProfile {
  final String id;
  String name;
  String handle;
  String bio;
  String location; // Ex: "Vitória / ES" ou "Aldeia Yvy Porã"
  String avatarUrl;
  String coverUrl;
  bool isSovereignCreator; // Selo "Criador Soberano"
  bool isMeiSeller;
  int healthPoints;
  List<ProductItem> libraryEbooks;
  List<ProductItem> myStoreProducts;
  int completedOrdersCount;

  UserProfile({
    required this.id,
    required this.name,
    required this.handle,
    required this.bio,
    required this.location,
    required this.avatarUrl,
    required this.coverUrl,
    this.isSovereignCreator = true,
    this.isMeiSeller = true,
    this.healthPoints = 420,
    List<ProductItem>? libraryEbooks,
    List<ProductItem>? myStoreProducts,
    this.completedOrdersCount = 14,
  })  : libraryEbooks = libraryEbooks ?? [],
        myStoreProducts = myStoreProducts ?? [];
}
