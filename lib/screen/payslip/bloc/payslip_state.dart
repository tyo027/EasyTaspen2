part of 'payslip_bloc.dart';

class PayslipState extends Equatable {
  final String thnbln;
  final String payslip;

  const PayslipState({required this.thnbln, required this.payslip});

  PayslipState copyWith({
    String? thnbln,
    String? payslip,
  }) =>
      PayslipState(
          thnbln: thnbln ?? this.thnbln, payslip: payslip ?? this.payslip);

  @override
  List<Object> get props => [
        thnbln,
        payslip,
      ];
}
