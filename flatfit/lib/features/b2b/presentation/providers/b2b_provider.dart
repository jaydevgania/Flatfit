import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/corporate_client.dart';
import '../../domain/college_partner.dart';
import '../../domain/operator_portal.dart';
import '../../data/b2b_repository.dart';

final b2bRepositoryProvider = Provider<B2bRepository>((ref) {
  return B2bRepositoryImpl();
});

class B2bState {
  final bool isLoading;
  final List<CorporateAccount> corporateAccounts;
  final List<CollegeAccount> collegeAccounts;
  final List<OperatorAccount> operatorAccounts;
  final String? errorMessage;

  const B2bState({
    this.isLoading = false,
    this.corporateAccounts = const [],
    this.collegeAccounts = const [],
    this.operatorAccounts = const [],
    this.errorMessage,
  });

  B2bState copyWith({
    bool? isLoading,
    List<CorporateAccount>? corporateAccounts,
    List<CollegeAccount>? collegeAccounts,
    List<OperatorAccount>? operatorAccounts,
    String? errorMessage,
  }) {
    return B2bState(
      isLoading: isLoading ?? this.isLoading,
      corporateAccounts: corporateAccounts ?? this.corporateAccounts,
      collegeAccounts: collegeAccounts ?? this.collegeAccounts,
      operatorAccounts: operatorAccounts ?? this.operatorAccounts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class B2bNotifier extends StateNotifier<B2bState> {
  final B2bRepository _repo;

  B2bNotifier(this._repo) : super(const B2bState()) {
    loadAll();
  }

  Future<void> loadAll() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final corps = await _repo.getCorporateAccounts();
      final cols = await _repo.getCollegeAccounts();
      final ops = await _repo.getOperatorAccounts();
      state = state.copyWith(
        isLoading: false,
        corporateAccounts: corps,
        collegeAccounts: cols,
        operatorAccounts: ops,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> sendInquiry({
    required String type,
    required String orgName,
    required String contactName,
    required String email,
    required String phone,
    String? message,
  }) async {
    return _repo.submitInquiry(
      partnerType: type,
      orgName: orgName,
      contactName: contactName,
      email: email,
      phone: phone,
      message: message,
    );
  }
}

final b2bProvider = StateNotifierProvider<B2bNotifier, B2bState>((ref) {
  final repo = ref.watch(b2bRepositoryProvider);
  return B2bNotifier(repo);
});
