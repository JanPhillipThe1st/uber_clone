import 'package:flutter/material.dart';

class RecentTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RecentTransactionsView();
  }
}

class RecentTransactionsView extends StatefulWidget {
  @override
  _RecentTransactionsViewState createState() => _RecentTransactionsViewState();
}

class _RecentTransactionsViewState extends State<RecentTransactionsView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text("Activity"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.help),
              onPressed: () {},
              color: Colors.white,
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Your Balance",
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "\₱ 150.60",
                      style: TextStyle(
                        fontSize: 34,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                          width: double.infinity,
                          height: 60,
                          margin: EdgeInsets.only(bottom: 10),
                          alignment: FractionalOffset.center,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(const Radius.circular(4.0)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.money,
                                color: Colors.white,
                                size: 40,
                              ),
                              Text('CASH OUT',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24)),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "PAYMENT SCHEDULED: 6/01/2023",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(26),
              width: double.infinity,
              color: Colors.black12,
              child: Text(
                "Posted",
                style: TextStyle(fontSize: 20, color: Colors.black38),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Bajaj",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        "\₱ 150.60",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "May 31, 10:00 AM",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                      Text(
                        "\₱ 150.60",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ));
  }
}
