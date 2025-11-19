import 'package:flutter/material.dart';
import '../util/app_colors.dart';
import '../util/size_config.dart';
import 'icon_button.dart';

enum ImageContainerSize { big, small }

class ImageContainer extends StatelessWidget {
  final String? imageUrl;
  final ImageContainerSize size;

  const ImageContainer({
    Key? key,
    required this.imageUrl,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dimension = size == ImageContainerSize.big
        ? SizeConfig.responsiveWidth(100)
        : SizeConfig.responsiveWidth(60);

    return GestureDetector(
      onTap: () {
        if (imageUrl != null && imageUrl!.isNotEmpty) {
          _showFullScreenImage(context);
        }
      },
      child: Container(
        width: dimension,
        height: dimension,
        decoration: BoxDecoration(
          color: AppColors.lightgray,
          borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(10)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(SizeConfig.responsiveWidth(10)),
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
                  imageUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return _buildPlaceholder();
                  },
                )
              : _buildPlaceholder(),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Icon(
        Icons.image,
        color: AppColors.darkgray,
        size: size == ImageContainerSize.big
            ? SizeConfig.responsiveWidth(40)
            : SizeConfig.responsiveWidth(24),
      ),
    );
  }

  void _showFullScreenImage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          backgroundColor: AppColors.black,
          body: Stack(
            children: [
              SizedBox.expand(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: CustomIconButton(
                      icon: Icons.close,
                      onTap: () => Navigator.of(context).pop(),
                      iconColor: AppColors.black,
                      backgroundColor: AppColors.white.withOpacity(0.9),
                      size: 40,
                      isCircle: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
