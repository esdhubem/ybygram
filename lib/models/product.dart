enum ProductType {
  officialPod,   // Produtos Oficiais YBYgram (POD - Algodão Orgânico)
  localArtisan,  // Artesãos locais / MEI (Fitoterápicos, Biojoias, Alimentos)
  physicalBook,  // Livros Físicos (UICLAP)
  ebookDigital,  // E-books e PDFs Digitais
}

class ProductItem {
  final String id;
  final String title;
  final String sellerName;
  final String sellerBadge; // "Exclusivo YBYgram (POD)", "Artesão Local MEI", "Editora UICLAP"
  final ProductType type;
  final double price;
  final String imageUrl;
  final String description;
  final bool isEbook;
  final String? pdfDownloadUrl;
  final String location;
  final double rating;
  final int salesCount;

  const ProductItem({
    required this.id,
    required this.title,
    required this.sellerName,
    required this.sellerBadge,
    required this.type,
    required this.price,
    required this.imageUrl,
    required this.description,
    this.isEbook = false,
    this.pdfDownloadUrl,
    required this.location,
    this.rating = 4.9,
    this.salesCount = 28,
  });

  String get formattedPrice => 'R\$ ${price.toStringAsFixed(2).replaceAll('.', ',')}';
}
