import 'package:ecom/main.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'EditProfilePage.dart';
import 'LoginPage.dart';

import 'package:flutter/cupertino.dart';




// ─────────────────────────────────────────────────────
//  THEME CONSTANTS
// ─────────────────────────────────────────────────────
class AppColors {
  static const primary     = Color(0xFF00C97B);   // Emerald green
  static const primaryDark = Color(0xFF00A562);
  static const bg          = Color(0xFF0F1923);   // Deep navy
  static const surface     = Color(0xFF1A2634);   // Card surface
  static const surface2    = Color(0xFF223044);   // Slightly lighter
  static const border      = Color(0xFF2D3F55);
  static const textPrimary = Color(0xFFEAF2FF);
  static const textSecond  = Color(0xFF7A94B0);
  static const danger      = Color(0xFFFF4D6A);
}

// ─────────────────────────────────────────────────────
//  PROFILE SCREEN
// ─────────────────────────────────────────────────────
class ProfileScreen extends StatefulWidget {
    final List<Product> wishlistItems;
  final Function(Product) toggleWishlist;
  final Function(Product) addToCart;

    const ProfileScreen({
    super.key,
    required this.wishlistItems,
    required this.toggleWishlist,
    required this.addToCart,
  });

   
  
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  String userName = "";
  String email = "";
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;


  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    getUserData();
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  void getUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        email    = user.email ?? "No Email";
        userName = user.displayName ?? "User";
      });
    }
  }

  // ── Header avatar + name + email + edit button ──────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 56, 24, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0D2137), Color(0xFF0F1923)],
        ),
      ),
      child: Column(
        children: [
          // Avatar with glowing ring
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.4),
                  blurRadius: 24,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surface,
              child: Text(
                userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          Text(
            userName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            email,
            style: const TextStyle(
              color: AppColors.textSecond,
              fontSize: 13.5,
              letterSpacing: 0.2,
            ),
          ),

          const SizedBox(height: 20),

          // Edit Profile button
          GestureDetector(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      EditProfilePage(userName: userName, email: email),
                ),
              );
              if (result != null) {
                setState(() {
                  userName = result["userName"];
                  email    = result["email"];
                });
                await FirebaseAuth.instance.currentUser!
                    .updateDisplayName(userName);
              }
            },
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary, width: 1.5),
                borderRadius: BorderRadius.circular(30),
                color: AppColors.primary.withOpacity(0.12),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.edit_outlined,
                      color: AppColors.primary, size: 16),
                  SizedBox(width: 8),
                  Text(
                    "Edit Profile",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Section label ────────────────────────────────────
  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors.textSecond,
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }

  // ── Glass card wrapper ───────────────────────────────
  Widget _buildCard(List<_TileData> tiles) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: List.generate(tiles.length, (i) {
            final tile = tiles[i];
            final isLast = i == tiles.length - 1;
            return Column(
              children: [
                _buildTile(tile),
                if (!isLast)
                  const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.border,
                    indent: 60,
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ── Individual tile ──────────────────────────────────
  Widget _buildTile(_TileData tile) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: tile.onTap,
        splashColor: AppColors.primary.withOpacity(0.08),
        highlightColor: AppColors.primary.withOpacity(0.05),
        child: Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: tile.isLogout
                      ? AppColors.danger.withOpacity(0.12)
                      : AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  tile.icon,
                  size: 20,
                  color: tile.isLogout ? AppColors.danger : AppColors.primary,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  tile.title,
                  style: TextStyle(
                    color:
                        tile.isLogout ? AppColors.danger : AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: tile.isLogout
                    ? AppColors.danger.withOpacity(0.5)
                    : AppColors.textSecond,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),

              _sectionLabel("Shopping"),
              _buildCard([
             _TileData(
  icon: Icons.favorite_border_rounded,
  title: "Wishlist",
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => WishlistScreen(
          wishlistItems: widget.wishlistItems,
          onRemove: widget.toggleWishlist,
          onAddToCart: widget.addToCart,
        ),
      ),
    );
  },
),
                
                _TileData(   //WishlistScreen
                  icon: Icons.location_on_outlined,
                  title: "Saved Addresses",
                  onTap: () => _showSnack("Address clicked"),
                ),
              ]),

              _sectionLabel("Account"),
              _buildCard([
                _TileData(
                  icon: Icons.payment_outlined,
                  title: "Payment Methods",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => PaymentPage())),
                ),
                _TileData(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => SettingsPage())),
                ),
              ]),

              _sectionLabel("Support"),
              _buildCard([
                _TileData(
                  icon: Icons.help_outline_rounded,
                  title: "Help & Support",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => HelpSupportPage())),
                ),
                _TileData(
                  icon: Icons.info_outline_rounded,
                  title: "About App",
                  onTap: () => Navigator.push(context,
                      MaterialPageRoute(builder: (_) => AboutPage())),
                ),
              ]),

              _sectionLabel(""),
              _buildCard([
                _TileData(
                  icon: Icons.logout_rounded,
                  title: "Log Out",
                  isLogout: true,
                  onTap: _showLogoutDialog,
                ),
              ]),

              const SizedBox(height: 40),

              Center(
                child: Text(
                  "Version 1.0.0",
                  style: TextStyle(
                    color: AppColors.textSecond.withOpacity(0.5),
                    fontSize: 12,
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

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: AppColors.surface2,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Log Out",
            style: TextStyle(color: AppColors.textPrimary,
                fontWeight: FontWeight.w700)),
        content: const Text("Are you sure you want to log out?",
            style: TextStyle(color: AppColors.textSecond)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel",
                style: TextStyle(color: AppColors.textSecond)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => HomeScreen()),
                (route) => false,
              );
            },
            child: const Text("Log Out",
                style: TextStyle(color: Colors.white,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  HELPER DATA CLASS
// ─────────────────────────────────────────────────────
class _TileData {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool isLogout;

  _TileData({
    required this.icon,
    required this.title,
    required this.onTap,
    this.isLogout = false,
  });
}

// ─────────────────────────────────────────────────────
//  HELP & SUPPORT PAGE
// ─────────────────────────────────────────────────────
class HelpSupportPage extends StatelessWidget {
  const HelpSupportPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(context, "Help & Support"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00C97B), Color(0xFF009E60)],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.support_agent_rounded,
                      size: 52, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    "How can we help you?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "We're here for you 24 / 7",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            _sectionTitle("Frequently Asked Questions"),
            const SizedBox(height: 12),

            _faqItem("How to place an order?",
                "Browse products, add to cart, and click 'Place Order' to complete your purchase."),
            _faqItem("How to cancel an order?",
                "Cancellation is not available yet. It will be added in future updates."),
            _faqItem("Is online payment available?",
                "Not yet. Future versions will include UPI and card payments."),

            const SizedBox(height: 28),
            _sectionTitle("Contact Us"),
            const SizedBox(height: 12),

            _contactCard(Icons.email_outlined, "Email",
                "support@ecommerce.com"),
            const SizedBox(height: 10),
            _contactCard(Icons.phone_outlined, "Phone", "+91 9876543210"),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text("Support request sent!"),
                      backgroundColor: AppColors.primary,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                icon: const Icon(Icons.send_rounded, size: 18),
                label: const Text("Contact Support",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _faqItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Theme(
        data: ThemeData(
          dividerColor: Colors.transparent,
          splashColor: AppColors.primary.withOpacity(0.05),
        ),
        child: ExpansionTile(
          iconColor: AppColors.primary,
          collapsedIconColor: AppColors.textSecond,
          title: Text(question,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(answer,
                  style: const TextStyle(
                      color: AppColors.textSecond, fontSize: 13.5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactCard(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      color: AppColors.textSecond, fontSize: 11,
                      letterSpacing: 0.8)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  ABOUT PAGE
// ─────────────────────────────────────────────────────
class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(context, "About App"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // App icon
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(Icons.shopping_cart_rounded,
                  size: 44, color: Colors.white),
            ),
            const SizedBox(height: 16),
            const Text("E-Commerce App",
                style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text("Version 1.0.0",
                style: TextStyle(color: AppColors.textSecond, fontSize: 13)),
            const SizedBox(height: 30),

            _infoCard(
              title: "About This App",
              body:
                  "A modern e-commerce app built with Flutter & Firebase. "
                  "Browse products, search items, add to cart, and place orders with a smooth, beautiful experience.",
            ),
            const SizedBox(height: 16),

            _featureCard("Key Features", [
              "User Authentication (Login / Signup)",
              "Product Listing & Search",
              "Add to Cart & Checkout",
              "Order Placement",
              "Clean & Responsive UI",
            ]),
            const SizedBox(height: 16),

            _featureCard("Coming Soon", [
              "Online Payment Integration",
              "Order History",
              "Push Notifications",
              "Admin Panel",
            ], accent: const Color(0xFF6E82F8)),

            const SizedBox(height: 30),
            Text(
              "Made with ❤️ using Flutter",
              style: TextStyle(
                  color: AppColors.textSecond.withOpacity(0.6),
                  fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({required String title, required String body}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(body,
              style: const TextStyle(
                  color: AppColors.textSecond,
                  fontSize: 14,
                  height: 1.6)),
        ],
      ),
    );
  }

  Widget _featureCard(String title, List<String> items,
      {Color accent = AppColors.primary}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          ...items.map((e) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded,
                        color: accent, size: 17),
                    const SizedBox(width: 10),
                    Expanded(
                        child: Text(e,
                            style: const TextStyle(
                                color: AppColors.textSecond,
                                fontSize: 13.5))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  SETTINGS PAGE
// ─────────────────────────────────────────────────────


// ─────────────────────────────────────────────────────
// APP COLORS
// ─────────────────────────────────────────────────────
class AppColors1 {
  // Backgrounds
  static const Color bg       = Color(0xFF0F0F13);
  static const Color surface  = Color(0xFF1A1A22);
  static const Color surface2 = Color(0xFF22222E);
  static const Color surface3 = Color(0xFF2A2A38);

  // Borders
  static const Color border   = Color(0xFF2E2E3E);

  // Accent
  static const Color primary  = Color(0xFF6C63FF);
  static const Color danger   = Color(0xFFFF5C6B);
  static const Color green    = Color(0xFF34D399);
  static const Color amber    = Color(0xFFFBBF24);

  // Text
  static const Color textPrimary = Color(0xFFF0EFF8);
  static const Color textSecond  = Color(0xFF8E8DA8);
  static const Color textThird   = Color(0xFF5A5976);
}

// ─────────────────────────────────────────────────────
// MAIN — wire up with your own MaterialApp
// ─────────────────────────────────────────────────────
void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SettingsPage(),
  ));
}

// ─────────────────────────────────────────────────────
// SETTINGS PAGE
// ─────────────────────────────────────────────────────
class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // Toggle states
  bool isDarkMode           = true;
  bool notificationsEnabled = true;
  bool locationEnabled      = false;
  bool twoFactorEnabled     = true;

  // Slider state (1–5 → XS / S / M / L / XL)
  double textSizeValue = 3;

  static const List<String> _textSizeLabels = ['XS', 'S', 'M', 'L', 'XL'];
  String get _textSizeLabel =>
      _textSizeLabels[(textSizeValue.round() - 1).clamp(0, 4)];

  // Storage (demo values)
  static const double _storageUsed  = 6.2;
  static const double _storageTotal = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.only(bottom: 36),
                children: [
                //  _buildProfileHero(),
                  _sectionLabel('Account'),
                  _buildAccountCard(),
                  _sectionLabel('Preferences'),
                  _buildPreferencesCard(),
                  _sectionLabel('Storage & Data'),
                  _buildStorageCard(),
                  _sectionLabel('App'),
                  _buildAppCard(),
                  const SizedBox(height: 24),
                  _buildDangerCard(),
                  _buildFooter(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── AppBar ───────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 4),
      child: Row(
        children: [
          _circleBtn(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.maybePop(context),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                'Settings',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                'Manage your account & preferences',
                style: TextStyle(
                  color: AppColors.textSecond,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Profile Hero ─────────────────────────────────

  /*
  Widget _buildProfileHero() {
    return GestureDetector(
      onTap: () => _showSnack('Edit profile tapped'),
      child: Container(
        margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Avatar with online badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF9D6FFF)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    'AK',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Positioned(
                  bottom: -3,
                  right: -3,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: AppColors1.green,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 2.5),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 14),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Arjun Kumar',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'arjun.kumar@gmail.com',
                    style: TextStyle(color: AppColors.textSecond, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'PRO PLAN',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors1.textThird, size: 22),
          ],
        ),
      ),
    );
  }
*/
  // ─── Account Card ─────────────────────────────────
  Widget _buildAccountCard() {
    return _card([
      _tile(
        icon: Icons.person_outline_rounded,
        iconColor: AppColors.primary,
        title: 'Edit Profile',
        subtitle: 'Name, photo, bio',
        onTap: () => _showSnack('Edit Profile tapped'),
      ),
      _tile(
        icon: Icons.lock_outline_rounded,
        iconColor: AppColors.primary,
        title: 'Change Password',
        subtitle: 'Last changed 3 months ago',
        onTap: () => _showSnack('Change Password tapped'),
      ),
      _tile(
        icon: Icons.verified_user_outlined,
        iconColor: AppColors.primary,
        title: 'Two-Factor Auth',
        subtitle: 'Extra layer of security',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusBadge(twoFactorEnabled ? 'ON' : 'OFF',
                twoFactorEnabled ? AppColors1.green : AppColors.textSecond),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors1.textThird, size: 20),
          ],
        ),
        onTap: () => _showSnack('Two-Factor Auth tapped'),
      ),
      _tile(
        icon: Icons.credit_card_rounded,
        iconColor: AppColors.primary,
        title: 'Subscription',
        subtitle: 'Pro · Renews Jul 2025',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _outlineBadge('Manage', AppColors.primary),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors1.textThird, size: 20),
          ],
        ),
        onTap: () => _showSnack('Subscription tapped'),
      ),
    ]);
  }

  // ─── Preferences Card ─────────────────────────────
  Widget _buildPreferencesCard() {
    return _card([
      _switchTile(
        icon: Icons.dark_mode_outlined,
        iconColor: AppColors.primary,
        title: 'Dark Mode',
        subtitle: isDarkMode ? 'Dark mode on' : 'Light mode on',
        value: isDarkMode,
        onChanged: (v) => setState(() => isDarkMode = v),
      ),
      _switchTile(
        icon: Icons.notifications_outlined,
        iconColor: AppColors.primary,
        title: 'Notifications',
        subtitle:
            notificationsEnabled ? 'All alerts enabled' : 'Notifications off',
        value: notificationsEnabled,
        onChanged: (v) => setState(() => notificationsEnabled = v),
      ),
      // Text size slider
      _sliderTile(),
      _switchTile(
        icon: Icons.location_on_outlined,
        iconColor: AppColors1.green,
        title: 'Location Services',
        subtitle: 'While using the app',
        value: locationEnabled,
        onChanged: (v) => setState(() => locationEnabled = v),
      ),
    ]);
  }

  Widget _sliderTile() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              _iconWrap(Icons.text_fields_rounded, AppColors.primary),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Text Size',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Container(
                width: 36,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _textSizeLabel,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(64, 0, 18, 12),
          child: Row(
            children: [
              const Text('A',
                  style: TextStyle(
                      color: AppColors1.textThird,
                      fontSize: 11,
                      fontWeight: FontWeight.w600)),
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    trackHeight: 3,
                    activeTrackColor: AppColors.primary,
                    inactiveTrackColor: AppColors1.surface3,
                    thumbColor: AppColors.primary,
                    thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 7),
                    overlayColor: AppColors.primary.withOpacity(0.15),
                  ),
                  child: Slider(
                    min: 1,
                    max: 5,
                    divisions: 4,
                    value: textSizeValue,
                    onChanged: (v) => setState(() => textSizeValue = v),
                  ),
                ),
              ),
              const Text('A',
                  style: TextStyle(
                      color: AppColors1.textThird,
                      fontSize: 16,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    );
  }

  // ─── Storage Card ─────────────────────────────────
  Widget _buildStorageCard() {
    final double fraction = _storageUsed / _storageTotal;
    return _card([
      Padding(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 0),
        child: Row(
          children: [
            _iconWrap(Icons.storage_rounded, AppColors1.amber),
            const SizedBox(width: 14),
            const Expanded(
              child: Text(
                'Storage',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 14.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '${_storageUsed.toStringAsFixed(1)} / ${_storageTotal.toStringAsFixed(0)} GB',
              style: const TextStyle(
                color: AppColors1.amber,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      // Storage bar
      Padding(
        padding: const EdgeInsets.fromLTRB(64, 10, 18, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: fraction,
                minHeight: 5,
                backgroundColor: AppColors1.surface3,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors1.amber),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${_storageUsed.toStringAsFixed(1)} GB used · ${(_storageTotal - _storageUsed).toStringAsFixed(1)} GB free',
              style: const TextStyle(
                  color: AppColors.textSecond, fontSize: 11),
            ),
          ],
        ),
      ),
      _tile(
        icon: Icons.cleaning_services_outlined,
        iconColor: AppColors1.amber,
        title: 'Clear Cache',
        subtitle: 'Free up 1.3 GB',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _outlineBadge('Clear', AppColors1.amber),
          ],
        ),
        onTap: () => _showSnack('Cache cleared!'),
      ),
      _tile(
        icon: Icons.data_usage_rounded,
        iconColor: AppColors1.amber,
        title: 'Data Usage',
        subtitle: 'Wi-Fi only · Saver mode off',
        onTap: () => _showSnack('Data Usage tapped'),
      ),
    ]);
  }

  // ─── App Card ─────────────────────────────────────
  Widget _buildAppCard() {
    return _card([
      _tile(
        icon: Icons.palette_outlined,
        iconColor: AppColors1.primary,
        title: 'Appearance',
        subtitle: 'Theme, accent color',
        onTap: () => _showSnack('Appearance tapped'),
      ),
      _tile(
        icon: Icons.language_rounded,
        iconColor: AppColors.primary,
        title: 'Language',
        subtitle: 'App display language',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text('English',
                style: TextStyle(
                    color: AppColors.textSecond,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w500)),
            SizedBox(width: 6),
            Icon(Icons.chevron_right_rounded,
                color: AppColors1.textThird, size: 20),
          ],
        ),
        onTap: () => _showSnack('Language tapped'),
      ),
      _tile(
        icon: Icons.shield_outlined,
        iconColor: AppColors.primary,
        title: 'Privacy',
        subtitle: 'Data, permissions',
        onTap: () => _showSnack('Privacy tapped'),
      ),
      _tile(
        icon: Icons.info_outline_rounded,
        iconColor: AppColors.primary,
        title: 'About App',
        subtitle: 'Version 2.4.1 · Build 108',
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _statusBadge('Latest', AppColors1.green),
            const SizedBox(width: 6),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors1.textThird, size: 20),
          ],
        ),
        onTap: () => _showSnack('About App tapped'),
      ),
      _tile(
        icon: Icons.help_outline_rounded,
        iconColor: AppColors1.primary,
        title: 'Help & Support',
        subtitle: 'FAQs, contact us',
        onTap: () => _showSnack('Help & Support tapped'),
      ),
      _tile(
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: AppColors.primary,
        title: 'Send Feedback',
        subtitle: 'Rate us, suggest features',
        onTap: () => _showSnack('Feedback tapped'),
      ),
    ]);
  }

  // ─── Danger Card ──────────────────────────────────
  Widget _buildDangerCard() {
    return _card([
      _tile(
        icon: Icons.delete_outline_rounded,
        iconColor: AppColors.danger,
        title: 'Delete Account',
        subtitle: 'Permanent, cannot undo',
        titleColor: AppColors.danger,
        subtitleColor: AppColors.danger.withOpacity(0.6),
        trailingColor: AppColors.danger,
        onTap: _showDeleteDialog,
        dividerIndent: 16,
      ),
      _tile(
        icon: Icons.logout_rounded,
        iconColor: AppColors.danger,
        title: 'Log Out',
        subtitle: 'arjun.kumar@gmail.com',
        titleColor: AppColors.danger,
        subtitleColor: AppColors.danger.withOpacity(0.6),
        trailingColor: AppColors.danger,
        showChevron: false,
        onTap: _showLogoutDialog,
      ),
    ]);
  }

  // ─── Footer ───────────────────────────────────────
  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Column(
        children: const [
          Text(
            'Built with ♥ in Flutter · Privacy Policy · Terms',
            style: TextStyle(color: AppColors1.textThird, fontSize: 11.5),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 4),
          Text(
            '© 2025 YourApp Inc.',
            style: TextStyle(
                color: AppColors1.textThird, fontSize: 11.5),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // SHARED WIDGET HELPERS
  // ─────────────────────────────────────────────────

  Widget _sectionLabel(String text) {
    if (text.isEmpty) return const SizedBox(height: 4);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: AppColors1.textThird,
          fontSize: 10,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _card(List<Widget> children) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Column(
          children: List.generate(children.length, (i) {
            return Column(children: [children[i]]);
          }),
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color titleColor = AppColors.textPrimary,
    Color subtitleColor = AppColors.textSecond,
    Color trailingColor = AppColors1.textThird,
    bool showChevron = true,
    double dividerIndent = 60,
  }) {
    return Column(
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: iconColor.withOpacity(0.06),
            highlightColor: iconColor.withOpacity(0.04),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: Row(
                children: [
                  _iconWrap(icon, iconColor),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: titleColor,
                            fontSize: 14.5,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                                color: subtitleColor, fontSize: 11.5),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  trailing ??
                      (showChevron
                          ? Icon(Icons.chevron_right_rounded,
                              color: trailingColor, size: 20)
                          : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
        ),
        Divider(
            height: 1,
            thickness: 1,
            color: AppColors.border,
            indent: dividerIndent),
      ],
    );
  }

  Widget _switchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              _iconWrap(icon, iconColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle,
                          style: const TextStyle(
                              color: AppColors.textSecond, fontSize: 11.5)),
                    ],
                  ],
                ),
              ),
              CupertinoSwitch(
                value: value,
                onChanged: onChanged,
                activeColor: iconColor,
                trackColor: AppColors1.surface3,
              ),
            ],
          ),
        ),
        const Divider(
            height: 1, thickness: 1, color: AppColors.border, indent: 60),
      ],
    );
  }

  Widget _iconWrap(IconData icon, Color color) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 19, color: color),
    );
  }

  Widget _circleBtn(
      {required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: AppColors.surface2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, size: 18, color: AppColors.textSecond),
      ),
    );
  }

  Widget _statusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 10, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _outlineBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: color, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }

  // ─────────────────────────────────────────────────
  // DIALOGS & SNACKBARS
  // ─────────────────────────────────────────────────

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg,
            style: const TextStyle(color: AppColors.textPrimary)),
        backgroundColor: AppColors.surface2,
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        duration: const Duration(milliseconds: 1500),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log Out',
            style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700)),
        content: const Text(
          'Are you sure you want to log out of your account?',
          style: TextStyle(color: AppColors.textSecond),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecond)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSnack('Logged out successfully');
            },
            child: const Text('Log Out',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Delete Account',
            style: TextStyle(
                color: AppColors.danger, fontWeight: FontWeight.w700)),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be lost.',
          style: TextStyle(color: AppColors.textSecond),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecond)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              Navigator.pop(context);
              _showSnack('Account deletion requested');
            },
            child: const Text('Delete',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  PAYMENT PAGE
// ─────────────────────────────────────────────────────
class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<Map<String, String>> paymentMethods = [
    {"type": "UPI", "details": "rahul@upi"},
    {"type": "Card", "details": "**** **** **** 1234"},
  ];

  void _addPayment() {
    setState(() {
      paymentMethods
          .add({"type": "New Card", "details": "**** **** **** 5678"});
    });
  }

  void _deletePayment(int index) {
    setState(() => paymentMethods.removeAt(index));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: _buildAppBar(context, "Payment Methods"),
      body: paymentMethods.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.credit_card_off_outlined,
                      size: 60,
                      color: AppColors.textSecond.withOpacity(0.4)),
                  const SizedBox(height: 16),
                  const Text("No payment methods added",
                      style: TextStyle(
                          color: AppColors.textSecond, fontSize: 15)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: paymentMethods.length,
              itemBuilder: (_, index) {
                final item = paymentMethods[index];
                final isUpi = item["type"] == "UPI";

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: AppColors.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          isUpi
                              ? Icons.account_balance_wallet_outlined
                              : Icons.credit_card_rounded,
                          color: AppColors.primary,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["type"]!,
                                style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600)),
                            const SizedBox(height: 3),
                            Text(item["details"]!,
                                style: const TextStyle(
                                    color: AppColors.textSecond,
                                    fontSize: 13)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded,
                            color: AppColors.danger, size: 22),
                        onPressed: () => _deletePayment(index),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primary,
        onPressed: _addPayment,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Method",
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600)),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
//  SHARED HELPERS
// ─────────────────────────────────────────────────────
PreferredSizeWidget _buildAppBar(BuildContext context, String title) {
  return AppBar(
    backgroundColor: AppColors.bg,
    elevation: 0,
    centerTitle: true,
    leading: GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: const Icon(Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary, size: 16),
      ),
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 17,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.3,
      ),
    ),
  );
}

Widget _sectionTitle(String text) {
  return Text(text,
      style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 17,
          fontWeight: FontWeight.w700));
}


// whishitlist screen



