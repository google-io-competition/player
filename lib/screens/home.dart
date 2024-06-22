import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../api/api_service.dart';
import '../palette.dart';
import 'lobby_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _lobbyIdController = TextEditingController();
  final TextEditingController _displayNameController = TextEditingController();

  void _joinLobby() {
    final lobbyId = _lobbyIdController.text;
    final displayName = _displayNameController.text;

    if (lobbyId.isNotEmpty && displayName.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              LobbyScreen(lobbyId: lobbyId, displayName: displayName),
        ),
      );
    } else {
      // Show error if inputs are empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both Lobby ID and Display Name')),
      );
    }
  }

  void _createLobby() async {
    final displayName = _displayNameController.text;

    if (displayName.isNotEmpty) {
      final lobbyId = _generateRandomLobbyId();
      try {
        print('Creating lobby $lobbyId');
        await ApiService().createLobby(lobbyId).then((_) =>
        {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  LobbyScreen(lobbyId: lobbyId, displayName: displayName),
            ),
          )
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create lobby: $e')),
        );
      }
    } else {
      // Show error if display name is empty
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a Display Name')),
      );
    }
  }

  String _generateRandomLobbyId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)])
        .join();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: <Widget>[
            const SizedBox(height: 55),
            SvgPicture.asset('assets/icon.svg', height: 200, width: 150),
            const SizedBox(height: 55),
            Text(
              'PLAY\'r',
              style: TextStyle(
                color: Palette.titleColor,
                fontSize: 60,
                fontWeight: FontWeight.bold,
                fontFamily: 'Itim',
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 55),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'ROOM CODE',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 20,
                  color: Palette.titleColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 7.5),
            TextField(
              controller: _lobbyIdController,
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 20,
                color: Palette.titleColor,
              ),
              decoration: InputDecoration(
                hintText: 'aJ2rT',
                hintStyle: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 20,
                  color: Palette.titleColor.withOpacity(0.5),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.1),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  gapPadding: 1,
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              cursorColor: Colors.white,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'DISPLAY NAME',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 20,
                  color: Palette.titleColor,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            const SizedBox(height: 7.5),
            TextField(
              controller: _displayNameController,
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 20,
                color: Palette.titleColor,
              ),
              decoration: InputDecoration(
                hintText: 'Name',
                hintStyle: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 20,
                  color: Palette.titleColor.withOpacity(0.5),
                ),
                filled: true,
                fillColor: Colors.black.withOpacity(0.1),
                border: const OutlineInputBorder(
                  gapPadding: 1,
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              cursorColor: Colors.white,
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _createLobby,
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
                      fixedSize: WidgetStateProperty.all(
                        Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
                          50,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      foregroundColor:
                      MaterialStateProperty.all(Palette.titleColor),
                    ),
                    child: const Text(
                      'Join Game',
                      style: TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _createLobby,
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
                      fixedSize: WidgetStateProperty.all(
                        Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
                          50,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      foregroundColor:
                      MaterialStateProperty.all(Palette.titleColor),
                    ),
                    child: const Text(
                      'Host Game',
                      style: TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _createLobby,
                    style: ButtonStyle(
                      backgroundColor:
                      WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
                      fixedSize: WidgetStateProperty.all(
                        Size(
                          MediaQuery
                              .of(context)
                              .size
                              .width * 0.8,
                          50,
                        ),
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      foregroundColor:
                      MaterialStateProperty.all(Palette.titleColor),
                    ),
                    child: const Text(
                      'Create Game',
                      style: TextStyle(
                        fontFamily: 'Itim',
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}