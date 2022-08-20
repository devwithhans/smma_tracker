class Invite {
  final String companyName;
  final String companyId;
  final String inviterName;
  final String id;
  final DateTime? sent;

  Invite({
    required this.companyId,
    required this.id,
    required this.companyName,
    required this.inviterName,
    required this.sent,
  });

  static Invite convert(Map value, String id) {
    return Invite(
      id: id,
      companyId: value['companyId'],
      companyName: value['companyName'],
      inviterName: value['inviterName'],
      sent: value['sent'] != null
          ? DateTime.fromMicrosecondsSinceEpoch(
              value['sent'].microsecondsSinceEpoch)
          : null,
    );
  }
}
