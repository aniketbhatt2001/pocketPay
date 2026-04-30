import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/widgets/app_button.dart';
import '../widgets/login_background.dart';

/// Screen for setting a new 6-digit MPIN.

class MpinScreen extends StatefulWidget {
  const MpinScreen({super.key});

  @override
  State<MpinScreen> createState() => _MpinScreenState();
}

class _MpinScreenState extends State<MpinScreen>
    with SingleTickerProviderStateMixin {
  static const int _pinLength = 6;

  final List<int> _pin = [];
  final List<int> _confirmPin = [];

  /// Which row is currently active: false = enter, true = confirm.
  bool _isConfirming = false;

  /// Shake animation controller for mismatch feedback.
  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  List<int> get _activePin => _isConfirming ? _confirmPin : _pin;

  bool get _canContinue =>
      _pin.length == _pinLength &&
      _confirmPin.length == _pinLength &&
      _pin.join() == _confirmPin.join();

  void _onDigit(int digit) {
    final active = _activePin;
    if (active.length >= _pinLength) return;

    setState(() => active.add(digit));

    // Auto-advance to confirm row once first PIN is complete.
    if (!_isConfirming && _pin.length == _pinLength) {
      setState(() => _isConfirming = true);
    }
  }

  void _onBackspace() {
    final active = _activePin;
    if (active.isEmpty) {
      // If confirm row is empty, go back to editing the first PIN.
      if (_isConfirming) {
        setState(() => _isConfirming = false);
      }
      return;
    }
    setState(() => active.removeLast());
  }

  void _onContinue() {
    if (!_canContinue) return;
    // TODO: persist / hash the MPIN via a use-case / BLoC before navigating.
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil(AppRoutes.wallet, (_) => false);
  }

  Future<void> _triggerMismatch() async {
    // Reset confirm row and shake it.
    setState(() => _confirmPin.clear());
    await _shakeController.forward(from: 0);
  }

  // Called when the confirm row just filled up.
  void _checkMatch() {
    if (_confirmPin.length == _pinLength) {
      if (_pin.join() != _confirmPin.join()) {
        _triggerMismatch();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('PINs do not match. Please try again.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.borderLg),
          ),
        );
      }
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: _MpinAppBar(onBack: () => Navigator.of(context).maybePop()),
        body: Stack(
          children: [
            const LoginBackground(),
            SafeArea(
              top: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.containerMargin,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: AppSpacing.lg),
                          _buildHero(),
                          const SizedBox(height: AppSpacing.lg),
                          _buildPinRows(),
                        ],
                      ),
                    ),
                  ),
                  _buildKeypad(),
                  _buildContinueButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Hero ───────────────────────────────────────────────────────────────────

  Widget _buildHero() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: const BoxDecoration(
            color: AppColors.primaryFixed,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.lock_rounded,
            size: 32,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        Text(
          'Set Secure MPIN',
          style: AppTypography.h1.copyWith(color: AppColors.primary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  // ── PIN dot rows ───────────────────────────────────────────────────────────

  Widget _buildPinRows() {
    return Column(
      children: [
        _PinRow(
          label: 'ENTER 6-DIGIT PIN',
          filledCount: _pin.length,
          isActive: !_isConfirming,
        ),
        const SizedBox(height: AppSpacing.md),
        AnimatedBuilder(
          animation: _shakeAnimation,
          builder: (context, child) {
            final offset =
                _shakeAnimation.value == 0
                    ? 0.0
                    : 8 *
                        (0.5 - (_shakeAnimation.value % 0.25) / 0.25).abs() *
                        (_shakeAnimation.value < 0.5 ? 1 : -1);
            return Transform.translate(offset: Offset(offset, 0), child: child);
          },
          child: _PinRow(
            label: 'CONFIRM MPIN',
            filledCount: _confirmPin.length,
            isActive: _isConfirming,
          ),
        ),
      ],
    );
  }

  // ── Numeric keypad ─────────────────────────────────────────────────────────

  Widget _buildKeypad() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.containerMargin,
      ),
      child: Column(
        children: [
          _buildKeyRow([1, 2, 3]),
          const SizedBox(height: AppSpacing.sm),
          _buildKeyRow([4, 5, 6]),
          const SizedBox(height: AppSpacing.sm),
          _buildKeyRow([7, 8, 9]),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              // Biometric placeholder (non-functional in setup flow)
              Expanded(
                child: _KeypadButton(
                  child: const Icon(
                    Icons.fingerprint_rounded,
                    size: 28,
                    color: AppColors.primary,
                  ),
                  onTap: () {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _KeypadButton(
                  label: '0',
                  onTap: () {
                    _onDigit(0);
                    if (_isConfirming) _checkMatch();
                  },
                ),
              ),

              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _KeypadButton(
                  onTap: _onBackspace,
                  child: const Icon(
                    Icons.backspace_outlined,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildKeyRow(List<int> digits) {
    return Row(
      children:
          digits.map((d) {
            final isLast = d == digits.last;
            return Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _KeypadButton(
                      label: '$d',
                      onTap: () {
                        _onDigit(d);
                        if (_isConfirming) _checkMatch();
                      },
                    ),
                  ),
                  if (!isLast) const SizedBox(width: AppSpacing.md),
                ],
              ),
            );
          }).toList(),
    );
  }

  // ── Continue button ────────────────────────────────────────────────────────

  Widget _buildContinueButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.containerMargin,
        AppSpacing.md,
        AppSpacing.containerMargin,
        AppSpacing.md,
      ),
      child: AppButton(
        onPressed: _canContinue ? _onContinue : null,
        child: Text(
          'Continue',
          style: AppTypography.button.copyWith(color: AppColors.onPrimary),
        ),
      ),
    );
  }
}

// ── PIN Row ────────────────────────────────────────────────────────────────

class _PinRow extends StatelessWidget {
  const _PinRow({
    required this.label,
    required this.filledCount,
    required this.isActive,
  });

  final String label;
  final int filledCount;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: AppTypography.labelSm.copyWith(
            color: isActive ? AppColors.primary : AppColors.outline,
            letterSpacing: 0.05 * 12,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(6, (i) {
            final filled = i < filledCount;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: filled ? AppColors.primary : Colors.transparent,
                  border: Border.all(
                    color:
                        filled ? AppColors.primary : AppColors.outlineVariant,
                    width: 2,
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}

// ── Keypad Button ──────────────────────────────────────────────────────────

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({this.label, this.child, required this.onTap})
    : assert(label != null || child != null);

  final String? label;
  final Widget? child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      borderRadius: AppRadius.borderXl,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.borderXl,
        splashColor: AppColors.primaryFixed,
        highlightColor: AppColors.primaryFixed.withAlpha(80),
        child: SizedBox(
          height: 64,
          child: Center(
            child:
                label != null
                    ? Text(
                      label!,
                      style: AppTypography.h2.copyWith(
                        color: AppColors.primary,
                      ),
                    )
                    : child,
          ),
        ),
      ),
    );
  }
}

// ── App Bar ────────────────────────────────────────────────────────────────

class _MpinAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _MpinAppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
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
              IconButton(
                onPressed: onBack,
                icon: const Icon(Icons.arrow_back_rounded),
                color: AppColors.onSurfaceVariant,
                iconSize: 24,
              ),
              Text(
                'Security',
                style: AppTypography.h2.copyWith(
                  color: AppColors.primaryContainer,
                  fontWeight: FontWeight.w800,
                ),
              ),
              // Avatar placeholder — matches the design's profile image
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryFixed,
                  border: Border.all(color: AppColors.outlineVariant, width: 1),
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
