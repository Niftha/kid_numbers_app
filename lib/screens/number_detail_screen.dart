import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../models/number_model.dart';
import '../utils/audio_player_util.dart';

class NumberDetailScreen extends StatefulWidget {
  final NumberModel number;
  const NumberDetailScreen({Key? key, required this.number}) : super(key: key);

  @override
  State<NumberDetailScreen> createState() => _NumberDetailScreenState();
}

class _NumberDetailScreenState extends State<NumberDetailScreen>
    with TickerProviderStateMixin {
  late AudioPlayerUtil _audioUtil;
  late AnimationController _bounceController;
  late AnimationController _starsController;
  late AnimationController _confettiController;
  late AnimationController _floatController;
  late AnimationController _pulseController;

  late Animation<double> _bounceAnimation;
  late Animation<double> _starsAnimation;
  late Animation<double> _confettiAnimation;
  late Animation<double> _floatAnimation;
  late Animation<double> _pulseAnimation;

  bool _isPlaying = false;
  bool _showConfetti = false;
  int _tappedStars = 0;

  @override
  void initState() {
    super.initState();
    _audioUtil = AudioPlayerUtil();

   
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _bounceAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _bounceController, curve: Curves.elasticOut),
    );

    
    _starsController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _starsAnimation = CurvedAnimation(
      parent: _starsController,
      curve: Curves.easeInOut,
    );

    
    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    
    _floatController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _floatAnimation = CurvedAnimation(
      parent: _floatController,
      curve: Curves.easeInOut,
    );

    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

   
    _bounceController.forward();
    _floatController.repeat(reverse: true);
    _pulseController.repeat(reverse: true);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _starsController.forward();
    });
  }

  @override
  void dispose() {
    _audioUtil.dispose();
    _bounceController.dispose();
    _starsController.dispose();
    _confettiController.dispose();
    _floatController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _playSound() {
    setState(() => _isPlaying = true);
    _audioUtil.playAsset(widget.number.audioAsset).then((_) {
      if (mounted) setState(() => _isPlaying = false);
    });

    
    _bounceController.reset();
    _bounceController.forward();

   
    _triggerConfetti();
  }

  void _triggerConfetti() {
    setState(() => _showConfetti = true);
    _confettiController.forward().then((_) {
      if (mounted) {
        setState(() => _showConfetti = false);
        _confettiController.reset();
      }
    });
  }

  void _onStarTap() {
    setState(() {
      if (_tappedStars < widget.number.value) {
        _tappedStars++;
      }
     
      if (_tappedStars >= widget.number.value) {
        _tappedStars = 0;
        _triggerConfetti();
      }
    });
  }

  
  Color _getNumberColor(int number) {
    final colors = [
      Colors.red, Colors.orange, Colors.yellow, Colors.green, Colors.blue,
      Colors.indigo, Colors.purple, Colors.pink, Colors.teal, Colors.cyan
    ];
    return colors[(number - 1) % colors.length];
  }

  String _getNumberEmoji(int number) {
    final emojis = [
      '🍎', '🍊', '🍋', '🍇', '🍓',
      '🍒', '🍑', '🥝', '🍉', '🍌'
    ];
    return emojis[(number - 1) % emojis.length];
  }

  @override
  Widget build(BuildContext context) {
    final n = widget.number;
    final numberColor = _getNumberColor(n.value);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              numberColor.withOpacity(0.8),
              numberColor.withOpacity(0.4),
              Colors.white,
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              _buildFloatingDecorations(numberColor),
              _buildMainContent(numberColor),
              if (_showConfetti) _buildConfettiOverlay(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingDecorations(Color numberColor) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Positioned(
              top: 20 + 10 * _floatAnimation.value,
              left: 20,
              child: Icon(Icons.cloud, color: Colors.white.withOpacity(0.7), size: 60),
            );
          },
        ),
        AnimatedBuilder(
          animation: _floatAnimation,
          builder: (context, child) {
            return Positioned(
              top: 40 - 10 * _floatAnimation.value,
              right: 30,
              child: Icon(Icons.cloud, color: Colors.white.withOpacity(0.5), size: 80),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMainContent(Color numberColor) {
    final n = widget.number;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildCustomAppBar(numberColor),
        const SizedBox(height: 20),
        _buildNumberDisplay(numberColor),
        _buildNumberWord(numberColor),
        const SizedBox(height: 20),
        _buildCountingSection(numberColor), 
        const Spacer(),
        _buildInteractiveButtons(numberColor),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildCustomAppBar(Color numberColor) {
    final n = widget.number;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: IconButton(icon: Icon(Icons.arrow_back, color: numberColor), onPressed: () => Navigator.of(context).pop()),
          ),
          
          Text(
            "Number ${n.value}",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white, shadows: [
              Shadow(blurRadius: 3.0, color: Colors.black.withOpacity(0.2), offset: const Offset(1.0, 1.0))
            ]),
          ),
          
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.8),
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
            ),
            child: Center(child: Text(_getNumberEmoji(n.value), style: const TextStyle(fontSize: 30))),
          ),
        ],
      ),
    );
  }

  Widget _buildNumberDisplay(Color numberColor) {
    final n = widget.number;
    return Expanded(
      flex: 3,
      child: Center(
        child: AnimatedBuilder(
          animation: _bounceAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _bounceAnimation.value,
              child: Container(
                width: 200, height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [BoxShadow(color: numberColor.withOpacity(0.4), spreadRadius: 5, blurRadius: 15, offset: const Offset(0, 5))],
                ),
                child: Stack(
                  children: [
                    Positioned.fill(child: CustomPaint(painter: DotsPainter(color: numberColor.withOpacity(0.1)))),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(_getNumberEmoji(n.value), style: const TextStyle(fontSize: 60)),
                          Text(n.value.toString(), style: TextStyle(fontSize: 80, fontWeight: FontWeight.bold, color: numberColor)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildNumberWord(Color numberColor) {
    final n = widget.number;
    return AnimatedBuilder(
      animation: _starsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _starsAnimation.value)),
          child: Opacity(
            opacity: _starsAnimation.value,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
              ),
              child: Text(n.word, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: numberColor)),
            ),
          ),
        );
      },
    );
  }

  
  Widget _buildCountingSection(Color numberColor) {
    final n = widget.number;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Text(
            "Tap the stars to count to ${n.value}!",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: numberColor),
          ),
          const SizedBox(height: 15),
          
          Wrap(
            spacing: 8.0,   
            runSpacing: 8.0, 
            alignment: WrapAlignment.center,
            children: List.generate(n.value, (index) {
              final isTapped = index < _tappedStars;
              return GestureDetector(
                onTap: _onStarTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    color: isTapped ? Colors.amber : Colors.grey[300],
                    shape: BoxShape.circle, 
                    boxShadow: [
                      BoxShadow(
                        color: isTapped ? Colors.amber.withOpacity(0.5) : Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: isTapped ? 4 : 2,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Icon(
                    Icons.star,
                    color: isTapped ? Colors.white : Colors.grey[600],
                    
                    size: 22.0,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveButtons(Color numberColor) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildPronounceButton(numberColor),
          _buildCelebrateButton(),
        ],
      ),
    );
  }

  Widget _buildPronounceButton(Color numberColor) {
    return GestureDetector(
      onTap: _playSound,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isPlaying ? 180 : 160,
        height: _isPlaying ? 70 : 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: numberColor.withOpacity(0.4),
              spreadRadius: _isPlaying ? 5 : 2,
              blurRadius: _isPlaying ? 15 : 8,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(_isPlaying ? Icons.volume_up : Icons.play_arrow, color: numberColor, size: _isPlaying ? 35 : 30),
            const SizedBox(width: 10),
            Text(_isPlaying ? 'Playing...' : 'Pronounce', style: TextStyle(fontSize: _isPlaying ? 18 : 16, fontWeight: FontWeight.bold, color: numberColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildCelebrateButton() {
    return GestureDetector(
      onTap: _triggerConfetti,
      child: AnimatedBuilder(
        animation: _pulseAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _pulseAnimation.value,
            child: Container(
              width: 60, height: 60,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [BoxShadow(color: Colors.amber.withOpacity(0.4), spreadRadius: 2, blurRadius: 8, offset: const Offset(0, 3))],
              ),
              child: const Icon(Icons.celebration, color: Colors.amber, size: 30),
            ),
          );
        },
      ),
    );
  }

  Widget _buildConfettiOverlay() {
    return Positioned.fill(
      child: Lottie.asset('assets/lottie/celebrate.json', repeat: false, fit: BoxFit.cover),
    );
  }
}


class DotsPainter extends CustomPainter {
  final Color color;
  DotsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.fill;
    const dotSize = 8.0;
    const spacing = 20.0;
    for (double x = spacing; x < size.width; x += spacing) {
      for (double y = spacing; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), dotSize / 2, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

