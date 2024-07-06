import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.yellow.shade50),
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends HookWidget {
  HomeScreen({Key? key});


  final ScrollController scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    // we use it to change the screens
    var selectedItem = useState<int>(0);

    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.

        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        // title: Text(widget.title),


      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedIconTheme: IconThemeData(color: Colors.purple),
        selectedItemColor: Colors.purple,
        onTap: (index) {
          selectedItem.value = index;
        },
        currentIndex: selectedItem.value,
        items: [
          //HomeScreen BottomNavigationBarItem
          //Not a Screen/Page
          BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.home,color: Color.fromRGBO(38, 38, 38, 0.4),),
              onPressed: () {
                if (selectedItem.value == 0) {
                  //checked whether we can communicate with the members of ScrollController
                  if (scrollController.hasClients) {
                    // basically gives us 0.1 which is first item of the listView.
                    final position =
                        scrollController.position.minScrollExtent;
                    scrollController.animateTo(
                      //duration of scrolling up
                      duration: Duration(milliseconds: 400),
                      position,
                      //animation style
                      curve: Curves.linear,
                    );
                  }
                } else {
                  selectedItem.value = 0;
                }
              },
            ),
            label: 'Home',
          ),
          //GroupScreen BottomNavigationBarItem
          //Not a Screen/Page
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop,color: Color.fromRGBO(38, 38, 38, 0.4),),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_box, color: Color.fromRGBO(38, 38, 38, 0.4),),
            label: 'Add Review',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle, color: Color.fromRGBO(38, 38, 38, 0.4),),
            label: 'Profile',
          ),
        ],
      ),
        body: ListView(

          padding: const EdgeInsets.symmetric(horizontal: 8),

          children: <Widget>[

            Container(
             // // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User A - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),

                    ExpandableText(text: 'All human beings are born free and equal in dignity and rights. They are endowed with reason and conscience and should act towards one another in a spirit of brotherhood.'),
                  ],
                ),
              ),
            ),

            Divider(),
            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User B - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone is entitled to all the rights and freedoms set forth in this Declaration, without distinction of any kind, such as race, colour, sex, language, religion, political or other opinion, national or social origin, property, birth or other status. Furthermore, no distinction shall be made on the basis of the political, jurisdictional or international status of the country or territory to which a person belongs, whether it be independent, trust, non-self-governing or under any other limitation of sovereignty.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User C - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image(
                      image: AssetImage('assets/images/test-photo.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    ExpandableText(text: 'Everyone has the right to life, liberty and security of person.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User D - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'No one shall be held in slavery or servitude; slavery and the slave trade shall be prohibited in all their forms.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User E - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'No one shall be subjected to torture or to cruel, inhuman or degrading treatment or punishment.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User F - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone has the right to recognition everywhere as a person before the law.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User G - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'All are equal before the law and are entitled without any discrimination to equal protection of the law. All are entitled to equal protection against any discrimination in violation of this Declaration and against any incitement to such discrimination.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User H - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone has the right to an effective remedy by the competent national tribunals for acts violating the fundamental rights granted him by the constitution or by law.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User I - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'No one shall be subjected to arbitrary arrest, detention or exile.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User J - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone is entitled in full equality to a fair and public hearing by an independent and impartial tribunal, in the determination of his rights and obligations and of any criminal charge against him.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User K - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone charged with a penal offence has the right to be presumed innocent until proved guilty according to law in a public trial at which he has had all the guarantees necessary for his defence.No one shall be held guilty of any penal offence on account of any act or omission which did not constitute a penal offence, under national or international law, at the time when it was committed. Nor shall a heavier penalty be imposed than the one that was applicable at the time the penal offence was committed.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User L - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'No one shall be subjected to arbitrary interference with his privacy, family, home or correspondence, nor to attacks upon his honour and reputation. Everyone has the right to the protection of the law against such interference or attacks.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User M - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone has the right to freedom of movement and residence within the borders of each state.Everyone has the right to leave any country, including his own, and to return to his country.'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User N - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone has the right to seek and to enjoy in other countries asylum from persecution.This right may not be invoked in the case of prosecutions genuinely arising from non-political crimes or from acts contrary to the purposes and principles of the United Nations'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User O - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone has the right to a nationality.No one shall be arbitrarily deprived of his nationality nor denied the right to change his nationality'),
                  ],
                ),
              ),
            ),
            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User P - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Men and women of full age, without any limitation due to race, nationality or religion, have the right to marry and to found a family. They are entitled to equal rights as to marriage, during marriage and at its dissolution.Marriage shall be entered into only with the free and full consent of the intending spouses.The family is the natural and fundamental group unit of society and is entitled to protection by society and the State.'),
                  ],
                ),
              ),
            ),

            Divider(),

            Container(
              // height: 700,
              width: 468,
              color: Colors.amber[100],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [

                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        child: Text(
                          'User Q - Time',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Image.asset('assets/images/test-photo.png'),
                    ),
                    ExpandableText(text: 'Everyone has the right to own property alone as well as in association with others.No one shall be arbitrarily deprived of his property.'),
                  ],
                ),
              ),
            ),
            ],

        ),
        );
     // );
  }
}

class ExpandableText extends StatefulWidget {
  final String text;

  ExpandableText({required this.text});
  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  bool _expanded = false;

  void toggleExpanded() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpanded,
      child: AnimatedCrossFade(
        duration: Duration(milliseconds: 300),
        crossFadeState: _expanded
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstChild: Text(
          widget.text,
        ),
        secondChild: Text(
          widget.text,
          maxLines: _expanded ? null : 4,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
}
