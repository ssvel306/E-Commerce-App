
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'address_screen.dart';
import 'main.dart';
import 'package:ecom/main.dart';
import 'package:ecom/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class PaymentScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
   final VoidCallback onOrderPlaced; // ✅ ADD THIS


  const PaymentScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
      required this.onOrderPlaced, // ✅ ADD THIS
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String selectedPayment = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Method'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select Payment Method',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Cash on Delivery
            _buildPaymentTile(
              icon: Icons.money,
              title: 'Cash on Delivery',
              subtitle: 'Pay when your order arrives',
              value: 'cod',
            ),

            // Online Payment (disabled for now)
            _buildPaymentTile(
              icon: Icons.credit_card,
              title: 'Online Payment',
              subtitle: 'Coming soon',
              value: 'online',
              disabled: true,
            ),

            const Spacer(),

            // Order Summary
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Amount',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(
                    '\$${widget.totalAmount.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.green),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: selectedPayment.isEmpty ? null : _proceed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('Continue',
                    style: TextStyle(fontSize: 16, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required String value,
    bool disabled = false,
  }) {
    return Opacity(
      opacity: disabled ? 0.4 : 1.0,
      child: GestureDetector(
        onTap: disabled ? null : () => setState(() => selectedPayment = value),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(
              color: selectedPayment == value ? Colors.green : Colors.grey[300]!,
              width: selectedPayment == value ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
            color: selectedPayment == value ? Colors.green[50] : Colors.white,
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: selectedPayment == value ? Colors.green : Colors.grey),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: selectedPayment == value
                                ? Colors.green
                                : Colors.black)),
                    Text(subtitle,
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600])),
                  ],
                ),
              ),
              if (selectedPayment == value)
                const Icon(Icons.check_circle, color: Colors.green),
            ],
          ),
        ),
      ),
    );
  }

  void _proceed() {
    if (selectedPayment == 'cod') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => AddressScreen(
            cartItems: widget.cartItems,
            totalAmount: widget.totalAmount,
            paymentMethod: 'Cash on Delivery',
            onOrderPlaced: widget.onOrderPlaced, // ✅ ADD THIS
          ),
        ),
      );
    }
  }
}