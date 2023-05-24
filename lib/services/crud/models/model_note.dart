class DatabaseNote {
  final int id;
  final String text;
  final int userId;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.text,
    required this.userId,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumnName] as int,
        userId = map[userIdColumnName] as int,
        text = map[textColumnName] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumnName] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, ID = $id, userId = $userId, isSyncedWithCloud = $isSyncedWithCloud, text = $text';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const noteIdColumnName = 'id';
const textColumnName = 'text';
const userIdColumnName = 'user_id';
const isSyncedWithCloudColumnName = 'is_synced_with_cloud';
