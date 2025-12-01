import 'package:flutter/material.dart';

enum LegalDocumentType { terms, privacy }

class LegalDocumentScreen extends StatelessWidget {
  final LegalDocumentType type;

  const LegalDocumentScreen({super.key, required this.type});

  Map<String, String> _getDocumentContent(LegalDocumentType type) {
    switch (type) {
      case LegalDocumentType.terms:
        return {
          'title': 'Términos de Servicio',
          'content':
              '1. Aceptación de los Términos\n'
              'Al acceder o utilizar el Servicio Zaap, usted acepta estar sujeto a estos Términos de Servicio. Si no está de acuerdo con alguna parte de los términos, no podrá acceder al Servicio.\n\n'
              '2. Uso del Servicio\n'
              'Usted se compromete a no utilizar el Servicio de manera indebida. Esto incluye, pero no se limita a, la publicación de contenido ilegal, acosador o difamatorio.\n\n'
              '3. Terminación\n'
              'Podemos terminar o suspender su acceso a nuestro Servicio inmediatamente, sin previo aviso ni responsabilidad, por cualquier motivo, incluyendo sin limitación si usted incumple los Términos.\n\n'
              '4. Ámbito Geográfico\n'
              'El servicio Zaap se ofrece actualmente de forma limitada. Para la verificación de cuenta, solo admitimos números de teléfono con el código de país +52 (México). Estamos trabajando continuamente en la expansión del servicio a otras regiones.',
        };
      case LegalDocumentType.privacy:
        return {
          'title': 'Política de Privacidad',
          'content':
              '1. Información que Recopilamos\n'
              'Recopilamos varios tipos de información con el fin de proporcionar y mejorar nuestro Servicio. Esto incluye su número de teléfono y la información de su dispositivo.\n\n'
              '2. Uso de Datos\n'
              'Zaap utiliza los datos recopilados para varios propósitos: para proporcionar y mantener nuestro Servicio, para notificarle sobre cambios en nuestro Servicio y para permitirle participar en funciones interactivas.\n\n'
              '3. Seguridad de los Datos\n'
              'La seguridad de sus datos es importante para nosotros, pero recuerde que ningún método de transmisión por Internet o método de almacenamiento electrónico es 100% seguro.',
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    final content = _getDocumentContent(type);

    return Scaffold(
      appBar: AppBar(
        title: Text(content['title']!),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Text(content['content']!, style: const TextStyle(height: 1.5)),
      ),
    );
  }
}
