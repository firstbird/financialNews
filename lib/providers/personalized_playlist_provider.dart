import 'package:riverpod/riverpod.dart';

import '../repository.dart';

final newsListProvider = FutureProvider.family<List, int>(((ref, fromId) async {
  final list = await neteaseRepository!.personalizedPlaylist(limit: 8, offset: fromId);
  return list.asFuture;
}));

final personalizedNewSongProvider = FutureProvider((ref) async {
  final list = await neteaseRepository!.personalizedNewSong();
  return list.asFuture;
});
