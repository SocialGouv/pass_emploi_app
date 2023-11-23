abstract class AlerteRepository<Alerte> {
  Future<bool> postAlerte(String userId, Alerte alerte, String title);
}
