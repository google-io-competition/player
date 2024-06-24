import 'package:flutter/material.dart';
import 'package:player/game/game_models.dart';

class GameCard extends StatefulWidget {
  const GameCard({
    super.key,
    required this.gameFile,
    required this.onSelected,
    required this.isSelected,
  });
  final Game gameFile;
  final bool isSelected;
  final Function(bool) onSelected;

  @override
  _GameCardState createState() => _GameCardState();
}

class _GameCardState extends State<GameCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onSelected(!widget.isSelected);
      },
      child: Card(
        color: widget.isSelected
            ? Colors.black.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.gameFile.icon.isNotEmpty
                  ? Image.network(
                widget.gameFile.icon,
                height: 40.0,
                width: 40.0,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.image_not_supported, size: 40.0);
                },
              )
                  : const Icon(Icons.image, size: 40.0),
              const SizedBox(width: 8.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.gameFile.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      widget.gameFile.description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}