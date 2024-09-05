import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:webview_flutter/webview_flutter.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_android/webview_flutter_android.dart'
    as webview_flutter_android;
import 'package:image_picker/image_picker.dart' as image_picker;

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
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {},
        onPageStarted: (String url) {},
        onPageFinished: (String url) {},
        onWebResourceError: (WebResourceError error) {},
      ))
      ..loadRequest(Uri.parse(widget.url));

    initFilePicker();
  }

  initFilePicker() async {
    if (Platform.isAndroid) {
      final androidController = (_controller.platform
          as webview_flutter_android.AndroidWebViewController);
      await androidController.setOnShowFileSelector(_androidFilePicker);
    }
  }

  /// This method is called when the user tries to upload a file from the webview.
  /// It will open the file picker and return the selected files.
  /// If the user cancels the file picker, it will return an empty list.
  ///
  /// Returns uri's of the selected files.
  Future<List<String>> _androidFilePicker(
      webview_flutter_android.FileSelectorParams params) async {
    if (params.acceptTypes.any((type) => type == 'image/*')) {
      final picker = image_picker.ImagePicker();
      final photo =
          await picker.pickImage(source: image_picker.ImageSource.camera);

      if (photo == null) {
        return [];
      }
      return [Uri.file(photo.path).toString()];
    } else if (params.acceptTypes.any((type) => type == 'video/*')) {
      final picker = image_picker.ImagePicker();
      final vidFile = await picker.pickVideo(
          source: ImageSource.camera, maxDuration: const Duration(seconds: 10));
      if (vidFile == null) {
        return [];
      }
      return [Uri.file(vidFile.path).toString()];
    } else {
      try {
        if (params.mode ==
            webview_flutter_android.FileSelectorMode.openMultiple) {
          final attachments =
              await FilePicker.platform.pickFiles(allowMultiple: true);
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
      body: WebViewWidget(controller: _controller),
    );
  }
}
