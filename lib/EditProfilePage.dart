import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────
//  THEME CONSTANTS (mirrors ProfileScreen)
// ─────────────────────────────────────────────────────
class AppColors {
  static const primary     = Color(0xFF00C97B);
  static const primaryDark = Color(0xFF00A562);
  static const bg          = Color(0xFF0F1923);
  static const surface     = Color(0xFF1A2634);
  static const surface2    = Color(0xFF223044);
  static const border      = Color(0xFF2D3F55);
  static const textPrimary = Color(0xFFEAF2FF);
  static const textSecond  = Color(0xFF7A94B0);
  static const danger      = Color(0xFFFF4D6A);
}

// ─────────────────────────────────────────────────────
//  EDIT PROFILE PAGE  (view + inline edit in one screen)
// ─────────────────────────────────────────────────────
class EditProfilePage extends StatefulWidget {
  final String userName;
  final String email;

  const EditProfilePage({
    super.key,
    required this.userName,
    required this.email,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage>
    with SingleTickerProviderStateMixin {
  late String uname;
  late String email;

  bool _isEditing = false;
  late TextEditingController _unameController;
  final _formKey = GlobalKey<FormState>();

  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    uname = widget.userName;
    email = widget.email;
    _unameController = TextEditingController(text: uname);

    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnim  = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.06),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));

    _animCtrl.forward();
  }

  @override
  void dispose() {
    _unameController.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        uname    = _unameController.text.trim();
        _isEditing = false;
      });
      // Pop back immediately with the updated name so ProfileScreen updates
      Navigator.pop(context, {
        "userName": uname,
        "email": email,
      });
    }
  }

  void _cancelEdit() {
    setState(() {
      _unameController.text = uname;
      _isEditing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
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
        title: const Text(
          "My Profile",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 12),

                  // ── Avatar ──────────────────────────────
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [AppColors.primary, AppColors.primaryDark],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.35),
                              blurRadius: 24,
                              spreadRadius: 3,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 52,
                          backgroundColor: AppColors.surface,
                          child: Text(
                            uname.isNotEmpty
                                ? uname[0].toUpperCase()
                                : "U",
                            style: const TextStyle(
                              fontSize: 44,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      // Camera badge
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: AppColors.bg, width: 2.5),
                        ),
                        child: const Icon(Icons.camera_alt_rounded,
                            color: Colors.white, size: 17),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ── Name display ─────────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      uname,
                      key: ValueKey(uname),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    style: const TextStyle(
                      color: AppColors.textSecond,
                      fontSize: 13.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Info card ────────────────────────────
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.border),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Name field
                        _isEditing
                            ? _buildEditField()
                            : _buildInfoRow(
                                Icons.person_outline_rounded,
                                "Display Name",
                                uname,
                              ),

                        const Divider(
                            height: 1,
                            thickness: 1,
                            color: AppColors.border,
                            indent: 60),

                        // Email (read-only always)
                        _buildInfoRow(
                          Icons.email_outlined,
                          "Email Address",
                          email,
                          isReadOnly: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ── Action buttons ───────────────────────
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isEditing
                        ? _buildEditingButtons()
                        : _buildEditButton(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ── Static info row ──────────────────────────────────
  Widget _buildInfoRow(IconData icon, String label, String value,
      {bool isReadOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isReadOnly
                  ? AppColors.textSecond.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.12),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon,
                size: 19,
                color: isReadOnly ? AppColors.textSecond : AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: AppColors.textSecond,
                        fontSize: 11,
                        letterSpacing: 0.8)),
                const SizedBox(height: 3),
                Text(value,
                    style: TextStyle(
                        color: isReadOnly
                            ? AppColors.textSecond
                            : AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w500)),
              ],
            ),
          ),
          if (isReadOnly)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.textSecond.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text("Locked",
                  style: TextStyle(
                      color: AppColors.textSecond,
                      fontSize: 10,
                      letterSpacing: 0.5)),
            ),
        ],
      ),
    );
  }

  // ── Editable name field ──────────────────────────────
  Widget _buildEditField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.18),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(Icons.drive_file_rename_outline_rounded,
                size: 19, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: TextFormField(
              controller: _unameController,
              autofocus: true,
              style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                labelText: "Display Name",
                labelStyle:
                    const TextStyle(color: AppColors.textSecond, fontSize: 11),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 6),
                enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.border)),
                focusedBorder: const UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: AppColors.primary, width: 1.5)),
                errorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.danger)),
                focusedErrorBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.danger, width: 1.5)),
                errorStyle: const TextStyle(color: AppColors.danger),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return "Name cannot be empty";
                }
                if (val.trim().length < 2) {
                  return "Name must be at least 2 characters";
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }

  // ── Edit button (not editing state) ─────────────────
  Widget _buildEditButton() {
    return SizedBox(
      key: const ValueKey("edit_btn"),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => setState(() => _isEditing = true),
        icon: const Icon(Icons.edit_outlined, size: 18, color: Colors.white),
        label: const Text("Edit Name",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15)),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
      ),
    );
  }

  // ── Save + Cancel buttons (editing state) ────────────
  Widget _buildEditingButtons() {
    return Column(
      key: const ValueKey("editing_btns"),
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _saveChanges,
            icon: const Icon(Icons.check_rounded,
                size: 18, color: Colors.white),
            label: const Text("Save Changes",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: _cancelEdit,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.border, width: 1.5),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text("Cancel",
                style: TextStyle(
                    color: AppColors.textSecond,
                    fontWeight: FontWeight.w600,
                    fontSize: 15)),
          ),
        ),
      ],
    );
  }
}
