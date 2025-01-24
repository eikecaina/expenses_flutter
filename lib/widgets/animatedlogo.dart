import 'package:flutter/material.dart';

class AnimatedSplashLogo extends StatefulWidget {
  const AnimatedSplashLogo({
    super.key,
  });

  @override
  State<AnimatedSplashLogo> createState() => _AnimatedSplashLogoState();
}

class _AnimatedSplashLogoState extends State<AnimatedSplashLogo>
    with SingleTickerProviderStateMixin {
  Animation<double>? _animation;
  AnimationController? _animationController;
  bool hasBlur = false;

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animationController!.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        setState(() {
          hasBlur = false;
        });
      } else {
        setState(() {
          hasBlur = true;
        });
      }
    });

    _animation = Tween(begin: 50.0, end: 150.0).animate(
      CurvedAnimation(parent: _animationController!, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
          animation: _animation!,
          child: Image.asset('assets/icons/logo.png'),
          builder: (context, child) {
            return Container(
              width: _animation!.value,
              height: _animation!.value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey,
                    Colors.grey.withOpacity(0.5),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.transparent,
                  width: 3,
                ),
                boxShadow: !hasBlur
                    ? [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 18,
                          spreadRadius: 9,
                        ),
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 18,
                          spreadRadius: 9,
                        ),
                      ]
                    : [],
              ),
              child: child,
            );
          }),
    );
  }
}
