import 'package:flutter/material.dart';
import '../models/number_model.dart';

class NumberCard extends StatefulWidget {
  final NumberModel number;
  final VoidCallback onTap;

  const NumberCard({Key? key, required this.number, required this.onTap}) : super(key: key);

  @override
  _NumberCardState createState() => _NumberCardState();
}

class _NumberCardState extends State<NumberCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    _rotationAnimation = Tween<double>(begin: 0.0, end: 0.05).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() {
      _isPressed = true;
    });
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
    widget.onTap();
  }

  void _handleTapCancel() {
    setState(() {
      _isPressed = false;
    });
    _controller.reverse();
  }

  // Get a color based on the number value
  Color _getNumberColor() {
    final colors = [
      Colors.red[400],
      Colors.orange[400],
      Colors.amber[400],
      Colors.green[400],
      Colors.teal[400],
      Colors.blue[400],
      Colors.indigo[400],
      Colors.purple[400],
      Colors.pink[400],
      Colors.cyan[400],
    ];
    return colors[(widget.number.value - 1) % colors.length]!;
  }

  // Get an emoji based on the number value
  String _getNumberEmoji() {
    final emojis = [
      '🍎', '🍊', '🍋', '🍇', '🍓', 
      '🍒', '🍑', '🥝', '🍉', '🍌'
    ];
    return emojis[(widget.number.value - 1) % emojis.length];
  }

  @override
  Widget build(BuildContext context) {
    final numberColor = _getNumberColor();
    
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      numberColor.withOpacity(0.8),
                      numberColor.withOpacity(0.6),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: numberColor.withOpacity(0.4),
                      spreadRadius: _isPressed ? 1 : 3,
                      blurRadius: _isPressed ? 5 : 10,
                      offset: _isPressed ? const Offset(0, 2) : const Offset(0, 5),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    // Background pattern
                    Positioned.fill(
                      child: CustomPaint(
                        painter: DotsPainter(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                    
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Number emoji/icon
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 5,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _getNumberEmoji(),
                                style: const TextStyle(fontSize: 32),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                          // Number value
                          Text(
                            widget.number.value.toString(),
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  blurRadius: 3.0,
                                  color: Colors.black26,
                                  offset: Offset(1.0, 1.0),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 4),
                          
                          // Number word
                          Text(
                            widget.number.word,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          
                          // Stars representing the number
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.number.value > 5 ? 5 : widget.number.value,
                              (index) => Icon(
                                Icons.star,
                                color: Colors.amber[300],
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Decorative elements
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.auto_awesome,
                        color: Colors.white.withOpacity(0.7),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Custom painter for background dots
class DotsPainter extends CustomPainter {
  final Color color;

  DotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    const dotSize = 6.0;
    const spacing = 15.0;

    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}