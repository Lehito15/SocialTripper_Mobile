import 'dart:async';
import 'dart:convert';
import 'dart:io';


class WebSocketClient {
  final String serverAddress;
  late WebSocket _socket;
  void Function(String message)? _onMessage;

  bool _isConnected = false;
  bool _isTryingToReconnect = false;
  Timer? _reconnectTimer;


  WebSocketClient(this.serverAddress);

  /// Łączy klienta z serwerem
  Future<void> connect() async {
    print('Attempting to connect to: $serverAddress'); // Debug log
    try {
      _socket = await WebSocket.connect(serverAddress);
      _isConnected = true;
      _socket.listen(
            (message) {
          if (_onMessage != null) {
            _onMessage!(message);
          }
        },
        onDone: () => print("Connection closed by server"),
        onError: (error) => print("WebSocket error: $error"),
      );
      print("Connected to server at $serverAddress");
    } catch (e) {
      print("Failed to connect: $e");
      _isConnected = false;
      _attemptReconnect();
    }
  }

  /// Rejestruje handler dla wiadomości
  void onMessage(void Function(String message) handler) {
    _onMessage = handler;
  }

  /// Wysyła wiadomość do serwera
  void sendMessage(String message) {
    print(message);
    if (_isConnected) {
      _socket.add(message);
    } else {
      print("Cannot send message. WebSocket is not connected.");
    }
  }

  /// Zamyka połączenie
  void disconnect() {
    try {
      _reconnectTimer?.cancel();
      _socket.close();
    } catch (e) {
      print("Failed to close socket: $e");
    } finally {
      _isConnected = false;
    }
  }

  /// Sprawdza, czy połączenie jest aktywne
  bool isConnected() => _isConnected;

  /// Obsługuje zamknięcie połączenia
  void _handleConnectionClose() {
    print("WebSocket connection closed.");
    _isConnected = false;
    _attemptReconnect();
  }

  /// Obsługuje błąd połączenia
  void _handleConnectionError(error) {
    print("WebSocket error: $error");
    _isConnected = false;
    _attemptReconnect();
  }

  /// Próbuje ponownie połączyć się z serwerem
  void _attemptReconnect() {
    if (_isTryingToReconnect) return;

    _isTryingToReconnect = true;
    _reconnectTimer = Timer.periodic(Duration(seconds: 5), (timer) async {
      print("Attempting to reconnect...");
      await connect();
      if (_isConnected) {
        print("Reconnected successfully.");
        _isTryingToReconnect = false;
        timer.cancel();
      }
    });
  }
}