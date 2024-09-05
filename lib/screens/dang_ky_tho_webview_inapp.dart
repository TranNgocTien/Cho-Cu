import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';

// #docregion platform_imports
// Import for Android features.
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;

// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

//Import android choose image

class DangKyThoWebView extends StatefulWidget {
  const DangKyThoWebView({super.key, required this.url});
  final String url;
  @override
  State<DangKyThoWebView> createState() => _DangKyThoWebViewState();
}

class _DangKyThoWebViewState extends State<DangKyThoWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // if (Platform.isAndroid) {
    //   // or: if (webViewController.platform is AndroidWebViewController)
    //   final myAndroidController =
    //       _controller.platform as AndroidWebViewController;

    //   myAndroidController.setOnShowFileSelector((params) async {
    //     // Control and show your picker
    //     // and return a list of Uris.

    //     return []; // Uris
    //   });
    // }
    // #docregion platform_features
    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);
    // #enddocregion platform_features

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          // onProgress: (int progress) {
          //   debugPrint('WebView is loading (progress : $progress%)');
          // },
          // onPageStarted: (String url) {
          //   debugPrint('Page started loading: $url');
          // },
          // onPageFinished: (String url) {
          //   debugPrint('Page finished loading: $url');
          // },
          onWebResourceError: (WebResourceError error) {
            debugPrint('''
Page resource error:
  code: ${error.errorCode}
  description: ${error.description}
  errorType: ${error.errorType}
  isForMainFrame: ${error.isForMainFrame}
          ''');
          },
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              debugPrint('blocking navigation to ${request.url}');
              return NavigationDecision.prevent;
            }
            debugPrint('allowing navigation to ${request.url}');
            return NavigationDecision.navigate;
          },
          onHttpError: (HttpResponseError error) {
            debugPrint('Error occurred on page: ${error.response?.statusCode}');
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
          onHttpAuthRequest: (HttpAuthRequest request) {},
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse(widget.url));

    // #docregion platform_features
    if (controller.platform
        is webview_flutter_android.AndroidWebViewController) {
      webview_flutter_android.AndroidWebViewController.enableDebugging(true);

      (controller.platform as webview_flutter_android.AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }
    // #enddocregion platform_features

    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      final WebKitWebViewController webKitController =
          controller.platform as WebKitWebViewController;
    } else if (WebViewPlatform.instance
        is webview_flutter_android.AndroidWebViewPlatform) {
      final webview_flutter_android.AndroidWebViewController androidController =
          controller.platform
              as webview_flutter_android.AndroidWebViewController;
    }
    _controller = controller;
    initFilePicker();
  }

  initFilePicker() async {
    if (Platform.isAndroid) {
      final androidController = (_controller.platform
          as webview_flutter_android.AndroidWebViewController);
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  Future<List<String>> _androidFilePicker(
      webview_flutter_android.FileSelectorParams params) async {
    try {
      if (params.mode == webview_flutter_android.FileSelectorMode.open) {
        final attachments =
            await FilePicker.platform.pickFiles(allowMultiple: false);
        if (attachments == null) return [];

        return attachments.files
            .where((element) => element.path != null)
            .map((e) => File(e.path!).uri.toString())
            .toList();
      } else {
        final attachment = await FilePicker.platform.pickFiles();
        if (attachment == null) return [];
        File file = File(attachment.files.single.path!);
        return [file.uri.toString()];
      }
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final widthDevice = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 60.0,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Color.fromRGBO(39, 166, 82, 1),
                  Color.fromRGBO(1, 142, 33, 1),
                  Color.fromRGBO(23, 162, 73, 1),
                  Color.fromRGBO(84, 181, 111, 1),
                ],
              ),
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          title: Text(
            'Đăng ký thợ',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: GoogleFonts.poppins().fontFamily,
                color: Colors.white,
                fontSize: widthDevice * 0.055),
            textAlign: TextAlign.center,
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          // foregroundq
          //Color: Color.fromRGBO(54, 92, 69, 1),
          elevation: 3,
        ),
        body: WebViewWidget(controller: _controller));
  }
}
