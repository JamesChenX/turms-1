// Generated by the protocol buffer compiler.  DO NOT EDIT!
// NO CHECKED-IN PROTOBUF GENCODE
// source: model/user/user_friend_requests_with_version.proto
// Protobuf C++ Version: 5.27.2

#include "turms/client/model/proto/model/user/user_friend_requests_with_version.pb.h"

#include <algorithm>
#include <type_traits>

#include "google/protobuf/extension_set.h"
#include "google/protobuf/generated_message_tctable_impl.h"
#include "google/protobuf/io/coded_stream.h"
#include "google/protobuf/io/zero_copy_stream_impl_lite.h"
#include "google/protobuf/wire_format_lite.h"
// @@protoc_insertion_point(includes)

// Must be included last.
#include "google/protobuf/port_def.inc"
PROTOBUF_PRAGMA_INIT_SEG
namespace _pb = ::google::protobuf;
namespace _pbi = ::google::protobuf::internal;
namespace _fl = ::google::protobuf::internal::field_layout;
namespace turms {
namespace client {
namespace model {
namespace proto {

inline constexpr UserFriendRequestsWithVersion::Impl_::Impl_(::_pbi::ConstantInitialized) noexcept
    : _cached_size_{0},
      user_friend_requests_{},
      last_updated_date_{::int64_t{0}} {
}

template <typename>
PROTOBUF_CONSTEXPR UserFriendRequestsWithVersion::UserFriendRequestsWithVersion(
    ::_pbi::ConstantInitialized)
    : _impl_(::_pbi::ConstantInitialized()) {
}
struct UserFriendRequestsWithVersionDefaultTypeInternal {
    PROTOBUF_CONSTEXPR UserFriendRequestsWithVersionDefaultTypeInternal()
        : _instance(::_pbi::ConstantInitialized{}) {
    }
    ~UserFriendRequestsWithVersionDefaultTypeInternal() {
    }
    union {
        UserFriendRequestsWithVersion _instance;
    };
};

PROTOBUF_ATTRIBUTE_NO_DESTROY PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1
    UserFriendRequestsWithVersionDefaultTypeInternal
        _UserFriendRequestsWithVersion_default_instance_;
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace turms {
namespace client {
namespace model {
namespace proto {
// ===================================================================

class UserFriendRequestsWithVersion::_Internal {
   public:
    using HasBits = decltype(std::declval<UserFriendRequestsWithVersion>()._impl_._has_bits_);
    static constexpr ::int32_t kHasBitsOffset =
        8 * PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_._has_bits_);
};

void UserFriendRequestsWithVersion::clear_user_friend_requests() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.user_friend_requests_.Clear();
}
UserFriendRequestsWithVersion::UserFriendRequestsWithVersion(::google::protobuf::Arena* arena)
    : ::google::protobuf::MessageLite(arena) {
    SharedCtor(arena);
    // @@protoc_insertion_point(arena_constructor:turms.client.model.proto.UserFriendRequestsWithVersion)
}
inline PROTOBUF_NDEBUG_INLINE UserFriendRequestsWithVersion::Impl_::Impl_(
    ::google::protobuf::internal::InternalVisibility visibility,
    ::google::protobuf::Arena* arena,
    const Impl_& from,
    const ::turms::client::model::proto::UserFriendRequestsWithVersion& from_msg)
    : _has_bits_{from._has_bits_},
      _cached_size_{0},
      user_friend_requests_{visibility, arena, from.user_friend_requests_} {
}

UserFriendRequestsWithVersion::UserFriendRequestsWithVersion(
    ::google::protobuf::Arena* arena, const UserFriendRequestsWithVersion& from)
    : ::google::protobuf::MessageLite(arena) {
    UserFriendRequestsWithVersion* const _this = this;
    (void)_this;
    _internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
    new (&_impl_) Impl_(internal_visibility(), arena, from._impl_, from);
    _impl_.last_updated_date_ = from._impl_.last_updated_date_;

    // @@protoc_insertion_point(copy_constructor:turms.client.model.proto.UserFriendRequestsWithVersion)
}
inline PROTOBUF_NDEBUG_INLINE UserFriendRequestsWithVersion::Impl_::Impl_(
    ::google::protobuf::internal::InternalVisibility visibility, ::google::protobuf::Arena* arena)
    : _cached_size_{0},
      user_friend_requests_{visibility, arena} {
}

inline void UserFriendRequestsWithVersion::SharedCtor(::_pb::Arena* arena) {
    new (&_impl_) Impl_(internal_visibility(), arena);
    _impl_.last_updated_date_ = {};
}
UserFriendRequestsWithVersion::~UserFriendRequestsWithVersion() {
    // @@protoc_insertion_point(destructor:turms.client.model.proto.UserFriendRequestsWithVersion)
    _internal_metadata_.Delete<std::string>();
    SharedDtor();
}
inline void UserFriendRequestsWithVersion::SharedDtor() {
    ABSL_DCHECK(GetArena() == nullptr);
    _impl_.~Impl_();
}

const ::google::protobuf::MessageLite::ClassData* UserFriendRequestsWithVersion::GetClassData()
    const {
    PROTOBUF_CONSTINIT static const ClassDataLite<55> _data_ = {
        {
            &_table_.header,
            nullptr,  // OnDemandRegisterArenaDtor
            nullptr,  // IsInitialized
            PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_._cached_size_),
            true,
        },
        "turms.client.model.proto.UserFriendRequestsWithVersion",
    };

    return _data_.base();
}
PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1 const ::_pbi::TcParseTable<1, 2, 1, 0, 2>
    UserFriendRequestsWithVersion::_table_ = {
        {
            PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_._has_bits_),
            0,  // no _extensions_
            2,
            8,  // max_field_number, fast_idx_mask
            offsetof(decltype(_table_), field_lookup_table),
            4294967292,  // skipmap
            offsetof(decltype(_table_), field_entries),
            2,  // num_field_entries
            1,  // num_aux_entries
            offsetof(decltype(_table_), aux_entries),
            &_UserFriendRequestsWithVersion_default_instance_._instance,
            nullptr,                                // post_loop_handler
            ::_pbi::TcParser::GenericFallbackLite,  // fallback
#ifdef PROTOBUF_PREFETCH_PARSE_TABLE
            ::_pbi::TcParser::GetTable<
                ::turms::client::model::proto::UserFriendRequestsWithVersion>(),  // to_prefetch
#endif  // PROTOBUF_PREFETCH_PARSE_TABLE
        },
        {{
            // optional int64 last_updated_date = 2;
            {::_pbi::TcParser::FastV64S1,
             {16,
              0,
              0,
              PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_.last_updated_date_)}},
            // repeated .turms.client.model.proto.UserFriendRequest user_friend_requests = 1;
            {::_pbi::TcParser::FastMtR1,
             {10,
              63,
              0,
              PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_.user_friend_requests_)}},
        }},
        {{65535, 65535}},
        {{
            // repeated .turms.client.model.proto.UserFriendRequest user_friend_requests = 1;
            {PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_.user_friend_requests_),
             -1,
             0,
             (0 | ::_fl::kFcRepeated | ::_fl::kMessage | ::_fl::kTvTable)},
            // optional int64 last_updated_date = 2;
            {PROTOBUF_FIELD_OFFSET(UserFriendRequestsWithVersion, _impl_.last_updated_date_),
             _Internal::kHasBitsOffset + 0,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
        }},
        {{
            {::_pbi::TcParser::GetTable<::turms::client::model::proto::UserFriendRequest>()},
        }},
        {{}},
};

PROTOBUF_NOINLINE void UserFriendRequestsWithVersion::Clear() {
    // @@protoc_insertion_point(message_clear_start:turms.client.model.proto.UserFriendRequestsWithVersion)
    ::google::protobuf::internal::TSanWrite(&_impl_);
    ::uint32_t cached_has_bits = 0;
    // Prevent compiler warnings about cached_has_bits being unused
    (void)cached_has_bits;

    _impl_.user_friend_requests_.Clear();
    _impl_.last_updated_date_ = ::int64_t{0};
    _impl_._has_bits_.Clear();
    _internal_metadata_.Clear<std::string>();
}

::uint8_t* UserFriendRequestsWithVersion::_InternalSerialize(
    ::uint8_t* target, ::google::protobuf::io::EpsCopyOutputStream* stream) const {
    // @@protoc_insertion_point(serialize_to_array_start:turms.client.model.proto.UserFriendRequestsWithVersion)
    ::uint32_t cached_has_bits = 0;
    (void)cached_has_bits;

    // repeated .turms.client.model.proto.UserFriendRequest user_friend_requests = 1;
    for (unsigned i = 0, n = static_cast<unsigned>(this->_internal_user_friend_requests_size());
         i < n;
         i++) {
        const auto& repfield = this->_internal_user_friend_requests().Get(i);
        target = ::google::protobuf::internal::WireFormatLite::InternalWriteMessage(
            1, repfield, repfield.GetCachedSize(), target, stream);
    }

    cached_has_bits = _impl_._has_bits_[0];
    // optional int64 last_updated_date = 2;
    if (cached_has_bits & 0x00000001u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<2>(
            stream, this->_internal_last_updated_date(), target);
    }

    if (PROTOBUF_PREDICT_FALSE(_internal_metadata_.have_unknown_fields())) {
        target = stream->WriteRaw(
            _internal_metadata_
                .unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString)
                .data(),
            static_cast<int>(
                _internal_metadata_
                    .unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString)
                    .size()),
            target);
    }
    // @@protoc_insertion_point(serialize_to_array_end:turms.client.model.proto.UserFriendRequestsWithVersion)
    return target;
}

::size_t UserFriendRequestsWithVersion::ByteSizeLong() const {
    // @@protoc_insertion_point(message_byte_size_start:turms.client.model.proto.UserFriendRequestsWithVersion)
    ::size_t total_size = 0;

    ::uint32_t cached_has_bits = 0;
    // Prevent compiler warnings about cached_has_bits being unused
    (void)cached_has_bits;

    ::_pbi::Prefetch5LinesFrom7Lines(reinterpret_cast<const void*>(this));
    // repeated .turms.client.model.proto.UserFriendRequest user_friend_requests = 1;
    total_size += 1UL * this->_internal_user_friend_requests_size();
    for (const auto& msg : this->_internal_user_friend_requests()) {
        total_size += ::google::protobuf::internal::WireFormatLite::MessageSize(msg);
    }
    // optional int64 last_updated_date = 2;
    cached_has_bits = _impl_._has_bits_[0];
    if (cached_has_bits & 0x00000001u) {
        total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_last_updated_date());
    }

    if (PROTOBUF_PREDICT_FALSE(_internal_metadata_.have_unknown_fields())) {
        total_size += _internal_metadata_
                          .unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString)
                          .size();
    }
    _impl_._cached_size_.Set(::_pbi::ToCachedSize(total_size));
    return total_size;
}

void UserFriendRequestsWithVersion::CheckTypeAndMergeFrom(
    const ::google::protobuf::MessageLite& from) {
    MergeFrom(*::_pbi::DownCast<const UserFriendRequestsWithVersion*>(&from));
}

void UserFriendRequestsWithVersion::MergeFrom(const UserFriendRequestsWithVersion& from) {
    UserFriendRequestsWithVersion* const _this = this;
    // @@protoc_insertion_point(class_specific_merge_from_start:turms.client.model.proto.UserFriendRequestsWithVersion)
    ABSL_DCHECK_NE(&from, _this);
    ::uint32_t cached_has_bits = 0;
    (void)cached_has_bits;

    _this->_internal_mutable_user_friend_requests()->MergeFrom(
        from._internal_user_friend_requests());
    cached_has_bits = from._impl_._has_bits_[0];
    if (cached_has_bits & 0x00000001u) {
        _this->_impl_.last_updated_date_ = from._impl_.last_updated_date_;
    }
    _this->_impl_._has_bits_[0] |= cached_has_bits;
    _this->_internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
}

void UserFriendRequestsWithVersion::CopyFrom(const UserFriendRequestsWithVersion& from) {
    // @@protoc_insertion_point(class_specific_copy_from_start:turms.client.model.proto.UserFriendRequestsWithVersion)
    if (&from == this)
        return;
    Clear();
    MergeFrom(from);
}

void UserFriendRequestsWithVersion::InternalSwap(
    UserFriendRequestsWithVersion* PROTOBUF_RESTRICT other) {
    using std::swap;
    _internal_metadata_.InternalSwap(&other->_internal_metadata_);
    swap(_impl_._has_bits_[0], other->_impl_._has_bits_[0]);
    _impl_.user_friend_requests_.InternalSwap(&other->_impl_.user_friend_requests_);
    swap(_impl_.last_updated_date_, other->_impl_.last_updated_date_);
}

// @@protoc_insertion_point(namespace_scope)
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace google {
namespace protobuf {}  // namespace protobuf
}  // namespace google
// @@protoc_insertion_point(global_scope)
#include "google/protobuf/port_undef.inc"