import '../domain/corporate_client.dart';
import '../domain/college_partner.dart';
import '../domain/operator_portal.dart';

abstract class B2bRepository {
  Future<List<CorporateAccount>> getCorporateAccounts();
  Future<List<CollegeAccount>> getCollegeAccounts();
  Future<List<OperatorAccount>> getOperatorAccounts();
  Future<bool> submitInquiry({
    required String partnerType, // 'corporate', 'college', 'operator'
    required String orgName,
    required String contactName,
    required String email,
    required String phone,
    String? message,
  });
  Future<bool> syncOperatorInventory(OperatorInventorySyncEvent event);
}

class B2bRepositoryImpl implements B2bRepository {
  final List<CorporateAccount> _corporates = List.from(MockCorporateData.accounts);
  final List<CollegeAccount> _colleges = List.from(MockCollegeData.accounts);
  final List<OperatorAccount> _operators = List.from(MockOperatorData.accounts);

  @override
  Future<List<CorporateAccount>> getCorporateAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _corporates;
  }

  @override
  Future<List<CollegeAccount>> getCollegeAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _colleges;
  }

  @override
  Future<List<OperatorAccount>> getOperatorAccounts() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _operators;
  }

  @override
  Future<bool> submitInquiry({
    required String partnerType,
    required String orgName,
    required String contactName,
    required String email,
    required String phone,
    String? message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return true;
  }

  @override
  Future<bool> syncOperatorInventory(OperatorInventorySyncEvent event) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return true;
  }
}
