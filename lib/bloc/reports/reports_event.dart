abstract class ReportsEvent {}

class FetchReports extends ReportsEvent {
  final int userId;
  final DateTime startInterval;
  final DateTime endInterval;
  
  FetchReports(this.userId, this.startInterval, this.endInterval);
}
