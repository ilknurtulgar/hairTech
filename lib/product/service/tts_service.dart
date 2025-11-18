import 'dart:io';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:get/get.dart';

class SpeechService {
  Function()? onComplete;
  
  late FlutterTts _flutterTts;
  FlutterTts get flutterTts => _flutterTts;

  RxBool isPlaying = false.obs;
  String _lastText = ""; // Aynı cümleyi tekrar tekrar okumayı engellemek için

  bool get isIOS => Platform.isIOS;
  bool get isAndroid => Platform.isAndroid;

  String language = "tr-TR";
  String? engine;
  double volume = 2.0;
  double pitch = 0.7;
  double rate = 0.75;

  dynamic initTts() async {
    _flutterTts = FlutterTts();
    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
      _getDefaultVoice();
    }

    await flutterTts.setLanguage(language);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setVolume(volume);
    await flutterTts.setPitch(pitch);

    flutterTts.setStartHandler(() {
      // print("Playing");
      isPlaying.value = true;
    });

    flutterTts.setCompletionHandler(() {
      //print("Complete");
      isPlaying.value = false;
      if (onComplete != null) {
        onComplete!();
      }
    });

    flutterTts.setCancelHandler(() {
      //print("Cancel");
      isPlaying.value = false;
    });

    flutterTts.setPauseHandler(() {
      //print("Paused");
      isPlaying.value = false;
    });

    flutterTts.setContinueHandler(() {
      //print("Continued");
      isPlaying.value = true;
    });

    flutterTts.setErrorHandler((msg) {
      //print("error: $msg");
      isPlaying.value = false;
    });
  }

  void disposeService() {
    flutterTts.stop();
  }

  Future speak(String text) async {
    if (isPlaying.value) return;        // Konuşuyorsa yeni konuşma başlatma
    if (text == _lastText) return;      // Aynı cümleyi tekrar söyleme

    _lastText = text;

    await flutterTts.speak(text);
    //isPlaying.value = true;

    /*
    stop(); // Önceki sesi kes
    var result = await flutterTts.speak(text);
    if (result == 1) isPlaying.value = true;
    */
  }

  Future stop() async {
    var result = await flutterTts.stop();
    if (result == 1) isPlaying.value = false;
  }

  Future<void> pause() async {
    var result = await flutterTts.pause();
    if (result == 1) isPlaying.value = false;
  }

  Future<void> _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      //print(engine);
    }
  }

  Future<void> _getDefaultVoice() async {
    var voice = await flutterTts.getDefaultVoice;
    if (voice != null) {
      // print(voice);
    }
  }

  Future<void> _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }
}
