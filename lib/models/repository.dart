abstract class Repository<REQUEST, RESULT> {
  Future<RESULT?> fetch(String userId, REQUEST request);
}
