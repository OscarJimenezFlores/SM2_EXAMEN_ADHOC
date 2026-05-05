import 'package:flutter_test/flutter_test.dart';
import 'package:proyecto_moviles2/model/ticket_model.dart';
import 'package:proyecto_moviles2/model/usuario_model.dart';


void main() {
  group('Pruebas Unitarias - Sistema de Tickets MDP', () {
    
    // Prueba 1: Validación de Integridad de Datos (Título)
    test('Validación: Un ticket sin título debe ser detectado como inválido', () {
      final ticket = Ticket(
        id: 'test-001',
        titulo: '', // Título vacío
        descripcion: 'Falla en el sistema de red',
        estado: 'pendiente',
        userId: 'admin-01',
        usuarioNombre: 'Ricardo Admin',
        fechaCreacion: DateTime.now(),
        fechaActualizacion: DateTime.now(),
        prioridad: 'alta',
        categoria: 'redes',
      );

      // Lógica: El título no debe estar vacío después de quitar espacios
      final esValido = ticket.titulo.trim().isNotEmpty;
      
      expect(esValido, isFalse, reason: 'El sistema no debería permitir títulos vacíos');
    });

    // Prueba 2: Lógica de Negocio (Cambio de Estado)
    test('Lógica: El cambio de estado debe reflejar una actualización cronológica', () {
      final fechaInicial = DateTime.now().subtract(const Duration(hours: 5));
      
      final ticketOriginal = Ticket(
        id: 't-100',
        titulo: 'Soporte Técnico',
        descripcion: 'Mantenimiento preventivo',
        estado: 'pendiente',
        userId: 'u-50',
        usuarioNombre: 'Usuario Test',
        fechaCreacion: fechaInicial,
        fechaActualizacion: fechaInicial,
        prioridad: 'media',
        categoria: 'hardware',
      );

      // Simulamos la actualización del ticket
      final fechaNueva = DateTime.now();
      final ticketActualizado = Ticket(
        id: ticketOriginal.id,
        titulo: ticketOriginal.titulo,
        descripcion: ticketOriginal.descripcion,
        estado: 'en progreso',
        userId: ticketOriginal.userId,
        usuarioNombre: ticketOriginal.usuarioNombre,
        fechaCreacion: ticketOriginal.fechaCreacion,
        fechaActualizacion: fechaNueva,
        prioridad: ticketOriginal.prioridad,
        categoria: ticketOriginal.categoria,
      );

      expect(ticketActualizado.estado, equals('en progreso'));
      expect(ticketActualizado.fechaActualizacion.isAfter(ticketOriginal.fechaActualizacion), isTrue);
    });

    // Prueba 3: Validación de Formato (Email de Usuario)
    test('Seguridad: El formato de email del usuario debe ser válido', () {
      final usuario = Usuario(
        id: 'usr-99',
        username: 'ricardo_dev',
        email: 'correo_invalido_at_dominio.com', // Formato incorrecto
        nombreCompleto: 'Ricardo Estudiante',
        fechaCreacion: DateTime.now(),
        ultimoLogin: null,
        emailVerificado: false,
        rol: 'usuario',
      );

      final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
      final esEmailValido = emailRegExp.hasMatch(usuario.email);

      expect(esEmailValido, isFalse, reason: 'El formato de email proporcionado es incorrecto');
    });
  });
}