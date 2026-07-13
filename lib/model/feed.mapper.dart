// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'package:bible_feed/manager/feed_manager.dart';

class FeedMapper extends ClassMapperBase<Feed> {
  FeedMapper._();

  static FeedMapper? _instance;
  static FeedMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = FeedMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'Feed';

  static String _$_bookKey(Feed v) => v._bookKey;
  static const Field<Feed, String> _f$_bookKey = Field(
    '_bookKey',
    _$_bookKey,
    key: r'bookKey',
  );
  static int _$_chapter(Feed v) => v._chapter;
  static const Field<Feed, int> _f$_chapter = Field(
    '_chapter',
    _$_chapter,
    key: r'chapter',
    opt: true,
    def: 1,
  );
  static int _$_verse(Feed v) => v._verse;
  static const Field<Feed, int> _f$_verse = Field(
    '_verse',
    _$_verse,
    key: r'verse',
    opt: true,
    def: 1,
  );
  static bool _$_isRead(Feed v) => v._isRead;
  static const Field<Feed, bool> _f$_isRead = Field(
    '_isRead',
    _$_isRead,
    key: r'isRead',
    opt: true,
    def: false,
  );
  static DateTime? _$_dateModified(Feed v) => v._dateModified;
  static const Field<Feed, DateTime> _f$_dateModified = Field(
    '_dateModified',
    _$_dateModified,
    key: r'dateModified',
    opt: true,
  );

  @override
  final MappableFields<Feed> fields = const {
    #_bookKey: _f$_bookKey,
    #_chapter: _f$_chapter,
    #_verse: _f$_verse,
    #_isRead: _f$_isRead,
    #_dateModified: _f$_dateModified,
  };

  static Feed _instantiate(DecodingData data) {
    return Feed(
      bookKey: data.dec(_f$_bookKey),
      chapter: data.dec(_f$_chapter),
      verse: data.dec(_f$_verse),
      isRead: data.dec(_f$_isRead),
      dateModified: data.dec(_f$_dateModified),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static Feed fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<Feed>(map);
  }

  static Feed fromJson(String json) {
    return ensureInitialized().decodeJson<Feed>(json);
  }
}

mixin FeedMappable {
  String toJson() {
    return FeedMapper.ensureInitialized().encodeJson<Feed>(
      this as Feed,
    );
  }

  Map<String, dynamic> toMap() {
    return FeedMapper.ensureInitialized().encodeMap<Feed>(
      this as Feed,
    );
  }

  FeedCopyWith<Feed, Feed, Feed> get copyWith =>
      _FeedCopyWithImpl<Feed, Feed>(
        this as Feed,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return FeedMapper.ensureInitialized().stringifyValue(
      this as Feed,
    );
  }

  @override
  bool operator ==(Object other) {
    return FeedMapper.ensureInitialized().equalsValue(
      this as Feed,
      other,
    );
  }

  @override
  int get hashCode {
    return FeedMapper.ensureInitialized().hashValue(this as Feed);
  }
}

extension FeedValueCopy<$R, $Out> on ObjectCopyWith<$R, Feed, $Out> {
  FeedCopyWith<$R, Feed, $Out> get $asFeed =>
      $base.as((v, t, t2) => _FeedCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class FeedCopyWith<$R, $In extends Feed, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? bookKey,
    int? chapter,
    int? verse,
    bool? isRead,
    DateTime? dateModified,
  });
  FeedCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _FeedCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, Feed, $Out>
    implements FeedCopyWith<$R, Feed, $Out> {
  _FeedCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<Feed> $mapper = FeedMapper.ensureInitialized();
  @override
  $R call({
    String? bookKey,
    int? chapter,
    int? verse,
    bool? isRead,
    Object? dateModified = $none,
  }) => $apply(
    FieldCopyWithData({
      if (bookKey != null) #bookKey: bookKey,
      if (chapter != null) #chapter: chapter,
      if (verse != null) #verse: verse,
      if (isRead != null) #isRead: isRead,
      if (dateModified != $none) #dateModified: dateModified,
    }),
  );
  @override
  Feed $make(CopyWithData data) => Feed(
    bookKey: data.get(#bookKey, or: $value._bookKey),
    chapter: data.get(#chapter, or: $value._chapter),
    verse: data.get(#verse, or: $value._verse),
    isRead: data.get(#isRead, or: $value._isRead),
    dateModified: data.get(#dateModified, or: $value._dateModified),
  );

  @override
  FeedCopyWith<$R2, Feed, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _FeedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}
