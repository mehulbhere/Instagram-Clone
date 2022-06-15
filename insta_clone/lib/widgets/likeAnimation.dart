import 'package:flutter/material.dart';

class LikeAnimation extends StatefulWidget {
  final Widget child;       //make like animation parent 
  final bool isAnimating;   
  final Duration duration;  //how long like animation 
  final VoidCallback? onEnd;  //end like animation
  final bool smallLike; //small like button clicked
  const LikeAnimation(
      {Key? key,
      required this.child,
      required this.duration,
      required this.isAnimating,
      required this.onEnd,
      required this.smallLike})
      : super(key: key);

  @override
  _LikeAnimationState createState() => _LikeAnimationState();
}

class _LikeAnimationState extends State<LikeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> scale;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: widget.duration.inMilliseconds ~/ 2));
    scale = Tween<double>(begin: 1, end: 1.2).animate(_animationController);
  }
  @override
  void didUpdateWidget(covariant LikeAnimation oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if(widget.isAnimating != oldWidget.isAnimating){
      startAnimation();
    }
  }

  startAnimation() async{
    if(widget.isAnimating || widget.smallLike){
      await _animationController.forward();
      await _animationController.reverse();
      await Future.delayed(Duration(milliseconds: 200));
      if(widget.onEnd != null){
        widget.onEnd!();
      }
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _animationController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scale,
      child: widget.child
    );
  }
}
