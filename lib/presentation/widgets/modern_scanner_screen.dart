import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class ModernScannerScreen extends StatefulWidget {
  final String title;

  const ModernScannerScreen({super.key, this.title = 'Scan QR Code'});

  @override
  State<ModernScannerScreen> createState() => _ModernScannerScreenState();
}

class _ModernScannerScreenState extends State<ModernScannerScreen>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late MobileScannerController _scannerController;
  late AnimationController _animationController;
  late Animation<double> _scanLineAnimation;

  bool _hasPermission = false;
  bool _isCheckingPermission = true;
  bool _isScanned = false; // Prevents multiple scans
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanLineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;
    setState(() {
      _hasPermission = status.isGranted;
      _isCheckingPermission = false;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_hasPermission || !_scannerController.value.isInitialized) return;

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _scannerController.stop();
        break;
      case AppLifecycleState.resumed:
        _scannerController.start();
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _animationController.dispose();
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _toggleTorch() async {
    try {
      await _scannerController.toggleTorch();
      setState(() {
        _isTorchOn = !_isTorchOn;
      });
    } catch (e) {
      debugPrint('Failed to toggle torch: $e');
    }
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isScanned) return;

    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String? code = barcodes.first.rawValue;
      if (code != null) {
        _isScanned = true;
        HapticFeedback.vibrate();
        _scannerController.stop();

        if (mounted) {
          Navigator.of(context).pop(code);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPermission) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    if (!_hasPermission) {
      return _buildPermissionDeniedState();
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Fullscreen Camera
          MobileScanner(
            controller: _scannerController,
            onDetect: _onDetect,
          ),

          // 2. Custom Overlay & Scan Frame
          LayoutBuilder(
            builder: (context, constraints) {
              final double scanWindowSize = constraints.maxWidth * 0.7;
              final Rect scanWindow = Rect.fromCenter(
                center: Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
                width: scanWindowSize,
                height: scanWindowSize,
              );

              return Stack(
                children: [
                  CustomPaint(
                    size: Size(constraints.maxWidth, constraints.maxHeight),
                    painter: _ScannerOverlayPainter(scanWindow: scanWindow),
                  ),
                  
                  // Scan Line Animation
                  AnimatedBuilder(
                    animation: _scanLineAnimation,
                    builder: (context, child) {
                      final topOffset = scanWindow.top + (scanWindow.height * _scanLineAnimation.value);
                      return Positioned(
                        top: topOffset,
                        left: scanWindow.left,
                        width: scanWindow.width,
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(
                            color: Colors.greenAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.greenAccent.withValues(alpha: 0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),

          // 3. UI Controls & Text
          SafeArea(
            child: Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      ),
                      Text(
                        widget.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 48), // Spacer to center title
                    ],
                  ),
                ),
                
                const Spacer(),

                // Instruction Text
                const Text(
                  'Place QR code inside the frame',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Scanning automatically...',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 48),

                // Bottom Controls
                Padding(
                  padding: const EdgeInsets.only(bottom: 48),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildControlButton(
                        icon: Icons.flip_camera_ios,
                        onPressed: () => _scannerController.switchCamera(),
                      ),
                      const SizedBox(width: 32),
                      _buildControlButton(
                        icon: _isTorchOn ? Icons.flash_on : Icons.flash_off,
                        color: _isTorchOn ? Colors.yellow : Colors.white,
                        onPressed: _toggleTorch,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color color = Colors.white,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: color, size: 28),
        padding: const EdgeInsets.all(16),
      ),
    );
  }

  Widget _buildPermissionDeniedState() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.videocam_off, color: Colors.red, size: 48),
              ),
              const SizedBox(height: 16),
              const Text(
                'Camera Access Denied',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Please allow camera permission in settings to scan QR codes.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => openAppSettings(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Open Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScannerOverlayPainter extends CustomPainter {
  final Rect scanWindow;

  _ScannerOverlayPainter({required this.scanWindow});

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height));

    final cutoutPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          scanWindow,
          const Radius.circular(20), // Rounded corners for scanner frame
        ),
      );

    final path = Path.combine(PathOperation.difference, backgroundPath, cutoutPath);

    final overlayPaint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, overlayPaint);

    // Draw scanning frame border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;

    // We can draw corner brackets instead of full rectangle to look more professional
    _drawCornerBrackets(canvas, scanWindow, borderPaint);
  }

  void _drawCornerBrackets(Canvas canvas, Rect rect, Paint paint) {
    const double length = 30.0;
    const double radius = 20.0;

    // Top-Left
    canvas.drawPath(
      Path()
        ..moveTo(rect.left, rect.top + length)
        ..arcToPoint(Offset(rect.left + radius, rect.top), radius: const Radius.circular(radius))
        ..lineTo(rect.left + length, rect.top),
      paint,
    );

    // Top-Right
    canvas.drawPath(
      Path()
        ..moveTo(rect.right - length, rect.top)
        ..arcToPoint(Offset(rect.right, rect.top + radius), radius: const Radius.circular(radius))
        ..lineTo(rect.right, rect.top + length),
      paint,
    );

    // Bottom-Right
    canvas.drawPath(
      Path()
        ..moveTo(rect.right, rect.bottom - length)
        ..arcToPoint(Offset(rect.right - radius, rect.bottom), radius: const Radius.circular(radius))
        ..lineTo(rect.right - length, rect.bottom),
      paint,
    );

    // Bottom-Left
    canvas.drawPath(
      Path()
        ..moveTo(rect.left + length, rect.bottom)
        ..arcToPoint(Offset(rect.left, rect.bottom - radius), radius: const Radius.circular(radius))
        ..lineTo(rect.left, rect.bottom - length),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
