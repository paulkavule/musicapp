// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:musicapp1/repositories/playlist_repo.dart' as _i4;
import 'package:musicapp1/repositories/song_repo.dart' as _i6;
import 'package:musicapp1/services/helpers_svc.dart' as _i9;
import 'package:musicapp1/services/music_player.dart' as _i3;
import 'package:musicapp1/services/playlist_svc.dart' as _i5;
import 'package:musicapp1/services/song_svc.dart' as _i7;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

/// ignore_for_file: unnecessary_lambdas
/// ignore_for_file: lines_longer_than_80_chars
extension GetItInjectableX on _i1.GetIt {
  /// initializes the registration of main-scope dependencies inside of [GetIt]
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final serviceModule = _$ServiceModule();
    gh.singleton<_i3.IMusicPlayerService>(_i3.MusicPlayerService());
    gh.factory<_i4.IPlaylistRepository>(() => _i4.PlaylistRepository());
    gh.factory<_i5.IPlaylistService>(() => _i5.PlaylistService());
    gh.factory<_i6.ISongRepository>(() => _i6.SongRepository());
    gh.factory<_i7.ISongService>(() => _i7.SongService());
    await gh.factoryAsync<_i8.SharedPreferences>(
      () => serviceModule.prefs,
      preResolve: true,
    );
    return this;
  }
}

class _$ServiceModule extends _i9.ServiceModule {}
