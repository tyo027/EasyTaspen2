part of 'payslip_bloc.dart';

@immutable
sealed class PayslipEvent {}

final class LoadPayslip extends PayslipEvent {
  final String nik;
  final DateTimeRange range;

  LoadPayslip({
    required this.nik,
    required this.range,
  });
}
