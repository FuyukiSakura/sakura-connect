import 'package:flutter/material.dart';
import '../pages/queue_page.dart';

class DesktopLayout extends StatefulWidget {
  final Widget child;
  
  const DesktopLayout({
    super.key,
    required this.child,
  });

  @override
  State<DesktopLayout> createState() => _DesktopLayoutState();
}

class _DesktopLayoutState extends State<DesktopLayout>
    with SingleTickerProviderStateMixin {
  bool _isQueueVisible = false;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void showQueue() {
    setState(() {
      _isQueueVisible = true;
    });
    _animationController.forward();
  }

  void hideQueue() {
    _animationController.reverse().then((_) {
      if (mounted) {
        setState(() {
          _isQueueVisible = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 1200;
    
    if (!isDesktop) {
      return widget.child;
    }

    return Row(
      children: [
        // Main content - squeezed when queue is visible
        AnimatedBuilder(
          animation: _slideAnimation,
          builder: (context, child) {
            final mainContentWidth = _isQueueVisible 
              ? screenWidth - 400 // Leave space for queue
              : screenWidth;
            
            return SizedBox(
              width: mainContentWidth,
              child: widget.child,
            );
          },
        ),
        
        // Queue panel - slides in from right
        if (_isQueueVisible)
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(400 * _slideAnimation.value, 0),
                child: SizedBox(
                  width: 400,
                  child: Material(
                    elevation: 8,
                    shadowColor: Colors.black26,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          left: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          // Header
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.queue_play_next,
                                  size: 20,
                                  color: Colors.grey.shade700,
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Download Queue',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  onPressed: hideQueue,
                                  icon: const Icon(Icons.close),
                                  iconSize: 20,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(
                                    minWidth: 32,
                                    minHeight: 32,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Queue content
                          const Expanded(
                            child: QueuePage(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

// Extension to access the desktop layout from anywhere
extension DesktopLayoutExtension on BuildContext {
  void showDesktopQueue() {
    final desktopLayout = findAncestorStateOfType<_DesktopLayoutState>();
    desktopLayout?.showQueue();
  }
  
  void hideDesktopQueue() {
    final desktopLayout = findAncestorStateOfType<_DesktopLayoutState>();
    desktopLayout?.hideQueue();
  }
}
