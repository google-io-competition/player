import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:logging/logging.dart';

class FirestoreController {
  static final _log = Logger('FirestoreController');

  final FirebaseFirestore instance;
  final BoardState boardState;

  /// For now, there is only one match. But in order to be ready
  /// for match-making, put it in a Firestore collection called matches.
  late final _matchRef = instance.collection('lobbies').doc('match_1');

  late final _boardRef = _matchRef
      .collection('board')
      .doc('current_state')
      .withConverter<BoardElement>(
      fromFirestore: _elementFromFirestore, toFirestore: _elementToFirestore);

  StreamSubscription? _boardFirestoreSubscription;
  StreamSubscription? _boardLocalSubscription;

  FirestoreController({required this.instance, required this.boardState}) {
    // Subscribe to the remote changes (from Firestore).
    _boardFirestoreSubscription = _boardRef.snapshots().listen((snapshot) {
      _updateLocalFromFirestore(boardState, snapshot);
    });

    // Subscribe to the local changes in board state.
    _boardLocalSubscription = boardState.elementChanges.listen((_) {
      _updateFirestoreFromLocal();
    });

    _log.fine('Initialized');
  }

  Future<DocumentReference> createLobby() async {
    _log.info('Contacting firebase');

    try {
      _log.info('Polling lobbies: ');

      final lobbyRef = instance.collection('lobbies').doc();
      _log.info(lobbyRef.id);

      await lobbyRef.set({
        'createdAt': FieldValue.serverTimestamp()
      });
      _log.info('Lobby created with ID: ${lobbyRef.id}');
      return lobbyRef;
    } catch (e) {
      _log.severe('Failed to create lobby: $e');
      rethrow;
    }
  }

  Future<DocumentSnapshot> joinLobby(String code) async {
    final lobbyRef = instance.collection('lobbies').doc(code);
    final snapshot = await lobbyRef.get();
    if (!snapshot.exists) {
      throw Exception('Lobby not found');
    }
    boardState.replaceWith(BoardElement.fromJson(snapshot.data()!['boardState']));
    return snapshot;
  }

  void dispose() {
    _boardFirestoreSubscription?.cancel();
    _boardLocalSubscription?.cancel();

    _log.fine('Disposed');
  }

  /// Takes the raw JSON snapshot coming from Firestore and attempts to
  /// convert it into a [BoardElement].
  BoardElement _elementFromFirestore(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    if (data == null) {
      _log.info('No data found on Firestore, returning default element');
      return BoardElement(text: '', duration: 0);
    }

    try {
      return BoardElement.fromJson(data);
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to parse data from Firestore: $e');
    }
  }

  /// Takes a [BoardElement] and converts it into a JSON object
  /// that can be saved into Firestore.
  Map<String, Object?> _elementToFirestore(
      BoardElement element,
      SetOptions? options,
      ) {
    return element.toJson();
  }

  /// Updates Firestore with the local state of the board.
  Future<void> _updateFirestoreFromLocal() async {
    try {
      _log.fine('Updating Firestore with local data (${boardState.element}) ...');
      await _boardRef.set(boardState.element);
      _log.fine('... done updating.');
    } catch (e) {
      throw FirebaseControllerException(
          'Failed to update Firestore with local data (${boardState.element}): $e');
    }
  }

  /// Updates the local state of the board with the data from Firestore.
  void _updateLocalFromFirestore(
      BoardState state, DocumentSnapshot<BoardElement> snapshot) {
    _log.fine('Received new data from Firestore (${snapshot.data()})');

    final element = snapshot.data();

    if (element == null) {
      _log.fine('No change');
    } else {
      _log.fine('Updating local data with Firestore data ($element)');
      state.replaceWith(element);
    }
  }
  // Chat functionality
  Stream<QuerySnapshot> getMessages(String lobbyId) {
    return instance.collection('lobbies').doc(lobbyId).collection('messages').orderBy('timestamp').snapshots();
  }

  Future<void> sendMessage(String lobbyId, String message, String userId) async {
    final messageRef = instance.collection('lobbies').doc(lobbyId).collection('messages').doc();
    await messageRef.set({
      'text': message,
      'userId': userId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

class BoardElement {
  String text;
  int duration; // Duration in seconds

  BoardElement({required this.text, required this.duration});

  factory BoardElement.fromJson(Map<String, dynamic> json) {
    return BoardElement(
      text: json['text'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'text': text,
      'duration': duration,
    };
  }
}
class BoardState {
  BoardElement element;
  final StreamController<void> _elementChanges = StreamController<void>.broadcast();

  Stream<void> get elementChanges => _elementChanges.stream;

  BoardState({required this.element});

  void updateElement(BoardElement newElement) {
    element = newElement;
    _elementChanges.add(null);
  }

  void replaceWith(BoardElement newElement) {
    element = newElement;
    _elementChanges.add(null);
  }

  Map<String, dynamic> toJson() {
    return element.toJson();
  }
}

class FirebaseControllerException implements Exception {
  final String message;

  FirebaseControllerException(this.message);

  @override
  String toString() => 'FirebaseControllerException: $message';
}
