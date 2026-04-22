import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fitness_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:fitness_app/core/extension/context_extention.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const VideoPlayerScreen({
    super.key,
    required this.videoUrl,
    required this.title,
  });

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> with WidgetsBindingObserver {
  late YoutubePlayerController _controller;
  bool _isOffline = false;
  bool _isInitialized = false;
  bool _hasError = false;

  StreamSubscription<List<ConnectivityResult>>? _connectionSubscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkInitialConnection();
    _startListeningToNetwork();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_isOffline && !_hasError && _isInitialized) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
        _controller.pause();
      }
    }
  }

  void _startListeningToNetwork() {
    _connectionSubscription = Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final isConnected = !results.contains(ConnectivityResult.none);
      if (isConnected && _isOffline) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            setState(() {
              _isInitialized = false;
            });
            _initPlayer();
          }
        });
      } else if (!isConnected && !_isOffline) {
        if (mounted) {
          setState(() {
            _isOffline = true;
          });
        }
      }
    });
  }

  Future<void> _checkInitialConnection() async {
    final results = await Connectivity().checkConnectivity();
    final hasConnection = !results.contains(ConnectivityResult.none);
    if (!hasConnection) {
      setState(() {
        _isOffline = true;
        _isInitialized = true;
      });
    } else {
      _initPlayer();
    }
  }

  void _initPlayer() {
    try {
    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId == null) {
      if (mounted) setState(() { _hasError = true; _isInitialized = true; });
      return;
    }
  } catch (_) {
    if (mounted) setState(() { _hasError = true; _isInitialized = true; });
  }

    final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
    if (videoId != null) {
      _controller = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
          forceHD: true,
        ),
      );
      setState(() {
        _isOffline = false;
        _isInitialized = true;
        _hasError = false;
      });
    } else {
      setState(() {
        _hasError = true;
        _isInitialized = true;
      });
    }
  }

  @override
  void deactivate() {
    if (!_isOffline && !_hasError && _isInitialized) _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _connectionSubscription?.cancel();
    if (!_isOffline && !_hasError && _isInitialized) _controller.dispose();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title, style: const TextStyle(fontSize: 16, color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _hasError
          ? Center(
              child: Text(context.l10n.invalidVideoUrl, style: const TextStyle(color: Colors.white)),
            )
          : _isOffline
              ? OfflineStateWidget(
                  onRetry: () {
                    setState(() => _isInitialized = false);
                    _checkInitialConnection();
                  },
                )
              : PlayerStateWidget(
                  controller: _controller,
                  title: widget.title,
                ),
    );
  }
}

class OfflineStateWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const OfflineStateWidget({
    super.key,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off_rounded, color: AppColors.primary, size: 64),
          const SizedBox(height: 16),
          Text(
            context.l10n.noInternetConnection,
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            context.l10n.pleaseCheckNetworkToWatch,
            style: const TextStyle(color: AppColors.light400),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: onRetry,
            child: Text(context.l10n.retryButton, style: const TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class PlayerStateWidget extends StatelessWidget {
  final YoutubePlayerController controller;
  final String title;

  const PlayerStateWidget({
    super.key,
    required this.controller,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: AppColors.primary,
        progressColors: const ProgressBarColors(
          playedColor: AppColors.primary,
          handleColor: AppColors.primary,
        ),
      ),
      builder: (context, player) => Column(
        children: [
          player,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Divider(color: AppColors.grayMid),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
