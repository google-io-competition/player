import 'package:flutter/material.dart';

import '../api/api_service.dart';
import '../game/game_models.dart';
import '../palette.dart';
import '../widgets/game_card.dart';
import 'home.dart';

class GameLibraryScreen extends StatefulWidget {
  const GameLibraryScreen({super.key});

  @override
  _GameLibraryScreenState createState() => _GameLibraryScreenState();
}

class _GameLibraryScreenState extends State<GameLibraryScreen> {
  final TextEditingController _searchBarController = TextEditingController();
  final ApiService apiService = ApiService();
  int currentPage = 1;
  List<File> files = [];
  bool isLoading = false;
  bool hasMore = true;
  int? selectedGameIndex;

  @override
  void initState() {
    super.initState();
    fetchItems();
    _searchBarController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchBarController.removeListener(_onSearchChanged);
    _searchBarController.dispose();
    super.dispose();
  }

  void _mainMenu() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => HomeScreen(),
      ),
    );
  }

  Future<void> fetchItems({String? search}) async {
    if (isLoading) return;
    setState(() {
      isLoading = true;
    });

    try {
      PaginatedResponse response;
      if (search != null && search.isNotEmpty) {
        response = await apiService.searchPaginatedList(currentPage, search);
      } else {
        response = await apiService.fetchPaginatedList(currentPage);
      }
      setState(() {
        currentPage++;
        files.addAll(response.files);
        if (files.length >= response.totalFiles) {
          hasMore = false;
        }
      });
    } catch (e) {
      // Handle error
      print('Failed to fetch items: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadPreviousPage() async {
    if (currentPage > 1) {
      setState(() {
        currentPage--;
        files.clear();
        hasMore = true;
      });
      await fetchItems(search: _searchBarController.text);
    }
  }

  Future<void> loadNextPage() async {
    if (hasMore) {
      await fetchItems(search: _searchBarController.text);
    }
  }

  void _onSearchChanged() {
    setState(() {
      currentPage = 1;
      files.clear();
      hasMore = true;
    });
    fetchItems(search: _searchBarController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.primaryColor,
      appBar: null,
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 50),
            Text(
              'Search',
              style: TextStyle(
                color: Palette.titleColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Itim',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _searchBarController,
              style: TextStyle(
                fontFamily: 'Itim',
                fontSize: 20,
                color: Palette.titleColor,
              ),
              decoration: InputDecoration(
                hintText: '',
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
            const SizedBox(height: 8),
            Text(
              'Games',
              style: TextStyle(
                color: Palette.titleColor,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Itim',
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView(
                children: files.map((file) {
                  int index = files.indexOf(file);
                  return GameCard(
                    gameFile: file.content,
                    isSelected: selectedGameIndex == index,
                    onSelected: (isSelected) {
                      setState(() {
                        selectedGameIndex = isSelected ? index : null;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              textDirection: TextDirection.ltr,
              mainAxisSize: MainAxisSize.max,

              children: [
                ElevatedButton(
                  onPressed: currentPage > 1 ? loadPreviousPage : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (currentPage == 1) {
                          return Colors.black
                              .withOpacity(0.05); // Less opaque when disabled
                        }
                        return Colors.black
                            .withOpacity(0.7); // More opaque when enabled
                      },
                    ),
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width * 0.4,
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
                    'Previous Page',
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                ElevatedButton(
                  onPressed: hasMore ? loadNextPage : null,
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (!hasMore) {
                          return Colors.black
                              .withOpacity(0.05); // Less opaque when disabled
                        }
                        return Colors.black
                            .withOpacity(0.7); // More opaque when enabled
                      },
                    ),
                    fixedSize: MaterialStateProperty.all(
                      Size(
                        MediaQuery.of(context).size.width * 0.4,
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
                    'Next Page',
                    style: TextStyle(
                      fontFamily: 'Itim',
                      fontSize: 20,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: selectedGameIndex != null
                  ? () {
                // Your host game logic here
              }
                  : null,
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(
                  Size(
                    MediaQuery.of(context).size.width,
                    50,
                  ),
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                      (Set<MaterialState> states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.black
                          .withOpacity(0.05); // Less opaque when disabled
                    }
                    return Colors.black
                        .withOpacity(0.7); // More opaque when enabled
                  },
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                foregroundColor: MaterialStateProperty.all(Palette.titleColor),
              ),
              child: const Text(
                'Start Game',
                style: TextStyle(
                  fontFamily: 'Itim',
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _mainMenu,
              style: ButtonStyle(
                fixedSize: WidgetStateProperty.all(
                  Size(
                    MediaQuery.of(context).size.width,
                    50,
                  ),
                ),
                backgroundColor:
                WidgetStateProperty.all(Colors.black.withOpacity(0.1)),
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                foregroundColor:
                MaterialStateProperty.all(Palette.titleColor),
              ),
              child: const Text(
                'Main Menu',
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
    );
  }
}