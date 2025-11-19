import 'package:flutter/material.dart';
import 'package:jieba_flutter/analysis/jieba_segmenter.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async{
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'zAz',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _buf = TextEditingController();
  String text = "";
  late JiebaSegmenter seg;
  @override
  void initState() {
    super.initState();
    seg = JiebaSegmenter();
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      while(true){
        var status = await Permission.manageExternalStorage.status;
        if(status.isGranted){
          break;
        }else{
          var p = await Permission.manageExternalStorage.request();
          if(p.isGranted){
            break;
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    TextPainter p  = TextPainter(
      text: TextSpan(
        text: "ahq",
        style: TextStyle(fontSize: 14.0)
      ),
      textDirection: TextDirection.ltr
    )..layout();
    final m = p.height;
    final h = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: TextField(
              controller: _buf,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0)
                )
              ),
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
              maxLines: (h/(2 * m)).ceil(),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: (){
                      var list = seg.process(_buf.text, SegMode.SEARCH);
                      text = list.map((token) => token.word).join("\n");
                    },
                    child: Text("<< Segment >>", style: TextStyle(color: Color(0xff3a4cdd)),)
                )
              ],
            ),
            Expanded(child: SingleChildScrollView(
              child: Text(text),
            ))
          ],
        ),
      )
    );
  }
}
