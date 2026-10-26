import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';
import '../services/mock_pagarme_service.dart';

class CheckoutModal extends StatefulWidget {
  final ProductItem product;

  const CheckoutModal({
    super.key,
    required this.product,
  });

  static void show(BuildContext context, ProductItem product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CheckoutModal(product: product),
    );
  }

  @override
  State<CheckoutModal> createState() => _CheckoutModalState();
}

class _CheckoutModalState extends State<CheckoutModal> {
  int _paymentMethod = 0; // 0: Pix, 1: Cartão
  late PaymentSplitResult _splitResult;
  bool _isPaid = false;

  @override
  void initState() {
    super.initState();
    _splitResult = MockPagarMeService.processPixCheckout(widget.product);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final p = widget.product;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Barra de arraste
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // Título e Selo Pagar.me
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Checkout Comunitário',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF245C45).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lock_outline, size: 13, color: Color(0xFF245C45)),
                    SizedBox(width: 4),
                    Text(
                      'Pagar.me Split',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF245C45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Resumo do Produto
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  p.imageUrl,
                  width: 54,
                  height: 54,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.shopping_bag),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      p.sellerBadge,
                      style: TextStyle(fontSize: 12, color: theme.colorScheme.secondary),
                    ),
                    Text(
                      p.formattedPrice,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF245C45),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          // Detalhes do Split Justo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withOpacity(0.25),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor.withOpacity(0.1)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Repasse ao Criador (95%):', style: theme.textTheme.bodySmall),
                    Text('R\$ ${_splitResult.sellerAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Fundo Comunitário YBY (5%):', style: theme.textTheme.bodySmall),
                    Text('R\$ ${_splitResult.platformFee.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Escolha do método: Pix ou Cartão
          Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  label: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.qr_code, size: 16),
                      SizedBox(width: 6),
                      Text('PIX Imediato'),
                    ],
                  ),
                  selected: _paymentMethod == 0,
                  onSelected: (_) => setState(() => _paymentMethod = 0),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ChoiceChip(
                  label: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.credit_card, size: 16),
                      SizedBox(width: 6),
                      Text('Cartão de Crédito'),
                    ],
                  ),
                  selected: _paymentMethod == 1,
                  onSelected: (_) => setState(() => _paymentMethod = 1),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isPaid) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF245C45).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF245C45)),
              ),
              child: Column(
                children: [
                  const Icon(Icons.check_circle, color: Color(0xFF245C45), size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Pagamento Confirmado com Sucesso!',
                    style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF245C45)),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    p.isEbook
                        ? 'Seu E-book foi adicionado à sua biblioteca pessoal!'
                        : 'O artesão já foi notificado e o frete será gerado no Melhor Envio.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
          ] else if (_paymentMethod == 0) ...[
            // Bloco do Pix
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
              ),
              child: Column(
                children: [
                  const Text('Chave PIX Copia e Cola:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  SelectableText(
                    _splitResult.pixQrCodePayload,
                    maxLines: 2,
                    style: const TextStyle(fontSize: 10, fontFamily: 'monospace'),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF245C45),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    icon: const Icon(Icons.copy, size: 16),
                    label: const Text('Copiar Código PIX'),
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: _splitResult.pixQrCodePayload));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Código Pix copiado! Cole no seu banco.')),
                      );
                      Future.delayed(const Duration(seconds: 2), () {
                        if (mounted) setState(() => _isPaid = true);
                      });
                    },
                  ),
                ],
              ),
            ),
          ] else ...[
            // Bloco do Cartão
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF245C45),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                setState(() => _isPaid = true);
              },
              child: Text('Pagar ${p.formattedPrice} em até 3x sem juros'),
            ),
          ],
        ],
      ),
    );
  }
}
