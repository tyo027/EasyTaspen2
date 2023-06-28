part of 'payslip_bloc.dart';

class PayslipEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThnBlnChanged extends PayslipEvent {
  final String thnbln;

  ThnBlnChanged({required this.thnbln});

  @override
  List<Object?> get props => [thnbln];
}

class PaySlipChanged extends PayslipEvent {
  final String payslip;

  PaySlipChanged({required this.payslip});

  @override
  List<Object?> get props => [payslip];
}
