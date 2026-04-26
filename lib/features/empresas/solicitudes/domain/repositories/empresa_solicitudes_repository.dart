import 'package:dartz/dartz.dart';

import '../../../../../core/errors/failures.dart';
import '../entities/empresa_solicitud_entity.dart';

abstract class EmpresaSolicitudesRepository {
  Future<Either<Failure, List<EmpresaSolicitudEntity>>> getSolicitudes({String? estado});
  Future<Either<Failure, void>> aceptarSolicitud({
    required int id,
    required int recolectorId,
    required String horaEstimadaInicio,
    required String horaEstimadaFin,
    String? comentarioEmpresa,
  });
  Future<Either<Failure, void>> rechazarSolicitud({
    required int id,
    required String motivo,
  });
  Future<Either<Failure, void>> marcarEnTransito({
    required int id,
    double? latitudRecolector,
    double? longitudRecolector,
    int? tiempoEstimadoMinutos,
  });
  Future<Either<Failure, void>> marcarRecolectada({
    required int id,
    required int puntosOtorgados,
    String? evidenciaUrl,
  });
}
