import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';
import 'SignupPage.dart';

import 'ProfileScreen.dart';
import 'package:firebase_database/firebase_database.dart';
import 'EditProfilePage.dart';
import 'address_screen.dart';
import 'payment_screen.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ECommerceApp());
}

class ECommerceApp extends StatelessWidget {
  const ECommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HomeScreen(),
    );
  }
}

// ─────────────────────────────────────────────
// Product Model
// ─────────────────────────────────────────────
class Product {
  static int _counter = 0;

  final int id;
  final String name;
  final String image;
  final double price;
  final String description;
    final String category;
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    required this.category,
    this.quantity = 1,

  }) : id = _counter++;
}

// ─────────────────────────────────────────────
// Sample Products
// ─────────────────────────────────────────────
List<Product> Products = [
  Product(
    
    name: 'Smartphone',
    image: 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?auto=format&fit=crop&w=500&q=60',
    price: 699.99,
    description: 'High-quality smartphone with amazing features.',
    category: 'Phones',
  ),
  Product(
    
    name: 'Headphones',
    image: 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?auto=format&fit=crop&w=500&q=60',
    price: 199.99,
    description: 'Noise-cancelling over-ear headphones.',
    category: 'Audio',
  ),
  Product(
    
    name: 'Shoes',
    image: 'https://images.unsplash.com/photo-1600185365483-26d7a4cc7519?auto=format&fit=crop&w=500&q=60',
    price: 129.99,
    description: 'Comfortable and stylish shoes.',
    category: 'Fashion',
  ),
  Product(
    name: 'Coffee Mug',
    image: 'https://images.unsplash.com/photo-1509042239860-f550ce710b93?w=500',
    price: 19.99,
    description: 'Ceramic mug for your daily coffee.',
    category: 'Home',
  ),
  Product(
    
    name: 'Desk Lamp',
    image: 'https://images.unsplash.com/photo-1507473885765-e6ed057f782c?w=500',
    price: 39.99,
    description: 'LED desk lamp with adjustable brightness.',
    category: 'Home',
  ),
  Product(
    
    name: 'Tablet',
    image: 'https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=500',
    price: 399.99,
    description: 'Portable tablet for work and entertainment.',
    category: 'Tablets',
  ),
  Product(
    
    name: 'Monitor',
    image: 'https://images.unsplash.com/photo-1527443224154-c4a3942d3acf?w=500',
    price: 299.99,
    description: 'Full HD monitor for productivity.',
    category: 'Electronics',
  ),
  Product(
   
    name: 'Gaming Mouse',
    image: 'https://images.unsplash.com/photo-1587202372775-e229f172b9d7?w=500',
    price: 59.99,
    description: 'Precision gaming mouse with RGB.',
    category: 'Accessories',
  ),
  Product(
   
    name: 'Laptop',
    image: 'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=500&q=60',
    price: 999.99,
    description: 'Powerful laptop for work and gaming.',
    category: 'Laptops',
  ),
  Product(
    
    name: 'Power Bank',
    image: 'https://images.unsplash.com/photo-1580910051074-3eb694886505?w=500',
    price: 49.99,
    description: 'Fast charging portable power bank.',
    category: 'Accessories',
  ),
  Product(
    
    name: 'Wireless Earbuds',
    image: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500',
    price: 129.99,
    description: 'Compact earbuds with great sound.',
    category: 'Audio',
  ),
  Product(
    
    name: 'Refrigerator',
    image: 'https://images.unsplash.com/photo-1581578731548-c64695cc6952?w=500',
    price: 899.99,
    description: 'Energy efficient double door fridge.',
    category: 'Appliances',
  ),
  Product(
    
    name: 'Washing Machine',
    image: 'https://images.unsplash.com/photo-1626806787461-102c1bfaaea1?w=500',
    price: 699.99,
    description: 'Fully automatic washing machine.',
    category: 'Appliances',
  ),
  Product(
    
    name: 'Electric Kettle',
    image: 'https://images.unsplash.com/photo-1571607388263-1044f9ea01dd?w=500',
    price: 39.99,
    description: 'Quick boiling electric kettle.',
    category: 'Appliances',
  ),
  Product(
    
    name: 'Keyboard',
    image: 'https://images.unsplash.com/photo-1518770660439-4636190af475?auto=format&fit=crop&w=500&q=60',
    price: 79.99,
    description: 'Mechanical keyboard with RGB lights.',
    category: 'Accessories',
  ),
  Product(
    
    name: 'Sunglasses',
    image: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083?auto=format&fit=crop&w=500&q=60',
    price: 39.99,
    description: 'Stylish UV-protected sunglasses.',
    category: 'Fashion',
  ),
  Product(
    
    name: 'Water Bottle',
    image: 'https://images.unsplash.com/photo-1526401485004-46910ecc8e51?auto=format&fit=crop&w=500&q=60',
    price: 19.99,
    description: 'Reusable eco-friendly water bottle.',
    category: 'Home',
  ),
];
List<String> categories = [
  "All",
  "Phones",
  "Laptops",
  "Audio",
  "Accessories",
  "Appliances",
  "Fashion",
  "Home",
];

// ─────────────────────────────────────────────
// HomeScreen
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ── Data ──────────────────────────────────
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];
  List<Product> cartItems = [];
   List<Product> wishlistItems = [];
  int _selectedIndex = 0;

  // ── Derived cart count ────────────────────
  int get cartCount => cartItems.fold(0, (sum, p) => sum + p.quantity);

  // ── Category ──────────────────────────────
  final List<String> categories = ['All', 'Phones', 'Audio', 'Laptops', 'Wearables'];
  int _selectedCategory = 0;

  // ── Search ────────────────────────────────
  final TextEditingController _searchController = TextEditingController();

  // ── Colors ────────────────────────────────
  static const Color _primary  = Color(0xFF1B5E20);
  static const Color _accent   = Color(0xFFF9A825);
  static const Color _surface  = Color(0xFFF5F5F5);
  static const Color _textDark = Color(0xFF1A1A1A);

  @override
  void initState() {
    super.initState();
   
    allProducts      = Products;
   // filteredProducts = allProducts;
      filteredProducts = List.from(allProducts); // ✅ important
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // ── Search ────────────────────────────────
  void _searchProduct(String query) {
    setState(() {
      filteredProducts = query.isEmpty
          ? allProducts
          : allProducts
              .where((p) => p.name.toLowerCase().startsWith(query.toLowerCase()))
              .toList();
    });
  }

  // ── Navigation ────────────────────────────
  void _onItemTapped(int index) => setState(() => _selectedIndex = index);

  // ── Add to Cart ───────────────────────────
 void _addToCart(Product product) {
  setState(() {
    final index = cartItems.indexWhere((p) => p.id == product.id);

    if (index != -1) {
      // Product already exists → increase quantity
      cartItems[index].quantity++;
    } else {
      // New product → add to cart with quantity = 1
      cartItems.add(
        Product(
        
          name: product.name,
          image: product.image,
          price: product.price,
          description: product.description,
          category: product.category,
          quantity: 1,
        ),
      );
    }
  });
}
 // ── ✅ NEW: Toggle Wishlist ─────────────────
  void _toggleWishlist(Product product) {
    setState(() {
      final index = wishlistItems.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        wishlistItems.removeAt(index);
      } else {
        wishlistItems.add(product);
      }
    });
  }

  bool _isWishlisted(Product product) {
    return wishlistItems.any((p) => p.id == product.id);
  }


  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _surface,
      extendBodyBehindAppBar: false,
      appBar: _selectedIndex == 0 ? _buildAppBar() : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: IndexedStack(
          key: ValueKey(_selectedIndex),
          index: _selectedIndex,
          children: [
            _buildHomeBody(),
            CartScreen(cartItems: cartItems),  // ✅ fixed: pass cartItems
            ProfileScreen( wishlistItems: wishlistItems,
  toggleWishlist: _toggleWishlist,
  addToCart: _addToCart,),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ── AppBar ────────────────────────────────
  PreferredSizeWidget _buildAppBar() {
    return PreferredSize(
      preferredSize: const Size.fromHeight(130),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF43A047)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  children: [
                    // Logo
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: const [
                          BoxShadow(color: Color(0x33000000), blurRadius: 6),
                        ],
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/logo.jpg',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 95),
                    const Text(
                      'Zepto',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        fontStyle: FontStyle.italic,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const Spacer(),
                    // Cart icon
                    GestureDetector(
                      onTap: () => _onItemTapped(1), // ✅ fixed: was goToCart
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15), // ✅ fixed: withOpacity → withValues
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          if (cartCount > 0)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: const BoxDecoration(
                                  color: _accent,
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  cartCount.toString(),
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Color(0xFF5D3B00),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Sign-in button
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => LoginPage()),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          'Sign in',
                          style: TextStyle(
                            color: _primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // Search bar
                Container(
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x1A000000),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _searchProduct, // ✅ fixed: was searchProduct
                    style: const TextStyle(fontSize: 14, color: _textDark),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Colors.grey, size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                _searchProduct(''); // ✅ fixed: was searchProduct
                                setState(() {});
                              },
                              child: const Icon(Icons.close, color: Colors.grey, size: 18),
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Home Body ─────────────────────────────
  // ✅ fixed: renamed from _HomeBody() (methods must be camelCase)
  Widget _buildHomeBody() {
    return CustomScrollView(
      slivers: [
        // Category chips
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
            child: SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
            
                itemCount: categories.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  
                  final selected = i == _selectedCategory;
                  return GestureDetector(
                    onTap: () {
  setState(() {
    _selectedCategory = i;

    if (categories[i] == "All") {
      filteredProducts = List.from(allProducts);
    } else {
      filteredProducts = allProducts
          .where((p) => p.category == categories[i])
          .toList();
    }
  });
},
                   // onTap: () => setState(() => _selectedCategory = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
                      decoration: BoxDecoration(
                        color: selected ? _primary : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? _primary : Colors.grey.shade300,
                        ),
                        boxShadow: selected
                            ? [
                                BoxShadow(
                                  color: _primary.withValues(alpha: 0.3), // ✅ fixed
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ]
                            : [],
                      ),
                      child: Text(
                        categories[i],
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.grey[700],
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),

        // Section label
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Featured Products',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: _textDark,
                  ),
                ),
                Text(
                  '${filteredProducts.length} items',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
        ),

        // Product Grid
        filteredProducts.isEmpty
            ? SliverFillRemaining(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 60, color: Colors.grey[300]),
                      const SizedBox(height: 12),
                      Text(
                        'No products found',
                        style: TextStyle(color: Colors.grey[400], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    childAspectRatio: 0.72,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _DarkProductCard( // for whishitlist
                     product: filteredProducts[index],
                      isWishlisted:
                          _isWishlisted(filteredProducts[index]),
                      onAddToCart: () =>
                         _addToCart(filteredProducts[index]),
                      onToggleWishlist: () =>
                       
                          _toggleWishlist(filteredProducts[index]),
                      
                     // product: filteredProducts[index],
                     // onAddToCart: () => _addToCart(filteredProducts[index]), // ✅ fixed: was addToCart
                      onTap: () {                                              // ✅ fixed: added missing onTap
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailScreen(
                                product: filteredProducts[index],
                              onAddToCart: (p) {
                                _addToCart(p);
                                // ✅ Navigate to Cart tab after adding
                                setState(() => _selectedIndex = 1);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    childCount: filteredProducts.length,
                  ),
                ),
              ),
      ],
    );
  }

  // ── Bottom Nav ────────────────────────────
  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: _primary,
        selectedItemColor: _accent,
        unselectedItemColor: Colors.white60,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        showUnselectedLabels: true,
        elevation: 0,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.shopping_bag_outlined),
                if (cartCount > 0)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: const BoxDecoration(
                        color: _accent,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        cartCount.toString(),
                        style: const TextStyle(
                          fontSize: 9,
                          color: Color(0xFF5D3B00),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            activeIcon: const Icon(Icons.shopping_bag_rounded),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// _DarkProductCard
// ─────────────────────────────────────────────
class _DarkProductCard extends StatefulWidget {
  final Product product;
  final bool isWishlisted;
  final VoidCallback onAddToCart;
  final VoidCallback onToggleWishlist;
  final VoidCallback onTap;

  const _DarkProductCard({
    required this.product,
    required this.isWishlisted,
    required this.onAddToCart,
    required this.onToggleWishlist,
    required this.onTap,
  });

  @override
  State<_DarkProductCard> createState() => _DarkProductCardState();
}

class _DarkProductCardState extends State<_DarkProductCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _scaleController;
  bool _added = false;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.95,
      upperBound: 1.0,
      value: 1.0,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    await _scaleController.reverse();
    await _scaleController.forward();
    setState(() => _added = true);
    widget.onAddToCart();
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => _added = false);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleController,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with heart icon
            GestureDetector(
              onTap: widget.onTap,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(18),
                    ),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: const Color(0xFFF8F8F8),
                      child: Image.network(
                        widget.product.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            color: Colors.grey,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Price badge
                  Positioned(
                    bottom: 10,
                    right: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF9A825),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '\$${widget.product.price.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF5D3B00),
                        ),
                      ),
                    ),
                  ),
                  // ✅ NEW: Heart / Wishlist icon
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: widget.onToggleWishlist,
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 250),
                        transitionBuilder: (child, anim) =>
                            ScaleTransition(scale: anim, child: child),
                        child: Container(
                          key: ValueKey(widget.isWishlisted),
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            widget.isWishlisted
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 18,
                            color: widget.isWishlisted
                                ? Colors.redAccent
                                : Colors.grey[400],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        ...List.generate(
                          5,
                          (i) => Icon(
                            i < 4 ? Icons.star : Icons.star_border,
                            color: const Color(0xFFF9A825),
                            size: 13,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(42)',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton(
                        onPressed: _handleTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _added
                              ? const Color(0xFF2E7D32)
                              : const Color(0xFFF9A825),
                          foregroundColor: _added
                              ? Colors.white
                              : const Color(0xFF5D3B00),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              _added
                                  ? Icons.check_circle_outline
                                  : Icons.add_shopping_cart_outlined,
                              size: 15,
                            ),
                            const SizedBox(width: 5),
                            Text(
                              _added ? 'Added!' : 'Add to Cart',
                              style: const TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// ─────────────────────────────────────────────
// ProductDetailScreen  ✅ only ONE definition
// ProductDetailScreen  ✅ with Add to Cart → Cart navigation
// ─────────────────────────────────────────────
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final void Function(Product) onAddToCart; // ✅ callback

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.onAddToCart,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _scaleController;
bool _added = false;
  

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();
  }

  


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return WillPopScope(
  onWillPop: () async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
      (route) => false,
    );
    return false;
  },

    child:  Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
         onTap: () {
  Navigator.pushAndRemoveUntil(
    context,
    MaterialPageRoute(builder: (_) => HomeScreen()),
    (route) => false,
  );
},
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                color: Colors.white, size: 16),
          ),
        ),
        centerTitle: true,
        title: Text(
          product.name.toUpperCase(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 2.5,
          ),
        ),
        
      ),
      body: Column(
        children: [
          // Hero Image
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImage(imageUrl: product.image),
              ),
            ),
            child: Hero(
              tag: product.image,
              child: Stack(
                children: [
                  SizedBox(
                    height: 380,
                    width: double.infinity,
                    child:
                        Image.network(product.image, fit: BoxFit.cover),
                  ),
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            const Color(0xFF0F0F0F)
                                .withValues(alpha: 0.85),
                          ],
                          stops: const [0.45, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 14,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white24),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.zoom_out_map,
                              color: Colors.white70, size: 12),
                          SizedBox(width: 5),
                          Text('View full',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 11)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Scrollable Details
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  decoration:
                      const BoxDecoration(color: Color(0xFF0F0F0F)),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                product.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.w700,
                                  height: 1.2,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFD4AF37)
                                      .withValues(alpha: 0.5),
                                ),
                              ),
                              child: Text(
                                '\$${product.price}',
                                style: const TextStyle(
                                  color: Color(0xFFD4AF37),
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          height: 1,
                          margin:
                              const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [
                              Colors.white.withValues(alpha: 0.15),
                              Colors.transparent,
                            ]),
                          ),
                        ),
                        const Text(
                          'DESCRIPTION',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 2.5,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.description,
                          style: const TextStyle(
                            color: Color(0xFFB0B0B0),
                            fontSize: 15,
                            height: 1.7,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

// ✅ Sticky Bottom Button → Add to Cart + Go Home
Container(
  padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
  decoration: BoxDecoration(
    color: const Color(0xFF0F0F0F),
    border: Border(
      top: BorderSide(
        color: Colors.white.withOpacity(0.08),
        width: 1,
      ),
    ),
  ),

  child: InkWell(
    borderRadius: BorderRadius.circular(16),

    onTap: () {
      // ✅ Add to cart
      widget.onAddToCart(product);

      // ✅ Show message (no button)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: const Color(0xFF1F1F1F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          duration: const Duration(milliseconds: 800), // 👈 short & visible

          content: Row(
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.green, size: 22),
              const SizedBox(width: 10),

              Expanded(
                child: Text(
                  "${product.name} added to cart",
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      // ✅ Wait → then go to Home (important!)
      Future.delayed(const Duration(milliseconds: 800), () {
        Navigator.popUntil(context, (route) => route.isFirst);
      });
    },

    child: Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD4AF37), Color(0xFFF0C040)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),

      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_bag_outlined,
              color: Color(0xFF0F0F0F), size: 20),
          SizedBox(width: 10),
          Text(
            'Add to Cart',
            style: TextStyle(
              color: Color(0xFF0F0F0F),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
            ),
          ),
        ],
      ),
    ),
  ),
),
        ],
      ),
    ),
    );
    
  }
  
}
// ─────────────────────────────────────────────
// CartScreen
// ─────────────────────────────────────────────
class CartScreen extends StatefulWidget {
  final List<Product> cartItems;
   

  const CartScreen({super.key, required this.cartItems, });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  //late List<Product> cartItems;

  bool isPlacingOrder = false;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  
late List<Product> cartItems;
late List<Product> filteredProducts;
 
@override
void initState() {
  super.initState();
  cartItems = widget.cartItems;  // ✅ SAME reference (no copy)

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  double getTotalPrice() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  double getSavings() {
    return getTotalPrice() * 0.05;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: _buildAppBar(),
      body: cartItems.isEmpty
          ? _buildEmptyCart()
          : FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                      itemCount: cartItems.length,
                      itemBuilder: (context, index) {
                        return _buildCartItem(cartItems[index], index);
                      },
                    ),
                  ),
                  _buildBottomBar(context),
                ],
              ),
            ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Cart',
            style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
          if (cartItems.isNotEmpty)
            Text(
              '${cartItems.length} ${cartItems.length == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                color: Colors.green,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      actions: [
        if (cartItems.isNotEmpty)
          TextButton.icon(
            onPressed: () => _confirmClearCart(),
            icon: Icon(Icons.delete_sweep_outlined, color: Colors.red[400], size: 18),
            label: Text(
              'Clear',
              style: TextStyle(
                  color: Colors.red[400], fontWeight: FontWeight.w600),
            ),
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildCartItem(Product product, int index) {
    return Dismissible(
      key: Key(product.name + index.toString()),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.delete_outline, color: Colors.red, size: 28),
            const SizedBox(height: 4),
            const Text('Remove',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      confirmDismiss: (_) async {
        return await _showRemoveConfirm(product.name);
      },
      onDismissed: (_) {
        setState(() => cartItems.removeAt(index));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${product.name} removed from cart'),
            backgroundColor: const Color(0xFF1A1A2E),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(
              label: 'Undo',
              textColor: Colors.green,
              onPressed: () {
                setState(() => cartItems.insert(index, product));
              },
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06), // ✅ fixed
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProductDetailScreen( product: Products[index],
                              onAddToCart: (p) {
                              
                                Navigator.pop(context);
                              },
                )
              ),
            ),
          
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Hero(
                  tag: 'cart_${product.name}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(Icons.image_not_supported,
                            color: Colors.grey[400]),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: Color(0xFF1A1A2E),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Text(
                            '₹${product.price}',
                            style: TextStyle(
                              color: Colors.green[700],
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'each',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFFF6F7FB),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              children: [
                               GestureDetector(
  onTap: () {
    setState(() {
      if (product.quantity > 1) {
        product.quantity--;
      } else {
        cartItems.remove(product); // 🔥 remove item completely
      }
    });
  },
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: product.quantity > 1
                                          ? Colors.green
                                          : Colors.grey[300],
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.remove,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  child: Text(
                                    '${product.quantity}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 15,
                                      color: Color(0xFF1A1A2E),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () =>
                                      setState(() => product.quantity++),
                                  child: Container(
                                    width: 30,
                                    height: 30,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(Icons.add,
                                        color: Colors.white, size: 14),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Subtotal',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '₹${(product.price * product.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 15,
                                  color: Color(0xFF1A1A2E),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08), // ✅ fixed
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _priceRow('Items (${cartItems.length})',
              '₹${getTotalPrice().toStringAsFixed(2)}', false),
          const SizedBox(height: 8),
          _priceRow('Delivery charge', 'FREE', false,
              valueColor: Colors.green),
          const SizedBox(height: 8),
          _priceRow(
            'You save',
            '₹${getSavings().toStringAsFixed(2)}',
            false,
            valueColor: Colors.orange[700]!,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              children: List.generate(
                30,
                (i) => Expanded(
                  child: Container(
                    height: 1,
                    color: i.isEven ? Colors.grey[300] : Colors.transparent,
                  ),
                ),
              ),
            ),
          ),
          _priceRow(
            'Total Amount',
            '₹${getTotalPrice().toStringAsFixed(2)}',
            true,
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: isPlacingOrder ? null : () => _handlePlaceOrder(context),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: double.infinity,
              height: 56,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isPlacingOrder
                      ? [Colors.grey[400]!, Colors.grey[400]!]
                      : [const Color(0xFF2E7D32), const Color(0xFF43A047)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: isPlacingOrder
                    ? []
                    : [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.4), // ✅ fixed
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isPlacingOrder)
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2),
                    )
                  else
                    const Icon(Icons.shopping_cart_checkout_rounded,
                        color: Colors.white, size: 20),
                  const SizedBox(width: 10),
                  Text(
                    isPlacingOrder ? 'Please wait...' : 'Proceed to Checkout',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  if (!isPlacingOrder) ...[
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward_rounded,
                        color: Colors.white70, size: 18),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _trustBadge(Icons.verified_user_outlined, 'Secure'),
              const SizedBox(width: 20),
              _trustBadge(Icons.local_shipping_outlined, 'Free Delivery'),
              const SizedBox(width: 20),
              _trustBadge(Icons.replay_outlined, 'Easy Returns'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, bool isBold,
      {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: isBold ? const Color(0xFF1A1A2E) : Colors.grey[600],
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w500,
            fontSize: isBold ? 17 : 14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ??
                (isBold ? Colors.green[700] : const Color(0xFF1A1A2E)),
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            fontSize: isBold ? 20 : 14,
          ),
        ),
      ],
    );
  }

  Widget _trustBadge(IconData icon, String label) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey[400]),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.green[50],
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.shopping_cart_outlined,
                size: 56, color: Colors.green[300]),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Looks like you haven\'t added\nanything to your cart yet',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[500], fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HomeScreen()),
              (route) => false,
            ),
            icon: const Icon(Icons.storefront_outlined, color: Colors.white),
            label: const Text('Browse Products',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w700)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handlePlaceOrder(BuildContext context) async {
    if (isPlacingOrder) return;

    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => LoginPage()),
      );

      if (result != true) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.lock_outline, color: Colors.white, size: 18),
                const SizedBox(width: 10),
                const Text('Please login to place an order'),
              ],
            ),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            action: SnackBarAction(
              label: 'Login',
              textColor: Colors.white,
              onPressed: () async {
                final retry = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LoginPage()),
                );
                if (retry == true && mounted) _handlePlaceOrder(context);
              },
            ),
          ),
        );
        return;
      }
    }

    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentScreen(
          cartItems: cartItems
              .map((product) => {
                    'name': product.name,
                    'price': product.price,
                    'quantity': product.quantity,
                    'total': product.price * product.quantity,
                  })
              .toList(),
          totalAmount: getTotalPrice(),
          onOrderPlaced: ()  {
            setState(() {
    cartItems.clear();   // ✅ clears globally
  });
           //setState(() => cartItems.clear());
          
        
          },
        ),
      ),
    );
  }

//this function for remove cart and clear cart
Future<void> clearCartData() async {
  // Clear local list
  cartItems.clear();

  // Clear saved data (VERY IMPORTANT)
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('cart');

  // Refresh UI
  if (mounted) {
    setState(() {});
  }
}
  Future<bool> _showRemoveConfirm(String name) async {
    return await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20)),
            title: const Text('Remove Item?',
                style: TextStyle(fontWeight: FontWeight.w700)),
            content: Text('Remove "$name" from your cart?',
                style: TextStyle(color: Colors.grey[600])),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel',
                    style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Remove',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ) ??
        false;
  }

  void _confirmClearCart() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20)),
        title: const Text('Clear Cart?',
            style: TextStyle(fontWeight: FontWeight.w700)),
        content: Text('All ${cartItems.length} items will be removed.',
            style: TextStyle(color: Colors.grey[600])),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => cartItems.clear());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Clear All',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// FullScreenImage
// ─────────────────────────────────────────────
class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  const FullScreenImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Hero(
          tag: imageUrl,
          child: InteractiveViewer(
            child: Image.network(imageUrl),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// OrdersScreen
// ─────────────────────────────────────────────
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {

  Future<void> deleteOrder(String orderId) async {
    try {
      String userId = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseDatabase.instance
          .ref("orders")
          .child(userId)
          .child(orderId)
          .remove();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('🗑️ Order deleted successfully'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('❌ Failed to delete order'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _confirmDelete(String orderId) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Order?'),
        content: const Text('This order will be permanently removed.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await deleteOrder(orderId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("My Orders"),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.lock_outline, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                "🔐 Please login to view your orders",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    final DatabaseReference ordersRef =
        FirebaseDatabase.instance.ref("orders").child(user.uid);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        title: const Text(
          "My Orders",
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: StreamBuilder<DatabaseEvent>(
          stream: ordersRef.onValue,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.deepPurple),
              );
            }

            if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.shopping_bag_outlined,
                        size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      "No Orders Found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            final Map data = snapshot.data!.snapshot.value as Map;
            List orders = [];
            data.forEach((key, value) {
              orders.add(
                  {"orderId": key, ...Map<String, dynamic>.from(value)});
            });

            orders.sort((a, b) =>
                (b['timestamp'] ?? '').compareTo(a['timestamp'] ?? ''));

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 12),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                return _buildOrderCard(orders[index]);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map order) {
    final String orderId = order['orderId'] ?? '';
    final String status = order['status'] ?? 'placed';
    final dynamic total = order['total'] ?? 0;
    final String timestamp = order['timestamp'] ?? '';
    final List items =
        order['items'] != null ? List.from(order['items']) : [];
    final Map? address = order['address'] != null
        ? Map<String, dynamic>.from(order['address'])
        : null;
    final String paymentMethod =
        order['paymentMethod'] ?? 'Cash on Delivery';
    final bool isPlaced = status == "placed";

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06), // ✅ fixed
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Order #${orderId.substring(0, 6)}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => _confirmDelete(orderId),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isPlaced
                        ? Colors.orange.withValues(alpha: 0.15) // ✅ fixed
                        : Colors.green.withValues(alpha: 0.15), // ✅ fixed
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPlaced ? Icons.access_time : Icons.check_circle,
                        size: 14,
                        color: isPlaced ? Colors.orange : Colors.green,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        status.toUpperCase(),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: isPlaced ? Colors.orange : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  "₹$total",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 17),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.schedule, size: 14, color: Colors.grey),
                const SizedBox(width: 4),
                Text(timestamp,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
            const Divider(height: 22),
            const Text("Items",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            items.isEmpty
                ? const Text("No items",
                    style: TextStyle(color: Colors.grey))
                : Column(
                    children: items.map<Widget>((item) {
                      final i = Map<String, dynamic>.from(item);
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.deepPurple.shade100,
                              child: const Icon(Icons.shopping_bag,
                                  size: 16, color: Colors.deepPurple),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                i['name'] ?? '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            Text(
                              "₹${i['total']}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
            if (address != null) ...[
              const Divider(height: 22),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16, color: Colors.red),
                  const SizedBox(width: 4),
                  const Text("Delivery Address",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                "${address['name']}, ${address['street']}, "
                "${address['city']}, ${address['state']} - ${address['pincode']}",
                style:
                    TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                "📞 ${address['phone'] ?? ''}",
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.payment, size: 16, color: Colors.deepPurple),
                const SizedBox(width: 6),
                Text(
                  paymentMethod,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}





// whish list screen
class WishlistScreen extends StatelessWidget {
  final List<Product> wishlistItems;
  final void Function(Product) onRemove;
  final void Function(Product) onAddToCart;

  const WishlistScreen({
    super.key,
    required this.wishlistItems,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      appBar: _buildAppBar(),
      body: wishlistItems.isEmpty
          ? _buildEmptyState()
          : _buildWishlistBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'My Wishlist',
            style: TextStyle(
              color: Color(0xFF1A1A2E),
              fontWeight: FontWeight.w800,
              fontSize: 22,
              letterSpacing: -0.5,
            ),
          ),
          if (wishlistItems.isNotEmpty)
            Text(
              '${wishlistItems.length} saved ${wishlistItems.length == 1 ? 'item' : 'items'}',
              style: const TextStyle(
                color: Colors.redAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          height: 1,
          color: Colors.grey.shade100,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.favorite_border,
              size: 60,
              color: Colors.redAccent,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your wishlist is empty',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Tap the ❤ icon on any product\nto save it here',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWishlistBody(BuildContext context) {
    return Column(
      children: [
        // Summary card
        Container(
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: Colors.redAccent.withValues(alpha: 0.25),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Icon(Icons.favorite, color: Colors.white, size: 28),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Saved for Later',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    '${wishlistItems.length} ${wishlistItems.length == 1 ? 'item' : 'items'} • \$${wishlistItems.fold(0.0, (s, p) => s + p.price).toStringAsFixed(2)} total',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            itemCount: wishlistItems.length,
            itemBuilder: (context, index) {
              return _WishlistItemCard(
                product: wishlistItems[index],
                onRemove: () => onRemove(wishlistItems[index]),
                onAddToCart: () => onAddToCart(wishlistItems[index]),
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────
// _WishlistItemCard
// ─────────────────────────────────────────────
class _WishlistItemCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;

  const _WishlistItemCard({
    required this.product,
    required this.onRemove,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key('wish_${product.id}'),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.red, size: 28),
            SizedBox(height: 4),
            Text('Remove',
                style: TextStyle(
                    color: Colors.red,
                    fontSize: 11,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.network(
                product.image,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 110,
                  height: 110,
                  color: Colors.grey.shade100,
                  child: const Icon(Icons.image_not_supported,
                      color: Colors.grey),
                ),
              ),
            ),

            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: Color(0xFF1A1A2E),
                            ),
                          ),
                        ),
                        // Remove (heart) button
                        GestureDetector(
                          onTap: onRemove,
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.red.shade50,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.favorite,
                              size: 16,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1B5E20),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Add to Cart button
                    SizedBox(
                      width: double.infinity,
                      height: 36,
                      child: ElevatedButton.icon(
                        onPressed: onAddToCart,
                        icon: const Icon(
                            Icons.add_shopping_cart_outlined,
                            size: 15),
                        label: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1B5E20),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
