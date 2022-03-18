import 'dart:async';
import 'dart:html';
import 'package:numberpicker/numberpicker.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int hour = 0;
  int min = 0;
  int sec = 0;
  bool started = true;
  bool stopped = true;
  int timeForTimer = 0;
  String timeToDisplay = "";
  bool checkTimer = true;
  //create Tabcontroller class
  TabController? tb;

  @override
  void initState() {
    //initialize the variable tb
    tb = TabController(length: 1, vsync: this);
    super.initState();
  }

  void start() {
    setState(() {
      // to make the start button invalid after first click
      started = false;
      stopped = false;
    });
    //calculate the time that the timer will have to run in seconds in timefortimer
    timeForTimer = ((hour * 60 * 60) + (min * 60) + sec);
    debugPrint(timeForTimer.toString());

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        //to cancel the timer once it reaches 0 secs
        if (timeForTimer < 1 || checkTimer == false) {
          timer.cancel();
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomePage()));
          // checkTimer = true;
          // timeToDisplay = "";
          // started = false;
          // stopped = false;
        } else if (timeForTimer < 60) {
          timeToDisplay = timeForTimer.toString();
          timeForTimer = timeForTimer - 1;
        } else if (timeForTimer < 3600) {
          int m = timeForTimer ~/ 60;
          int s = timeForTimer - (60 * m);
          timeToDisplay = m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        } else {
          int h = timeForTimer ~/ 3600;
          int t = timeForTimer - (3600 * h);
          int m = t ~/ 60;
          int s = t - (60 * m);
          timeToDisplay =
              h.toString() + ":" + m.toString() + ":" + s.toString();
          timeForTimer = timeForTimer - 1;
        }
        timeToDisplay = timeForTimer.toString();
        // else {

        //   // to continually decrease the timer till it gets to 0
        //   timeForTimer = timeForTimer - 1;
        // }
        // timeToDisplay = timeForTimer.toString();
      });
    });
  }

  void end() {
    setState(() {
      started = true;
      stopped = true;
      checkTimer = false;
    });
  }

  Widget timer() {
    return Container(
      child: Column(
        children: [
          Expanded(
              flex: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('HH'),
                      //import number picker from pub.dev
                      NumberPicker(
                          minValue: 0,
                          maxValue: 23,
                          value: hour,
                          onChanged: (val) {
                            setState(() {
                              //if you say val = hour it will go back to 0 because hour has been initialized as 0
                              hour = val;
                            });
                          })
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('MIN'),
                      //import number picker from pub.dev
                      NumberPicker(
                          minValue: 0,
                          maxValue: 60,
                          value: min,
                          onChanged: (val) {
                            setState(() {
                              //if you say val = hour it will go back to 0 because hour has been initialized as 0
                              min = val;
                            }); 
                          })
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('SEC'),
                      //import number picker from pub.dev
                      NumberPicker(
                          minValue: 0,
                          maxValue: 60,
                          value: sec,
                          onChanged: (val) {
                            setState(() {
                              //if you say val = hour it will go back to 0 because hour has been initialized as 0
                              sec = val;
                            });
                          })
                    ],
                  )
                ],
              )),
          Expanded(flex: 1, child: Text(timeToDisplay)),
          Expanded(
              flex: 3,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: started ? start : null, child: Text('START')),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                      onPressed: stopped ? null : end, child: Text('STOP')),
                ],
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xff64B6AC),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          /*make app bar transparent */
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'TIMER',
            style: TextStyle(
                fontFamily: 'Gilroy',
                fontWeight: FontWeight.bold,
                fontSize: 40),
          ),
          bottom: TabBar(
              indicatorColor: Color.fromARGB(255, 2, 118, 153),
              tabs: <Widget>[
                Text('Timer'),
              ],
              controller: tb),
        ),
        body: TabBarView(
            children: <Widget>[
              timer(),
            ],
            //place the initialized controller tb in the TabBar
            controller: tb));
  }
}
