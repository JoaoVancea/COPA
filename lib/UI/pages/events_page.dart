import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({super.key});

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size(double.infinity, 110),
          child: Stack(children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF40CEF2)
              ),
            ),
            Container(
              height: double.infinity,
              decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF4960F9), Color(0xFF1937FE)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(50)
              ), 
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SvgPicture.asset('chat.svg'),
                  SvgPicture.asset('search.svg')
                ],
              ),
            )
            ),
          ])),
    );
  }
}
