import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/login_hero.dart';
import '../widgets/login_input_card.dart';
import '../widgets/login_security_note.dart';
import '../widgets/login_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _phoneController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onContinue() {
    // TODO: wire to auth use-case
    final number = _phoneController.text.trim();
    if (number.isEmpty) {
      _focusNode.requestFocus();
      return;
    }
    debugPrint('Continue tapped: $number');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _LoginAppBar(),
        body: Stack(
          children: [
            const LoginBackground(),
            SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.containerMargin,
                  vertical: AppSpacing.xl,
                ),
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xl),
                    const LoginHero(),
                    const SizedBox(height: AppSpacing.xl),
                    LoginInputCard(
                      controller: _phoneController,
                      focusNode: _focusNode,
                      onContinue: _onContinue,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    const LoginSecurityNote(),
                    const SizedBox(height: AppSpacing.xl),
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

class _LoginAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 100,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        
        boxShadow: AppShadows.level1,
      ),
      child: SafeArea(
  
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.containerMargin,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Brand
              Text(
                'PocketPay',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w800,
             
                ),
              ),
              // Help
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.help_outline_rounded),
                color: AppColors.onSurfaceVariant,
                iconSize: 24,
                style: IconButton.styleFrom(
                  backgroundColor: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    
    );
  }
}
