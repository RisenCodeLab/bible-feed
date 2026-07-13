// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'feed.dart';

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

  static String _$bookKey(Feed v) => v.bookKey;
  static const Field<Feed, String> _f$bookKey = Field('bookKey', _$bookKey);
  static int _$chapter(Feed v) => v.chapter;
  static const Field<Feed, int> _f$chapter = Field(
    'chapter',
    _$chapter,
    opt: true,
    def: 1,
  );
  static int _$verse(Feed v) => v.verse;
  static const Field<Feed, int> _f$verse = Field(
    'verse',
    _$verse,
    opt: true,
    def: 1,
  );
  static bool _$isRead(Feed v) => v.isRead;
  static const Field<Feed, bool> _f$isRead = Field(
    'isRead',
    _$isRead,
    opt: true,
    def: false,
  );
  static DateTime? _$dateModified(Feed v) => v.dateModified;
  static const Field<Feed, DateTime> _f$dateModified = Field(
    'dateModified',
    _$dateModified,
    opt: true,
  );

  @override
  final MappableFields<Feed> fields = const {
    #bookKey: _f$bookKey,
    #chapter: _f$chapter,
    #verse: _f$verse,
    #isRead: _f$isRead,
    #dateModified: _f$dateModified,
  };

  static Feed _instantiate(DecodingData data) {
    return Feed(
      bookKey: data.dec(_f$bookKey),
      chapter: data.dec(_f$chapter),
      verse: data.dec(_f$verse),
      isRead: data.dec(_f$isRead),
      dateModified: data.dec(_f$dateModified),
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
    return FeedMapper.ensureInitialized().encodeJson<Feed>(this as Feed);
  }

  Map<String, dynamic> toMap() {
    return FeedMapper.ensureInitialized().encodeMap<Feed>(this as Feed);
  }

  FeedCopyWith<Feed, Feed, Feed> get copyWith =>
      _FeedCopyWithImpl<Feed, Feed>(this as Feed, $identity, $identity);
  @override
  String toString() {
    return FeedMapper.ensureInitialized().stringifyValue(this as Feed);
  }

  @override
  bool operator ==(Object other) {
    return FeedMapper.ensureInitialized().equalsValue(this as Feed, other);
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

class _FeedCopyWithImpl<$R, $Out> extends ClassCopyWithBase<$R, Feed, $Out>
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
    bookKey: data.get(#bookKey, or: $value.bookKey),
    chapter: data.get(#chapter, or: $value.chapter),
    verse: data.get(#verse, or: $value.verse),
    isRead: data.get(#isRead, or: $value.isRead),
    dateModified: data.get(#dateModified, or: $value.dateModified),
  );

  @override
  FeedCopyWith<$R2, Feed, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _FeedCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

