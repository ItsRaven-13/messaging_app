import 'package:flutter/material.dart';
import 'package:messaging_app/core/constants/app_colors.dart';
import 'main_chat_screen.dart'; // Para reutilizar el modelo de Chat

// Definiciones de Message (si no las has puesto en un archivo separado)
class Message {
  final String senderId;
  final String text;
  final DateTime timestamp;
  final bool isMe;

  Message({
    required this.senderId,
    required this.text,
    required this.timestamp,
    required this.isMe,
  });
}

List<Message> mockMessages = [
  Message(
    senderId: 'contact1',
    text: '¿Ya estás?',
    timestamp: DateTime(2025, 9, 25, 10, 24),
    isMe: false,
  ),
  Message(
    senderId: 'myId',
    text: 'Si, apenas voy saliendo del trabajo. Tarde un poco, disculpa.',
    timestamp: DateTime(2025, 9, 25, 10, 25),
    isMe: true,
  ),
  Message(
    senderId: 'contact1',
    text: 'Ok, con cuidado. Te espero en 15 minutos. Me avisas cuando llegues.',
    timestamp: DateTime(2025, 9, 25, 10, 25, 30),
    isMe: false,
  ),
];

class ChatScreen extends StatelessWidget {
  final Chat chat;
  const ChatScreen({super.key, required this.chat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColorsLight.gradientStart,
                AppColorsLight.gradientEnd,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          chat.name,
          style: const TextStyle(
            color: AppColorsLight.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColorsLight.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.more_vert,
              color: AppColorsLight.textPrimary,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        // Fondo de chat degradado como en el mockup
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFE0F7FA),
              Color(0xFFF0F9FF),
            ], // Ligeros tonos azules
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Área de mensajes (scrollable)
            Expanded(
              child: ListView.builder(
                reverse: true, // Muestra los mensajes de abajo hacia arriba
                itemCount: mockMessages.length,
                itemBuilder: (context, index) {
                  final message = mockMessages.reversed
                      .toList()[index]; // Mostrar en orden cronológico
                  return MessageBubble(message: message);
                },
              ),
            ),

            // Área de entrada de texto
            const _ChatInputArea(),
          ],
        ),
      ),
    );
  }
}

// Widget auxiliar para la burbuja de mensaje
class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    // Alinear a la derecha si es mi mensaje, a la izquierda si es del contacto
    final alignment = message.isMe
        ? Alignment.centerRight
        : Alignment.centerLeft;
    final color = message.isMe
        ? AppColorsLight.secondary
        : Colors.white; // Rosa vs Blanco
    final textPrimary = AppColorsLight.textPrimary;

    return Container(
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      child: Column(
        crossAxisAlignment: message.isMe
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.75,
            ),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(
                  message.isMe ? 12 : 0,
                ), // Lógica del piquito
                bottomRight: Radius.circular(message.isMe ? 0 : 12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Text(message.text, style: TextStyle(color: textPrimary)),
          ),
          const SizedBox(height: 2),
          Text(
            '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// Widget auxiliar para el campo de entrada
class _ChatInputArea extends StatelessWidget {
  const _ChatInputArea();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: AppColorsLight
            .primary, // La barra de entrada tiene el color azul claro
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Botón de micrófono/archivo
          IconButton(
            icon: const Icon(Icons.mic, color: AppColorsLight.textPrimary),
            onPressed: () {},
          ),

          // Campo de texto
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Escribe un mensaje...',
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                // Lógica para desplazar la lista de mensajes al escribir
              },
            ),
          ),

          // Botón de enviar
          IconButton(
            icon: const Icon(Icons.send, color: AppColorsLight.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
