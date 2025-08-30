import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../components/app_sidebar.dart';
import '../components/sakura_background.dart';
import '../components/desktop_layout.dart';
import 'downloader_page.dart';
import 'queue_page.dart';
import 'setup_page.dart';
import 'about_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _appBarAnimationController;
  late Animation<Offset> _appBarOffsetAnimation;
  
  bool _isSidebarOpen = false;
  bool _isAppBarVisible = true;
  double _lastScrollOffset = 0;
  static const double _scrollThreshold = 10.0;
  AppFeature _currentFeature = AppFeature.downloader;

  @override
  void initState() {
    super.initState();
    
    _appBarAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _appBarOffsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(CurvedAnimation(
      parent: _appBarAnimationController,
      curve: Curves.easeInOut,
    ));

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final currentScrollOffset = _scrollController.offset;
    final difference = currentScrollOffset - _lastScrollOffset;

    if (difference.abs() > _scrollThreshold) {
      final shouldHide = difference > 0 && currentScrollOffset > kToolbarHeight;
      
      if (shouldHide && _isAppBarVisible) {
        _hideAppBar();
      } else if (!shouldHide && !_isAppBarVisible) {
        _showAppBar();
      }
      
      _lastScrollOffset = currentScrollOffset;
    }
  }

  void _hideAppBar() {
    if (_isAppBarVisible) {
      setState(() => _isAppBarVisible = false);
      _appBarAnimationController.forward();
    }
  }

  void _showAppBar() {
    if (!_isAppBarVisible) {
      setState(() => _isAppBarVisible = true);
      _appBarAnimationController.reverse();
    }
  }

  void _toggleSidebar() {
    setState(() {
      _isSidebarOpen = !_isSidebarOpen;
    });
  }

  void _closeSidebar() {
    setState(() {
      _isSidebarOpen = false;
    });
  }

  void _onFeatureSelected(AppFeature feature) {
    setState(() {
      _currentFeature = feature;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _appBarAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SakuraBackground(
          child: DesktopLayout(
            child: GestureDetector(
              onHorizontalDragUpdate: (details) {
                // Handle swipe to open sidebar
                if (details.delta.dx > 5 && !_isSidebarOpen) {
                  _toggleSidebar();
                }
              },
              child: Stack(
                children: [
                  // Main content - takes full screen
                  Positioned.fill(
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: kToolbarHeight + 24, // Add top padding for app bar
                        left: 24,
                        right: 24,
                        bottom: 24,
                      ),
                      child: _buildCurrentPage(),
                    ),
                  ),
            
                  // Floating app bar - overlays content
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: SlideTransition(
                      position: _appBarOffsetAnimation,
                      child: Container(
                        height: kToolbarHeight,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border(
                            bottom: BorderSide(color: AppColors.borderGray, width: 1),
                          ),
                        ),
                        child: SafeArea(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                IconButton(
                                  onPressed: _toggleSidebar,
                                  icon: Icon(
                                    Icons.menu,
                                    color: AppColors.primary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Image.asset(
                                  'assets/images/logo_small.png',
                                  height: 32,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Sakura Connect',
                                  style: AppTextStyles.heroTitle().copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            
                  // Sidebar
                  AppSidebar(
                    isOpen: _isSidebarOpen,
                    onClose: _closeSidebar,
                    onFeatureSelected: _onFeatureSelected,
                    currentFeature: _currentFeature,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

  Widget _buildCurrentPage() {
    switch (_currentFeature) {
      case AppFeature.downloader:
        return const DownloaderPage();
      case AppFeature.queue:
        return const QueuePage();
      case AppFeature.setup:
        return const SetupPage();
      case AppFeature.about:
        return const AboutPage();
    }
  }
} 