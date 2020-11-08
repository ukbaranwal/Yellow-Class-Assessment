import 'package:camera/camera.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:yellow_class_video_app/ui/video_player_widgets.dart';
import 'package:yellow_class_video_app/util/custom_toast.dart';

class VideoPlayer extends StatefulWidget {
  final String videoUrl;

  VideoPlayer(this.videoUrl);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  FlickManager flickManager;
  List<CameraDescription> cameras;
  CameraController controller;
  bool isCameraAvailable = false;

  void initializeCamera() async {
    cameras = await availableCameras();
    controller = CameraController(
        cameras.length == 2 ? cameras[1] : cameras[0], ResolutionPreset.medium);
    try {
      await controller.initialize();
      setState(() {
        isCameraAvailable = true;
      });
    } catch (e) {
      if (e is CameraException) {
        CustomToast.show("Permission Denied", context);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    flickManager = FlickManager(
      videoPlayerController: VideoPlayerController.network(widget.videoUrl),
    );
    initializeCamera();
  }

  @override
  void dispose() {
    flickManager?.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          alignment: Alignment.bottomRight,
          children: [
            FlickVideoPlayer(
              flickManager: flickManager,
              preferredDeviceOrientationFullscreen: [
                DeviceOrientation.landscapeLeft
              ],
              preferredDeviceOrientation: [DeviceOrientation.landscapeLeft],
              flickVideoWithControlsFullscreen: FlickVideoWithControls(
                controls: FlickPortraitCustomControls(),
              ),
              flickVideoWithControls: FlickVideoWithControls(
                controls: FlickPortraitCustomControls(),
              ),
              cameraView: isCameraAvailable
                  ? FrontCameraMovable(
                      RotatedBox(
                        quarterTurns: 3,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: AspectRatio(
                            aspectRatio: controller.value.aspectRatio,
                            child: CameraPreview(controller),
                          ),
                        ),
                      ),
                    )
                  : SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}

class FlickPortraitCustomControls extends StatelessWidget {
  const FlickPortraitCustomControls({
    Key key,
    this.iconSize = 20,
    this.fontSize = 12,
    this.progressBarSettings,
  }) : super(key: key);

  final double iconSize;

  final double fontSize;

  final FlickProgressBarSettings progressBarSettings;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: FlickShowControlsAction(
            child: FlickSeekVideoAction(
              child: Center(
                child: FlickVideoBuffer(
                  child: FlickAutoHideChild(
                    showIfVideoNotInitialized: false,
                    child: Stack(
                      alignment: Alignment.centerRight,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: UnconstrainedBox(
                            child: FlickPlayToggle(
                              size: 30,
                              color: Colors.black,
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(40),
                              ),
                            ),
                          ),
                        ),
                        VolumeSlider()
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: FlickAutoHideChild(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  FlickVideoProgressBar(
                    flickProgressBarSettings: progressBarSettings,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      FlickPlayToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      FlickSoundToggle(
                        size: iconSize,
                      ),
                      SizedBox(
                        width: iconSize / 2,
                      ),
                      Row(
                        children: <Widget>[
                          FlickCurrentPosition(
                            fontSize: fontSize,
                          ),
                          FlickAutoHideChild(
                            child: Text(
                              ' / ',
                              style: TextStyle(
                                  color: Colors.white, fontSize: fontSize),
                            ),
                          ),
                          FlickTotalDuration(
                            fontSize: fontSize,
                          ),
                        ],
                      ),
                      Expanded(
                        child: Container(),
                      ),
                      FlickFullScreenToggle(
                        size: iconSize,
                      ),
                    ],
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
