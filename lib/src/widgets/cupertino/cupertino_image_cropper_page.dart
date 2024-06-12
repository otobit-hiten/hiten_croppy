import 'package:croppy/src/src.dart';
import 'package:croppy/src/widgets/cupertino/cupertino_image_cropper_app_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const kCupertinoImageCropperBackgroundColor = Color(0xFF0A0A0A);

class CupertinoImageCropperPage extends StatelessWidget {
  const CupertinoImageCropperPage({
    super.key,
    required this.controller,
    required this.shouldPopAfterCrop,
    this.gesturePadding = 16.0,
    this.heroTag,
  });

  final CroppableImageController controller;
  final double gesturePadding;
  final Object? heroTag;
  final bool shouldPopAfterCrop;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: kCupertinoImageCropperBackgroundColor,
        statusBarBrightness: Brightness.dark,
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: CroppableImagePageAnimator(
        controller: controller,
        heroTag: heroTag,
        builder: (context, overlayOpacityAnimation) {
          return CupertinoPageScaffold(
            backgroundColor: kCupertinoImageCropperBackgroundColor,
            navigationBar: CupertinoImageCropperAppBar(
              controller: controller,
            ),
            child: SafeArea(
              top: false,
              bottom: true,
              minimum: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: RepaintBoundary(
                      child: AnimatedCroppableImageViewport(
                        controller: controller,
                        overlayOpacityAnimation: overlayOpacityAnimation,
                        gesturePadding: gesturePadding,
                        heroTag: heroTag,
                        cropHandlesBuilder: (context) =>
                            CupertinoImageCropHandles(
                          controller: controller,
                          gesturePadding: gesturePadding,
                        ),
                      ),
                    ),
                  ),
                  if (controller is CupertinoCroppableImageController &&
                      (controller as CupertinoCroppableImageController)
                              .allowedAspectRatios
                              .length >
                          1)
                    ValueListenableBuilder(
                      valueListenable:
                          (controller as CupertinoCroppableImageController)
                              .toolbarNotifier,
                      builder: (context, toolbar, _) => CupertinoButton(
                        onPressed: () {
                          // ignore: no_leading_underscores_for_local_identifiers
                          final _controller =
                              controller as CupertinoCroppableImageController;

                          _controller.toggleToolbar(
                            CupertinoCroppableImageToolbar.aspectRatio,
                          );
                        },
                        minSize: 44.0,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 10.0,
                        ),
                        child: Text("Crop",
                            style: TextStyle(
                              color: toolbar ==
                                      CupertinoCroppableImageToolbar.aspectRatio
                                  ? CupertinoColors.white
                                  : CupertinoColors.systemGrey2,
                            )),
                      ),
                    ),
                  RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: overlayOpacityAnimation,
                      builder: (context, _) => Opacity(
                        opacity: overlayOpacityAnimation.value,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 96.0,
                              child: CupertinoToolbar(
                                controller: controller,
                              ),
                            ),
                            CupertinoImageCropperBottomAppBar(
                              controller: controller,
                              shouldPopAfterCrop: shouldPopAfterCrop,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
