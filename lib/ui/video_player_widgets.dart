import 'package:flutter/material.dart';
import 'package:volume/volume.dart';

class FrontCameraMovable extends StatefulWidget {
  final Widget child;

  FrontCameraMovable(this.child);

  @override
  State<StatefulWidget> createState() {
    return _FrontCameraMovableState();
  }
}

class _FrontCameraMovableState extends State<FrontCameraMovable> {
  double xPosition = 20;
  double yPosition = 20;
  double ratio = 720 / 480;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: yPosition,
      right: xPosition,
      child: GestureDetector(
        onPanUpdate: (tapInfo) {
          setState(() {
            xPosition -= tapInfo.delta.dx;
            yPosition -= tapInfo.delta.dy;

            if (xPosition < 0) {
              xPosition = 0;
            } else if ((xPosition +
                    MediaQuery.of(context).size.width * 0.15 * ratio) >
                MediaQuery.of(context).size.width) {
              xPosition = MediaQuery.of(context).size.width -
                  MediaQuery.of(context).size.width * 0.15 * ratio;
            }
            if (yPosition < 0) {
              yPosition = 0;
            } else if (yPosition + MediaQuery.of(context).size.width * 0.15 >
                (MediaQuery.of(context).size.height)) {
              yPosition = MediaQuery.of(context).size.height -
                  MediaQuery.of(context).size.width * 0.15;
            }
          });
        },
        child: Container(
          height: MediaQuery.of(context).size.width * 0.15,
          child: widget.child,
        ),
      ),
    );
  }
}

class VolumeSlider extends StatefulWidget {
  @override
  _VolumeSliderState createState() => _VolumeSliderState();
}

class _VolumeSliderState extends State<VolumeSlider> {
  double _value = 0;
  double _maxValue = 10;

  @override
  void initState() {
    super.initState();
    getVolume();
  }

  setVolume(double value) async {
    setState(() {
      _value = value;
    });
    await Volume.setVol(value.floor(), showVolumeUI: ShowVolumeUI.HIDE);
  }

  void getVolume() async {
    await Volume.controlVolume(AudioManager
        .STREAM_MUSIC); // you can change which volume you want to change.
    int temp = await Volume.getVol;
    int temp2 = await Volume.getMaxVol;
    setState(() {
      _value = temp.toDouble();
      _maxValue = temp2.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: 100,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          activeTrackColor: const Color.fromRGBO(255, 255, 255, 1),
          inactiveTrackColor: const Color.fromRGBO(255, 255, 255, 0.24),
          trackShape: RoundedRectSliderTrackShape(),
          trackHeight: 10.0,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.0),
          thumbColor: Colors.white,
          overlayColor: Colors.white.withAlpha(32),
          overlayShape: RoundSliderOverlayShape(overlayRadius: 20.0),
          valueIndicatorShape: PaddleSliderValueIndicatorShape(),
          valueIndicatorColor: Colors.redAccent,
          valueIndicatorTextStyle: TextStyle(
            color: Colors.white,
          ),
        ),
        child: RotatedBox(
          quarterTurns: 3,
          child: Slider(
            value: _value,
            min: 0,
            max: _maxValue,
            label: '$_value',
            onChanged: (value) {
              setState(
                () {
                  _value = value;
                  setVolume(value);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
