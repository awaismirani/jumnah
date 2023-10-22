import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewExampleScreen extends StatefulWidget {

  String url;


  @override
  _WebviewExampleScreenState createState() => _WebviewExampleScreenState();

  WebviewExampleScreen({
    required this.url,
  });
}
WebViewController _webViewController = WebViewController();

class _WebviewExampleScreenState extends State<WebviewExampleScreen> {
  bool bac = false;
  bool far = false;
  final _key = UniqueKey();
  bool isLoading = false;
  Color bacColor = Colors.black;
  void _openWhatsAppChatWithPerson(String url) async {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  }

  @override
  void initState() {
    _webViewController = WebViewController()
      ..enableZoom(false)
      ..loadRequest(Uri.parse(widget.url))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent("Chrome/81.0.0.0 Mobile",)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int value) {
            print('progress ...........'+value.toString());
            setState(() {
              var progress = value;
              if (progress == 80) {
                setState(() {
                  isLoading = false;
                });
              }
            });
            debugPrint('WebView is loading (progress : $value%)');
          },
          onPageStarted: (String url) {
            setState(() {
              isLoading = true;
            });

          },
          onPageFinished: (String url) {
            setState(() async {
              isLoading = false;
              if (await _webViewController.canGoBack()) {
                setState(() {
                  bac = true;
                });
              } else {
                bac = false;
              }
              if (await _webViewController.canGoForward()) {
                setState(() {
                  far = true;
                });
              } else {
                far = false;
              }
            });
            debugPrint('Page finished loading: $url');
          },
          onWebResourceError: (WebResourceError error) {
            setState(() {
              isLoading = false;
            });
          },
          onNavigationRequest: (NavigationRequest request)async {
            //////////////////////////////
            ////// if you want any external links to be opened
            ///// outside the app in a browser uncomment this code..
            ////////////////////////////

            // bool nav = true;
            // if (request.url.contains("sewamahe")) {
            //   setState(() {
            //     // controller1.update();
            //     nav = true;
            //   });
            // }
            // else {
            //   bool confirm = await showDialog(
            //     context: context,
            //     builder: (context) => AlertDialog(
            //       title: Text('Are you sure?'),
            //       content: Text('Do you want to exit the app and open the link in a browser?'),
            //       actions: <Widget>[
            //         TextButton(
            //           onPressed: () => Navigator.of(context).pop(false),
            //           child: Text('No'),
            //         ),
            //         TextButton(
            //           onPressed: () => Navigator.of(context).pop(true),
            //           child: Text('Yes'),
            //         ),
            //       ],
            //     ),
            //   );
            //   if (confirm) {
            //     await launchUrl(Uri.parse(request.url));
            //     SystemNavigator.pop();
            //   }
            // }
            // return nav ? NavigationDecision.navigate : NavigationDecision.prevent;
            if (request.url.contains('tel:')) {
              if (!await launchUrl(Uri.parse(request.url))) {
                throw Exception('Could not launch ${request.url}');
              }
              return NavigationDecision.prevent;
            }
            if (request.url.startsWith('https://api.whatsapp.com')) {
              _openWhatsAppChatWithPerson(request.url);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;

            //// uncomment above code and comment above line..////
          },
          onUrlChange: (UrlChange change) {
            debugPrint('url change to ${change.url}');
          },
        ),
      );
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:Stack(
            children: [
              WillPopScope(
                onWillPop: () async {
                  if (await _webViewController.canGoBack()) {
                    _webViewController.goBack();
                    return false;
                  }
                  return true;
                },
                child: WebViewWidget(
                  key: _key,

                  controller:_webViewController,

                ),
              ),
              Visibility(
                visible: isLoading,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.grey[100],
                  child: Shimmer.fromColors(
                    baseColor: Colors.black12,
                    highlightColor:  Colors.white10,
                    enabled: isLoading,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 50,
                                  width: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle
                                  ),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 20,
                                      width: MediaQuery.of(context).size.width-100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Container(
                                      height: 20,
                                      margin: EdgeInsets.symmetric(vertical: 10),
                                      width: MediaQuery.of(context).size.width-200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width-40,
                                  height: 20,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  width: MediaQuery.of(context).size.width-100,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                Container(
                                  height: 20,
                                  margin: EdgeInsets.symmetric(vertical: 10),
                                  width: MediaQuery.of(context).size.width-200,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 150,
                            margin: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
