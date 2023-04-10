import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:utube_downloader/pages/home.dart';
import 'package:utube_downloader/utils/var_global.dart';

import 'detail.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController txtCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Image.asset(
                      'assets/img/release.png',
                      height: MediaQuery.of(context).size.height * 0.6,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'Paste your link yt',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'What is your favorite video?',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(15, 0, 15, 0),
              padding: EdgeInsets.only(left: 13, right: 10),
              height: 50,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.grey.shade300.withOpacity(0.7)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Paste link',
                          hintStyle: TextStyle(
                              color: Colors.grey.shade500,
                              fontStyle: FontStyle.italic)),
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(38),
                      ],
                      controller: txtCon,
                      onSubmitted: (value) {
                        VarGlobal.linkUrl = txtCon;

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailPage(),
                        ));
                      },
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.redAccent.withOpacity(0.9),
                    child: IconButton(
                        splashColor: Colors.red,
                        onPressed: () {
                          setState(() {
                            VarGlobal.linkUrl = txtCon;
                          });
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => DetailPage(),
                          ));
                        },
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.white,
                          size: 30,
                        )),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
