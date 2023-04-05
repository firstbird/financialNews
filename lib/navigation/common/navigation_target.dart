const kMobileHomeTabs = [
  NavigationTargetHeadlines,
  NavigationTargetCompanies,
  NavigationTargetUser,
];

const kMobilePopupPages = {
  NavigationTargetPlayingList,
};

abstract class NavigationTarget {
  NavigationTarget();

  factory NavigationTarget.welcome() => NavigationTargetWelcome();

  factory NavigationTarget.discover() => NavigationTargetHeadlines();

  factory NavigationTarget.companies() => NavigationTargetCompanies();

  factory NavigationTarget.user({required int userId}) => NavigationTargetUser(userId);

  factory NavigationTarget.settings() => NavigationTargetSettings();

  factory NavigationTarget.playlist({required int playlistId}) =>
      NavigationTargetNewsDetail(playlistId);

  bool isTheSameTarget(NavigationTarget other) {
    return other.runtimeType == runtimeType;
  }

  bool isMobileHomeTab() => kMobileHomeTabs.contains(runtimeType);
}

class NavigationTargetWelcome extends NavigationTarget {
  NavigationTargetWelcome();
}

class NavigationTargetHeadlines extends NavigationTarget {
  NavigationTargetHeadlines();
}

class NavigationTargetCompanies extends NavigationTarget {
  NavigationTargetCompanies();
}

class NavigationTargetSettings extends NavigationTarget {
  NavigationTargetSettings();
}

class NavigationTargetNewsDetail extends NavigationTarget {
  NavigationTargetNewsDetail(this.playlistId);

  final int playlistId;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetNewsDetail &&
        other.playlistId == playlistId;
  }
}

class NavigationTargetCollection extends NavigationTarget {
  NavigationTargetCollection();
}

class NavigationTargetFollow extends NavigationTarget {
  NavigationTargetFollow();
}

class NavigationTargetHistory extends NavigationTarget {
  NavigationTargetHistory();
}

class NavigationTargetLike extends NavigationTarget {
  NavigationTargetLike();
}

class NavigationTargetPlaying extends NavigationTarget {
  NavigationTargetPlaying();
}

class NavigationTargetFmPlaying extends NavigationTarget {
  NavigationTargetFmPlaying();
}

class NavigationTargetLibrary extends NavigationTarget {
  NavigationTargetLibrary();
}

class NavigationTargetSearch extends NavigationTarget {
  NavigationTargetSearch();
}

class NavigationTargetUser extends NavigationTarget {
  NavigationTargetUser(this.userId);

  final int userId;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetUser &&
        other.userId == userId;
  }
}

class NavigationTargetLogin extends NavigationTarget {
  NavigationTargetLogin();
}

class NavigationTargetArtistDetail extends NavigationTarget {
  NavigationTargetArtistDetail(this.artistId);

  final int artistId;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetArtistDetail &&
        other.artistId == artistId;
  }
}

class NavigationTargetAlbumDetail extends NavigationTarget {
  NavigationTargetAlbumDetail(this.albumId);

  final int albumId;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetAlbumDetail &&
        other.albumId == albumId;
  }
}

class NavigationTargetDailyRecommend extends NavigationTarget {
  NavigationTargetDailyRecommend();
}

class NavigationTargetSearchMusicResult extends NavigationTarget {
  NavigationTargetSearchMusicResult(this.keyword);

  final String keyword;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetSearchMusicResult &&
        other.keyword == keyword;
  }
}

class NavigationTargetSearchArtistResult extends NavigationTarget {
  NavigationTargetSearchArtistResult(this.keyword);

  final String keyword;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetSearchArtistResult &&
        other.keyword == keyword;
  }
}

class NavigationTargetSearchAlbumResult extends NavigationTarget {
  NavigationTargetSearchAlbumResult(this.keyword);

  final String keyword;

  @override
  bool isTheSameTarget(NavigationTarget other) {
    return super.isTheSameTarget(other) &&
        other is NavigationTargetSearchAlbumResult &&
        other.keyword == keyword;
  }
}

class NavigationTargetCloudMusic extends NavigationTarget {
  NavigationTargetCloudMusic();
}

class NavigationTargetPlayHistory extends NavigationTarget {
  NavigationTargetPlayHistory();
}

class NavigationTargetPlayingList extends NavigationTarget {
  NavigationTargetPlayingList();
}
