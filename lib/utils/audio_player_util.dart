import 'package:audioplayers/audioplayers.dart';


class AudioPlayerUtil {
final AudioPlayer _player = AudioPlayer();


Future<void> playAsset(String assetPath) async {
try {
await _player.stop();
// For audioplayers 2.x, use AudioPlayer.play with AssetSource
await _player.play(AssetSource(assetPath.replaceFirst('assets/', '')));
} catch (e) {
// ignore or log
print('Audio play error: \$e');
}
}


void dispose() {
_player.dispose();
}
}