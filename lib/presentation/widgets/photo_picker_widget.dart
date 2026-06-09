import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../core/theme/app_colors.dart';

/// Controller để truy cập danh sách ảnh đã chọn từ bên ngoài widget.
class PhotoPickerController extends ChangeNotifier {
  final List<XFile> _photos = [];

  List<XFile> get photos => List.unmodifiable(_photos);

  void addPhoto(XFile photo) {
    _photos.add(photo);
    notifyListeners();
  }

  void removePhoto(int index) {
    _photos.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _photos.clear();
    notifyListeners();
  }

  bool get hasPhotos => _photos.isNotEmpty;

  /// Lấy danh sách File từ XFile
  List<File> get files => _photos.map((x) => File(x.path)).toList();
}

class PhotoPickerWidget extends StatefulWidget {
  /// Controller bên ngoài truyền vào để mixin có thể đọc danh sách ảnh.
  final PhotoPickerController? controller;

  const PhotoPickerWidget({super.key, this.controller});

  @override
  State<PhotoPickerWidget> createState() => _PhotoPickerWidgetState();
}

class _PhotoPickerWidgetState extends State<PhotoPickerWidget> {
  final ImagePicker _picker = ImagePicker();

  PhotoPickerController get _ctrl => widget.controller ?? _internalCtrl;

  late final PhotoPickerController _internalCtrl = PhotoPickerController();

  @override
  void dispose() {
    // Chỉ dispose internal controller (controller từ bên ngoài do parent quản lý)
    if (widget.controller == null) {
      _internalCtrl.dispose();
    }
    super.dispose();
  }

  // Future<void> _takePhoto() async {
  //   try {
  //     final XFile? photo = await _picker.pickImage(source: ImageSource.camera, );
  //     if (photo != null) {
  //       _ctrl.addPhoto(photo);
  //       setState(() {});
  //     }
  //   } catch (e) {
  //     debugPrint('Error taking photo: $e');
  //   }
  // }
  Future<void> _takePhoto() async {
    try {
      debugPrint('Open camera');

      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 20,
        maxWidth: 800,
        maxHeight: 800,
      );

      debugPrint('Photo selected');

      if (photo != null) {
        final file = File(photo.path);

        debugPrint(
          'Size: ${(await file.length() / 1024).toStringAsFixed(0)} KB',
        );

        _ctrl.addPhoto(photo);

        if (mounted) {
          setState(() {});
        }
      }
    } catch (e, s) {
      debugPrint('ERROR PHOTO');
      debugPrint(e.toString());
      debugPrint(s.toString());
    }
  }

  void _removePhoto(int index) {
    _ctrl.removePhoto(index);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final photos = _ctrl.photos;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (photos.isNotEmpty)
          SizedBox(
            height: 100,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: photos.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                return Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: FileImage(File(photos[index].path)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: GestureDetector(
                        onTap: () => _removePhoto(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        if (photos.isNotEmpty) const SizedBox(height: 12),
        GestureDetector(
          onTap: _takePhoto,
          child: DottedBorder(
            options: RoundedRectDottedBorderOptions(
              color: AppColors.cardBorder,
              strokeWidth: 1.5,
              dashPattern: const [6, 4],
              radius: const Radius.circular(12),
            ),
            child: Container(
              height: photos.isEmpty ? 160 : 60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add_a_photo,
                      color: AppColors.textTertiary,
                      size: 24,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
