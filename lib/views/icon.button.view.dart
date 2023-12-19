import 'package:flutter/material.dart';

import '../utils/snackbar.dart';

class IconButtonView extends StatefulWidget {
  final bool showBackgroundColor;
  final IconData icon;
  final Color iconColor;
  final Future Function()? onTap;

  const IconButtonView({
    super.key,
    required this.icon,
    this.showBackgroundColor = true,
    this.iconColor = Colors.white,
    this.onTap,
  });

  @override
  State<IconButtonView> createState() => _IconButtonViewState();
}

class _IconButtonViewState extends State<IconButtonView> {
  bool _loading = false;
  late IconData _icon = widget.icon;

  void onTap() async {
    try {
      if (_loading) {
        return;
      }
      if (widget.onTap != null) {
        setState(() {
          _loading = true;
        });
        var res = await widget.onTap!();
        setState(() {
          _loading = false;
        });
        if (res is IconData) {
          setState(() {
            _icon = res;
          });
        }
      }
    } catch (e) {
      setState(() {
        _loading = false;
      });
      if (mounted) {
        showSnackBar(context, message: e.toString());
      }
      debugPrint('Error happened: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: _loading
          ? const SizedBox(
              width: 36,
              height: 36,
              child: Center(
                child: SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            )
          : Material(
              color: Colors.transparent,
              shape: const CircleBorder(),
              clipBehavior: Clip.hardEdge,
              child: InkWell(
                onTap: onTap,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: widget.showBackgroundColor
                        ? Colors.black.withOpacity(0.3)
                        : null,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _icon,
                    color: widget.iconColor,
                  ),
                ),
              ),
            ),
    );
  }
}
