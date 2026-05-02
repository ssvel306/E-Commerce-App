import 'package:ecom/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';



class AddressScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final String paymentMethod;
  final VoidCallback onOrderPlaced;

  const AddressScreen({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.paymentMethod,
    required this.onOrderPlaced,
  });

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _pincodeController = TextEditingController();

  bool _isLoading = false;
  bool _isLoadingAddress = true;
  bool _hasSavedAddress = false;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _pincodeController.dispose();
    super.dispose();
  }

  // ✅ Load saved address from Firebase
  Future<void> _loadSavedAddress() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() => _isLoadingAddress = false);
        return;
      }

      final ref = FirebaseDatabase.instance.ref('users/${user.uid}/address');
      final snapshot = await ref.get();

      if (snapshot.exists) {
        final address = Map<String, dynamic>.from(snapshot.value as Map);

        setState(() {
          _nameController.text    = address['name']    ?? '';
          _phoneController.text   = address['phone']   ?? '';
          _streetController.text  = address['street']  ?? '';
          _cityController.text    = address['city']    ?? '';
          _stateController.text   = address['state']   ?? '';
          _pincodeController.text = address['pincode'] ?? '';
          _hasSavedAddress        = true;
          _isLoadingAddress       = false;
        });

        // ✅ Show banner after build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showAddressConfirmBanner();
        });

      } else {
        setState(() => _isLoadingAddress = false);
      }
    } catch (e) {
      setState(() => _isLoadingAddress = false);
    }
  }

  // ✅ Green banner — auto filled address
  void _showAddressConfirmBanner() {
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        backgroundColor: Colors.green[50],
        leading: const Icon(Icons.location_on, color: Colors.green),
        content: Text(
          '✅ Your saved address has been filled automatically.',
          style: TextStyle(
            color: Colors.green[800],
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
            },
            child: const Text('OK', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              _clearAllFields();
            },
            child: const Text('Change', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ✅ Clear all fields
  void _clearAllFields() {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _streetController.clear();
      _cityController.clear();
      _stateController.clear();
      _pincodeController.clear();
      _hasSavedAddress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      // ✅ Show loading while fetching address
      body: _isLoadingAddress
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                    'Loading your saved address...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // ✅ Header
                    const Text(
                      'Where should we deliver?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _hasSavedAddress
                          ? 'Your saved address is filled. Edit if needed.'
                          : 'Fill in your delivery details',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 24),

                    // ✅ Form Fields
                    _buildField(_nameController,    'Full Name',     Icons.person,        'Enter your full name'),
                    _buildField(_phoneController,   'Phone Number',  Icons.phone,         'Enter phone number', type: TextInputType.phone),
                    _buildField(_streetController,  'Street / Area', Icons.home,          'House no, Street, Area'),
                    _buildField(_cityController,    'City',          Icons.location_city, 'Enter city'),
                    _buildField(_stateController,   'State',         Icons.map,           'Enter state'),
                    _buildField(_pincodeController, 'Pincode',       Icons.pin,           'Enter pincode', type: TextInputType.number),

                    const SizedBox(height: 16),

                    // ✅ Order Summary Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.green[200]!),
                      ),
                      child: Column(
                        children: [
                          _summaryRow('Items', '${widget.cartItems.length}'),
                          _summaryRow('Payment', widget.paymentMethod),
                          _summaryRow('Delivery', 'FREE'),
                          const Divider(),
                          _summaryRow(
                            'Total',
                            '₹${widget.totalAmount.toStringAsFixed(2)}',
                            bold: true,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ✅ Place Order Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Place Order',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }

  // ✅ Form field builder
  Widget _buildField(
    TextEditingController controller,
    String label,
    IconData icon,
    String hint, {
    TextInputType type = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          prefixIcon: Icon(icon, color: Colors.green),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.green, width: 2),
          ),
        ),
        validator: (val) =>
            val == null || val.trim().isEmpty ? '$label is required' : null,
      ),
    );
  }

  // ✅ Summary row builder
  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[700])),
          Text(
            value,
            style: TextStyle(
              fontWeight: bold ? FontWeight.bold : FontWeight.normal,
              color: bold ? Colors.green : Colors.black,
              fontSize: bold ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }

  // ✅ Place order + save address to user profile
  Future<void> _placeOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final dbRef = FirebaseDatabase.instance.ref();
      final orderId = dbRef.child('orders').push().key!;

      final addressData = {
        'name':    _nameController.text.trim(),
        'phone':   _phoneController.text.trim(),
        'street':  _streetController.text.trim(),
        'city':    _cityController.text.trim(),
        'state':   _stateController.text.trim(),
        'pincode': _pincodeController.text.trim(),
      };

      final orderData = {
        'orderId':       orderId,
        'userId':        user.uid,
        'items': widget.cartItems.map((item) => {
          'name':     item['name'],
          'price':    item['price'],
          'quantity': item['quantity'] ?? 1,
          'total':    (item['price'] * (item['quantity'] ?? 1)),
        }).toList(),
        'total':         widget.totalAmount,
        'paymentMethod': widget.paymentMethod,
        'status':        'placed',
        'timestamp':     DateTime.now().toString(),
        'address':       addressData,
      };

      // ✅ Save order to DB
      await dbRef.child('orders/${user.uid}/$orderId').set(orderData);

      // ✅ Save address to user profile for next time
      await dbRef.child('users/${user.uid}/address').set(addressData);

      setState(() => _isLoading = false);

      // ✅ Show success dialog
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
        _showSuccessDialog(orderId);
      }

    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ Success dialog
  void _showSuccessDialog(String orderId) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              // ✅ Check icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, color: Colors.white, size: 40),
              ),

              const SizedBox(height: 16),

              const Text(
                'Order Placed!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 8),

              Text(
                'Order ID: ${orderId.substring(0, 8).toUpperCase()}',
                style: TextStyle(color: Colors.grey[600], fontSize: 13),
              ),

              const SizedBox(height: 8),

              const Text(
                'Your order has been confirmed.\nWe\'ll deliver it soon! 🚀',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 24),

              // ✅ View My Orders button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    widget.onOrderPlaced(); // ✅ clears cart
                    Navigator.pop(context); // close dialog
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => OrdersScreen()),
                      (route) => route.isFirst,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'View My Orders',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}