import '../models/product.dart';

class PaymentSplitResult {
  final double totalAmount;
  final double sellerAmount;
  final double platformFee;
  final String pixQrCodePayload;
  final String transactionId;

  PaymentSplitResult({
    required this.totalAmount,
    required this.sellerAmount,
    required this.platformFee,
    required this.pixQrCodePayload,
    required this.transactionId,
  });
}

class MockPagarMeService {
  static const double platformFeePercentage = 0.05; // 5% para manutenção comunitária, 95% para o criador

  static PaymentSplitResult processPixCheckout(ProductItem product) {
    final fee = product.price * platformFeePercentage;
    final sellerNet = product.price - fee;
    final txId = 'YBY_${DateTime.now().millisecondsSinceEpoch}';
    final pixCode = '00020126580014br.gov.bcb.pix0136ybygram-split-$txId@pagarme.com520400005303986540'
        '${product.price.toStringAsFixed(2)}5802BR5916YbyGram Comunitario6007Vitoria62070503***6304';

    return PaymentSplitResult(
      totalAmount: product.price,
      sellerAmount: sellerNet,
      platformFee: fee,
      pixQrCodePayload: pixCode,
      transactionId: txId,
    );
  }
}
