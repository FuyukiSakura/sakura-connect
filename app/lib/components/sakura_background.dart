import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SakuraBackground extends StatelessWidget {
  final Widget child;
  final double gridSize;
  final double iconSize;
  final double iconOpacity;
  final bool enableFalling;
  final int petalCount;

  const SakuraBackground({
    super.key,
    required this.child,
    this.gridSize = 80.0,
    this.iconSize = 16.0,
    this.iconOpacity = 0.08,
    this.enableFalling = true,
    this.petalCount = 18,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Base background color
        Container(
          color: AppColors.backgroundGray,
        ),
        
        // Vibrant pink gradient wash for a more premium look
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.15),
                    AppColors.primary.withValues(alpha: 0.08),
                    Colors.transparent,
                    AppColors.primary.withValues(alpha: 0.12),
                  ],
                  stops: const [0.0, 0.3, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ),
        
        // Custom painted grid and sakura pattern
        Positioned.fill(
          child: CustomPaint(
            painter: SakuraGridPainter(
              gridSize: gridSize,
              iconSize: iconSize,
              iconOpacity: iconOpacity,
            ),
          ),
        ),
        
        // Falling sakura overlay (animated)
        if (enableFalling)
          Positioned.fill(
            child: SakuraFallingOverlay(
              petalCount: petalCount,
            ),
          ),
        
        // Content on top
        child,
      ],
    );
  }
}

class SakuraGridPainter extends CustomPainter {
  final double gridSize;
  final double iconSize;
  final double iconOpacity;

  SakuraGridPainter({
    required this.gridSize,
    required this.iconSize,
    required this.iconOpacity,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Grid line paint - more subtle and modern
    final gridPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    // Draw diagonal cross pattern
    for (double x = 0; x <= size.width + gridSize; x += gridSize) {
      for (double y = 0; y <= size.height + gridSize; y += gridSize) {
        // Draw diagonal cross at each grid point
        _drawDiagonalCross(canvas, Offset(x, y), gridSize * 0.3, gridPaint);
      }
    }

    // Draw sakura icons at grid intersections - more subtle and modern
    final iconPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: iconOpacity * 0.7)
      ..style = PaintingStyle.fill;

    // Create sakura pattern at every other grid intersection
    for (double x = gridSize * 1.5; x < size.width; x += gridSize * 2.5) {
      for (double y = gridSize * 1.5; y < size.height; y += gridSize * 2.5) {
        _drawSakuraIcon(canvas, Offset(x, y), iconSize * 0.8, iconPaint);
      }
    }

    // Add some scattered sakura icons for more cuteness
    final scatteredPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: iconOpacity * 0.4)
      ..style = PaintingStyle.fill;

    for (double x = gridSize * 0.7; x < size.width; x += gridSize * 3.2) {
      for (double y = gridSize * 0.7; y < size.height; y += gridSize * 3.2) {
        _drawSakuraIcon(canvas, Offset(x, y), iconSize * 0.6, scatteredPaint);
      }
    }
  }

  void _drawDiagonalCross(Canvas canvas, Offset center, double size, Paint paint) {
    // Draw diagonal cross (X shape)
    final halfSize = size * 0.5;
    
    // Draw first diagonal line (\)
    canvas.drawLine(
      Offset(center.dx - halfSize, center.dy - halfSize),
      Offset(center.dx + halfSize, center.dy + halfSize),
      paint,
    );
    
    // Draw second diagonal line (/)
    canvas.drawLine(
      Offset(center.dx - halfSize, center.dy + halfSize),
      Offset(center.dx + halfSize, center.dy - halfSize),
      paint,
    );
  }

  void _drawSakuraIcon(Canvas canvas, Offset center, double size, Paint paint) {
    // Draw a more modern, simplified sakura flower (5 petals)
    final petalSize = size * 0.35;
    
    // Draw 5 petals around the center in a more natural arrangement
    for (int i = 0; i < 5; i++) {
      final angle = (i * 2 * 3.14159) / 5 - 3.14159 / 2; // Start from top
      final petalDistance = petalSize * 0.7;
      final petalCenter = Offset(
        center.dx + petalDistance * (i == 0 ? 0 : (i <= 2 ? 0.9 : -0.9) * (i % 2 == 0 ? 1 : 0.7)),
        center.dy + petalDistance * (i == 0 ? -0.9 : (i <= 2 ? 0.5 : 0.5)),
      );
      
      // Create more natural petal shape (rounded)
      final petalRect = Rect.fromCenter(
        center: petalCenter,
        width: petalSize * 0.7,
        height: petalSize * 1.1,
      );
      
      canvas.save();
      canvas.translate(petalCenter.dx, petalCenter.dy);
      canvas.rotate(angle);
      canvas.translate(-petalCenter.dx, -petalCenter.dy);
      
      // Draw petal with rounded corners
      final rrect = RRect.fromRectAndRadius(petalRect, Radius.circular(petalSize * 0.3));
      canvas.drawRRect(rrect, paint);
      canvas.restore();
    }
    
    // Draw center of flower - smaller and more subtle
    final centerPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: iconOpacity * 1.2)
      ..style = PaintingStyle.fill;
    
    canvas.drawCircle(center, size * 0.12, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! SakuraGridPainter ||
        oldDelegate.gridSize != gridSize ||
        oldDelegate.iconSize != iconSize ||
        oldDelegate.iconOpacity != iconOpacity;
  }
}

class SakuraFallingOverlay extends StatefulWidget {
  final int petalCount;

  const SakuraFallingOverlay({super.key, this.petalCount = 18});

  @override
  State<SakuraFallingOverlay> createState() => _SakuraFallingOverlayState();
}

class _Petal {
  Offset position;
  double size;
  double speedY;
  double swayAmplitude;
  double swaySpeed;
  double phase;
  double rotation;
  double rotationSpeed;

  _Petal({
    required this.position,
    required this.size,
    required this.speedY,
    required this.swayAmplitude,
    required this.swaySpeed,
    required this.phase,
    required this.rotation,
    required this.rotationSpeed,
  });
}

class _SakuraFallingOverlayState extends State<SakuraFallingOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  final List<_Petal> _petals = <_Petal>[];
  Size _canvasSize = Size.zero;
  DateTime _lastTick = DateTime.now();
  final math.Random _rand = math.Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..addListener(_tick)
     ..repeat();
  }

  @override
  void dispose() {
    _controller.removeListener(_tick);
    _controller.dispose();
    super.dispose();
  }

  void _spawnPetalsIfNeeded() {
    if (_canvasSize == Size.zero) return;
    while (_petals.length < widget.petalCount) {
      _petals.add(_createRandomPetal(startAbove: true));
    }
  }

  _Petal _createRandomPetal({bool startAbove = false}) {
    final width = _canvasSize.width;
    final height = _canvasSize.height;
    final size = 8.0 + _rand.nextDouble() * 12.0;
    return _Petal(
      position: Offset(
        _rand.nextDouble() * width,
        startAbove ? -_rand.nextDouble() * height * 0.5 : _rand.nextDouble() * height,
      ),
      size: size,
      speedY: 20 + _rand.nextDouble() * 30, // px/sec
      swayAmplitude: 10 + _rand.nextDouble() * 18,
      swaySpeed: 0.6 + _rand.nextDouble() * 0.8, // radians/sec
      phase: _rand.nextDouble() * math.pi * 2,
      rotation: _rand.nextDouble() * math.pi * 2,
      rotationSpeed: (_rand.nextDouble() * 2 - 1) * 0.6, // radians/sec
    );
  }

  void _tick() {
    final now = DateTime.now();
    final dt = now.difference(_lastTick).inMilliseconds / 1000.0;
    _lastTick = now;
    if (dt <= 0 || _canvasSize == Size.zero || _petals.isEmpty) {
      if (mounted) setState(() {});
      return;
    }

    final width = _canvasSize.width;
    final height = _canvasSize.height;

    for (int i = 0; i < _petals.length; i++) {
      final p = _petals[i];
      final sway = math.sin(p.phase + _controller.value * 2 * math.pi) * p.swayAmplitude;
      final dy = p.speedY * dt;
      p.position = Offset(p.position.dx + sway * dt, p.position.dy + dy);
      p.rotation += p.rotationSpeed * dt;

      if (p.position.dy - p.size > height || p.position.dx < -40 || p.position.dx > width + 40) {
        _petals[i] = _createRandomPetal(startAbove: true);
      }
    }

    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        _canvasSize = Size(constraints.maxWidth, constraints.maxHeight);
        _spawnPetalsIfNeeded();
        return IgnorePointer(
          child: RepaintBoundary(
            child: CustomPaint(
              painter: _FallingPetalsPainter(petals: _petals),
            ),
          ),
        );
      },
    );
  }
}

class _FallingPetalsPainter extends CustomPainter {
  final List<_Petal> petals;

  _FallingPetalsPainter({required this.petals});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in petals) {
      final color = AppColors.primary.withValues(alpha: 0.18);
      final paint = Paint()..color = color..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(p.position.dx, p.position.dy);
      canvas.rotate(p.rotation);
      // Draw a single petal as a rounded oval with slight point
      final rect = Rect.fromCenter(center: Offset.zero, width: p.size * 0.9, height: p.size * 1.4);
      final rrect = RRect.fromRectAndRadius(rect, Radius.circular(p.size * 0.45));
      canvas.drawRRect(rrect, paint);
      // Add a tiny highlight
      final highlight = Paint()..color = AppColors.white.withValues(alpha: 0.15)..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(-p.size * 0.15, -p.size * 0.2), p.size * 0.12, highlight);
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FallingPetalsPainter oldDelegate) {
    return true;
  }
}
