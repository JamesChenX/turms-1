// Generated by the protocol buffer compiler.  DO NOT EDIT!
// NO CHECKED-IN PROTOBUF GENCODE
// source: model/conference/meeting.proto
// Protobuf C++ Version: 5.27.2

#include "turms/client/model/proto/model/conference/meeting.pb.h"

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

inline constexpr Meeting::Impl_::Impl_(::_pbi::ConstantInitialized) noexcept
    : _cached_size_{0},
      custom_attributes_{},
      access_token_(&::google::protobuf::internal::fixed_address_empty_string,
                    ::_pbi::ConstantInitialized()),
      name_(&::google::protobuf::internal::fixed_address_empty_string,
            ::_pbi::ConstantInitialized()),
      intro_(&::google::protobuf::internal::fixed_address_empty_string,
             ::_pbi::ConstantInitialized()),
      password_(&::google::protobuf::internal::fixed_address_empty_string,
                ::_pbi::ConstantInitialized()),
      id_{::int64_t{0}},
      user_id_{::int64_t{0}},
      group_id_{::int64_t{0}},
      creator_id_{::int64_t{0}},
      start_date_{::int64_t{0}},
      end_date_{::int64_t{0}},
      cancel_date_{::int64_t{0}} {
}

template <typename>
PROTOBUF_CONSTEXPR Meeting::Meeting(::_pbi::ConstantInitialized)
    : _impl_(::_pbi::ConstantInitialized()) {
}
struct MeetingDefaultTypeInternal {
    PROTOBUF_CONSTEXPR MeetingDefaultTypeInternal()
        : _instance(::_pbi::ConstantInitialized{}) {
    }
    ~MeetingDefaultTypeInternal() {
    }
    union {
        Meeting _instance;
    };
};

PROTOBUF_ATTRIBUTE_NO_DESTROY PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1
    MeetingDefaultTypeInternal _Meeting_default_instance_;
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace turms {
namespace client {
namespace model {
namespace proto {
// ===================================================================

class Meeting::_Internal {
   public:
    using HasBits = decltype(std::declval<Meeting>()._impl_._has_bits_);
    static constexpr ::int32_t kHasBitsOffset =
        8 * PROTOBUF_FIELD_OFFSET(Meeting, _impl_._has_bits_);
};

void Meeting::clear_custom_attributes() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.custom_attributes_.Clear();
}
Meeting::Meeting(::google::protobuf::Arena* arena)
    : ::google::protobuf::MessageLite(arena) {
    SharedCtor(arena);
    // @@protoc_insertion_point(arena_constructor:turms.client.model.proto.Meeting)
}
inline PROTOBUF_NDEBUG_INLINE Meeting::Impl_::Impl_(
    ::google::protobuf::internal::InternalVisibility visibility,
    ::google::protobuf::Arena* arena,
    const Impl_& from,
    const ::turms::client::model::proto::Meeting& from_msg)
    : _has_bits_{from._has_bits_},
      _cached_size_{0},
      custom_attributes_{visibility, arena, from.custom_attributes_},
      access_token_(arena, from.access_token_),
      name_(arena, from.name_),
      intro_(arena, from.intro_),
      password_(arena, from.password_) {
}

Meeting::Meeting(::google::protobuf::Arena* arena, const Meeting& from)
    : ::google::protobuf::MessageLite(arena) {
    Meeting* const _this = this;
    (void)_this;
    _internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
    new (&_impl_) Impl_(internal_visibility(), arena, from._impl_, from);
    ::memcpy(reinterpret_cast<char*>(&_impl_) + offsetof(Impl_, id_),
             reinterpret_cast<const char*>(&from._impl_) + offsetof(Impl_, id_),
             offsetof(Impl_, cancel_date_) - offsetof(Impl_, id_) + sizeof(Impl_::cancel_date_));

    // @@protoc_insertion_point(copy_constructor:turms.client.model.proto.Meeting)
}
inline PROTOBUF_NDEBUG_INLINE Meeting::Impl_::Impl_(
    ::google::protobuf::internal::InternalVisibility visibility, ::google::protobuf::Arena* arena)
    : _cached_size_{0},
      custom_attributes_{visibility, arena},
      access_token_(arena),
      name_(arena),
      intro_(arena),
      password_(arena) {
}

inline void Meeting::SharedCtor(::_pb::Arena* arena) {
    new (&_impl_) Impl_(internal_visibility(), arena);
    ::memset(reinterpret_cast<char*>(&_impl_) + offsetof(Impl_, id_),
             0,
             offsetof(Impl_, cancel_date_) - offsetof(Impl_, id_) + sizeof(Impl_::cancel_date_));
}
Meeting::~Meeting() {
    // @@protoc_insertion_point(destructor:turms.client.model.proto.Meeting)
    _internal_metadata_.Delete<std::string>();
    SharedDtor();
}
inline void Meeting::SharedDtor() {
    ABSL_DCHECK(GetArena() == nullptr);
    _impl_.access_token_.Destroy();
    _impl_.name_.Destroy();
    _impl_.intro_.Destroy();
    _impl_.password_.Destroy();
    _impl_.~Impl_();
}

const ::google::protobuf::MessageLite::ClassData* Meeting::GetClassData() const {
    PROTOBUF_CONSTINIT static const ClassDataLite<33> _data_ = {
        {
            &_table_.header,
            nullptr,  // OnDemandRegisterArenaDtor
            nullptr,  // IsInitialized
            PROTOBUF_FIELD_OFFSET(Meeting, _impl_._cached_size_),
            true,
        },
        "turms.client.model.proto.Meeting",
    };

    return _data_.base();
}
PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1 const ::_pbi::TcParseTable<4, 12, 1, 78, 2>
    Meeting::_table_ = {
        {
            PROTOBUF_FIELD_OFFSET(Meeting, _impl_._has_bits_),
            0,  // no _extensions_
            15,
            120,  // max_field_number, fast_idx_mask
            offsetof(decltype(_table_), field_lookup_table),
            4294948864,  // skipmap
            offsetof(decltype(_table_), field_entries),
            12,  // num_field_entries
            1,   // num_aux_entries
            offsetof(decltype(_table_), aux_entries),
            &_Meeting_default_instance_._instance,
            nullptr,                                // post_loop_handler
            ::_pbi::TcParser::GenericFallbackLite,  // fallback
#ifdef PROTOBUF_PREFETCH_PARSE_TABLE
            ::_pbi::TcParser::GetTable<::turms::client::model::proto::Meeting>(),  // to_prefetch
#endif  // PROTOBUF_PREFETCH_PARSE_TABLE
        },
        {{
            {::_pbi::TcParser::MiniParse, {}},
            // int64 id = 1;
            {::_pbi::TcParser::FastV64S1, {8, 63, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.id_)}},
            // optional int64 user_id = 2;
            {::_pbi::TcParser::FastV64S1,
             {16, 4, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.user_id_)}},
            // optional int64 group_id = 3;
            {::_pbi::TcParser::FastV64S1,
             {24, 5, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.group_id_)}},
            // int64 creator_id = 4;
            {::_pbi::TcParser::FastV64S1,
             {32, 63, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.creator_id_)}},
            // optional string access_token = 5;
            {::_pbi::TcParser::FastUS1,
             {42, 0, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.access_token_)}},
            // optional string name = 6;
            {::_pbi::TcParser::FastUS1, {50, 1, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.name_)}},
            // optional string intro = 7;
            {::_pbi::TcParser::FastUS1, {58, 2, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.intro_)}},
            // optional string password = 8;
            {::_pbi::TcParser::FastUS1,
             {66, 3, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.password_)}},
            // int64 start_date = 9;
            {::_pbi::TcParser::FastV64S1,
             {72, 63, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.start_date_)}},
            // optional int64 end_date = 10;
            {::_pbi::TcParser::FastV64S1,
             {80, 6, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.end_date_)}},
            // optional int64 cancel_date = 11;
            {::_pbi::TcParser::FastV64S1,
             {88, 7, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.cancel_date_)}},
            {::_pbi::TcParser::MiniParse, {}},
            {::_pbi::TcParser::MiniParse, {}},
            {::_pbi::TcParser::MiniParse, {}},
            // repeated .turms.client.model.proto.Value custom_attributes = 15;
            {::_pbi::TcParser::FastMtR1,
             {122, 63, 0, PROTOBUF_FIELD_OFFSET(Meeting, _impl_.custom_attributes_)}},
        }},
        {{65535, 65535}},
        {{
            // int64 id = 1;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.id_),
             -1,
             0,
             (0 | ::_fl::kFcSingular | ::_fl::kInt64)},
            // optional int64 user_id = 2;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.user_id_),
             _Internal::kHasBitsOffset + 4,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional int64 group_id = 3;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.group_id_),
             _Internal::kHasBitsOffset + 5,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // int64 creator_id = 4;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.creator_id_),
             -1,
             0,
             (0 | ::_fl::kFcSingular | ::_fl::kInt64)},
            // optional string access_token = 5;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.access_token_),
             _Internal::kHasBitsOffset + 0,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kUtf8String | ::_fl::kRepAString)},
            // optional string name = 6;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.name_),
             _Internal::kHasBitsOffset + 1,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kUtf8String | ::_fl::kRepAString)},
            // optional string intro = 7;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.intro_),
             _Internal::kHasBitsOffset + 2,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kUtf8String | ::_fl::kRepAString)},
            // optional string password = 8;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.password_),
             _Internal::kHasBitsOffset + 3,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kUtf8String | ::_fl::kRepAString)},
            // int64 start_date = 9;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.start_date_),
             -1,
             0,
             (0 | ::_fl::kFcSingular | ::_fl::kInt64)},
            // optional int64 end_date = 10;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.end_date_),
             _Internal::kHasBitsOffset + 6,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional int64 cancel_date = 11;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.cancel_date_),
             _Internal::kHasBitsOffset + 7,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // repeated .turms.client.model.proto.Value custom_attributes = 15;
            {PROTOBUF_FIELD_OFFSET(Meeting, _impl_.custom_attributes_),
             -1,
             0,
             (0 | ::_fl::kFcRepeated | ::_fl::kMessage | ::_fl::kTvTable)},
        }},
        {{
            {::_pbi::TcParser::GetTable<::turms::client::model::proto::Value>()},
        }},
        {{"\40\0\0\0\0\14\4\5\10\0\0\0\0\0\0\0"
          "turms.client.model.proto.Meeting"
          "access_token"
          "name"
          "intro"
          "password"}},
};

PROTOBUF_NOINLINE void Meeting::Clear() {
    // @@protoc_insertion_point(message_clear_start:turms.client.model.proto.Meeting)
    ::google::protobuf::internal::TSanWrite(&_impl_);
    ::uint32_t cached_has_bits = 0;
    // Prevent compiler warnings about cached_has_bits being unused
    (void)cached_has_bits;

    _impl_.custom_attributes_.Clear();
    cached_has_bits = _impl_._has_bits_[0];
    if (cached_has_bits & 0x0000000fu) {
        if (cached_has_bits & 0x00000001u) {
            _impl_.access_token_.ClearNonDefaultToEmpty();
        }
        if (cached_has_bits & 0x00000002u) {
            _impl_.name_.ClearNonDefaultToEmpty();
        }
        if (cached_has_bits & 0x00000004u) {
            _impl_.intro_.ClearNonDefaultToEmpty();
        }
        if (cached_has_bits & 0x00000008u) {
            _impl_.password_.ClearNonDefaultToEmpty();
        }
    }
    _impl_.id_ = ::int64_t{0};
    if (cached_has_bits & 0x00000030u) {
        ::memset(&_impl_.user_id_,
                 0,
                 static_cast<::size_t>(reinterpret_cast<char*>(&_impl_.group_id_) -
                                       reinterpret_cast<char*>(&_impl_.user_id_)) +
                     sizeof(_impl_.group_id_));
    }
    ::memset(&_impl_.creator_id_,
             0,
             static_cast<::size_t>(reinterpret_cast<char*>(&_impl_.start_date_) -
                                   reinterpret_cast<char*>(&_impl_.creator_id_)) +
                 sizeof(_impl_.start_date_));
    if (cached_has_bits & 0x000000c0u) {
        ::memset(&_impl_.end_date_,
                 0,
                 static_cast<::size_t>(reinterpret_cast<char*>(&_impl_.cancel_date_) -
                                       reinterpret_cast<char*>(&_impl_.end_date_)) +
                     sizeof(_impl_.cancel_date_));
    }
    _impl_._has_bits_.Clear();
    _internal_metadata_.Clear<std::string>();
}

::uint8_t* Meeting::_InternalSerialize(::uint8_t* target,
                                       ::google::protobuf::io::EpsCopyOutputStream* stream) const {
    // @@protoc_insertion_point(serialize_to_array_start:turms.client.model.proto.Meeting)
    ::uint32_t cached_has_bits = 0;
    (void)cached_has_bits;

    // int64 id = 1;
    if (this->_internal_id() != 0) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<1>(
            stream, this->_internal_id(), target);
    }

    cached_has_bits = _impl_._has_bits_[0];
    // optional int64 user_id = 2;
    if (cached_has_bits & 0x00000010u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<2>(
            stream, this->_internal_user_id(), target);
    }

    // optional int64 group_id = 3;
    if (cached_has_bits & 0x00000020u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<3>(
            stream, this->_internal_group_id(), target);
    }

    // int64 creator_id = 4;
    if (this->_internal_creator_id() != 0) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<4>(
            stream, this->_internal_creator_id(), target);
    }

    // optional string access_token = 5;
    if (cached_has_bits & 0x00000001u) {
        const std::string& _s = this->_internal_access_token();
        ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            _s.data(),
            static_cast<int>(_s.length()),
            ::google::protobuf::internal::WireFormatLite::SERIALIZE,
            "turms.client.model.proto.Meeting.access_token");
        target = stream->WriteStringMaybeAliased(5, _s, target);
    }

    // optional string name = 6;
    if (cached_has_bits & 0x00000002u) {
        const std::string& _s = this->_internal_name();
        ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            _s.data(),
            static_cast<int>(_s.length()),
            ::google::protobuf::internal::WireFormatLite::SERIALIZE,
            "turms.client.model.proto.Meeting.name");
        target = stream->WriteStringMaybeAliased(6, _s, target);
    }

    // optional string intro = 7;
    if (cached_has_bits & 0x00000004u) {
        const std::string& _s = this->_internal_intro();
        ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            _s.data(),
            static_cast<int>(_s.length()),
            ::google::protobuf::internal::WireFormatLite::SERIALIZE,
            "turms.client.model.proto.Meeting.intro");
        target = stream->WriteStringMaybeAliased(7, _s, target);
    }

    // optional string password = 8;
    if (cached_has_bits & 0x00000008u) {
        const std::string& _s = this->_internal_password();
        ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            _s.data(),
            static_cast<int>(_s.length()),
            ::google::protobuf::internal::WireFormatLite::SERIALIZE,
            "turms.client.model.proto.Meeting.password");
        target = stream->WriteStringMaybeAliased(8, _s, target);
    }

    // int64 start_date = 9;
    if (this->_internal_start_date() != 0) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<9>(
            stream, this->_internal_start_date(), target);
    }

    // optional int64 end_date = 10;
    if (cached_has_bits & 0x00000040u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<10>(
            stream, this->_internal_end_date(), target);
    }

    // optional int64 cancel_date = 11;
    if (cached_has_bits & 0x00000080u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<11>(
            stream, this->_internal_cancel_date(), target);
    }

    // repeated .turms.client.model.proto.Value custom_attributes = 15;
    for (unsigned i = 0, n = static_cast<unsigned>(this->_internal_custom_attributes_size()); i < n;
         i++) {
        const auto& repfield = this->_internal_custom_attributes().Get(i);
        target = ::google::protobuf::internal::WireFormatLite::InternalWriteMessage(
            15, repfield, repfield.GetCachedSize(), target, stream);
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
    // @@protoc_insertion_point(serialize_to_array_end:turms.client.model.proto.Meeting)
    return target;
}

::size_t Meeting::ByteSizeLong() const {
    // @@protoc_insertion_point(message_byte_size_start:turms.client.model.proto.Meeting)
    ::size_t total_size = 0;

    ::uint32_t cached_has_bits = 0;
    // Prevent compiler warnings about cached_has_bits being unused
    (void)cached_has_bits;

    ::_pbi::Prefetch5LinesFrom7Lines(reinterpret_cast<const void*>(this));
    // repeated .turms.client.model.proto.Value custom_attributes = 15;
    total_size += 1UL * this->_internal_custom_attributes_size();
    for (const auto& msg : this->_internal_custom_attributes()) {
        total_size += ::google::protobuf::internal::WireFormatLite::MessageSize(msg);
    }
    cached_has_bits = _impl_._has_bits_[0];
    if (cached_has_bits & 0x0000000fu) {
        // optional string access_token = 5;
        if (cached_has_bits & 0x00000001u) {
            total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                  this->_internal_access_token());
        }

        // optional string name = 6;
        if (cached_has_bits & 0x00000002u) {
            total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                  this->_internal_name());
        }

        // optional string intro = 7;
        if (cached_has_bits & 0x00000004u) {
            total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                  this->_internal_intro());
        }

        // optional string password = 8;
        if (cached_has_bits & 0x00000008u) {
            total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                  this->_internal_password());
        }
    }
    // int64 id = 1;
    if (this->_internal_id() != 0) {
        total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_id());
    }

    if (cached_has_bits & 0x00000030u) {
        // optional int64 user_id = 2;
        if (cached_has_bits & 0x00000010u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_user_id());
        }

        // optional int64 group_id = 3;
        if (cached_has_bits & 0x00000020u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_group_id());
        }
    }
    // int64 creator_id = 4;
    if (this->_internal_creator_id() != 0) {
        total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_creator_id());
    }

    // int64 start_date = 9;
    if (this->_internal_start_date() != 0) {
        total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_start_date());
    }

    if (cached_has_bits & 0x000000c0u) {
        // optional int64 end_date = 10;
        if (cached_has_bits & 0x00000040u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_end_date());
        }

        // optional int64 cancel_date = 11;
        if (cached_has_bits & 0x00000080u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_cancel_date());
        }
    }
    if (PROTOBUF_PREDICT_FALSE(_internal_metadata_.have_unknown_fields())) {
        total_size += _internal_metadata_
                          .unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString)
                          .size();
    }
    _impl_._cached_size_.Set(::_pbi::ToCachedSize(total_size));
    return total_size;
}

void Meeting::CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from) {
    MergeFrom(*::_pbi::DownCast<const Meeting*>(&from));
}

void Meeting::MergeFrom(const Meeting& from) {
    Meeting* const _this = this;
    // @@protoc_insertion_point(class_specific_merge_from_start:turms.client.model.proto.Meeting)
    ABSL_DCHECK_NE(&from, _this);
    ::uint32_t cached_has_bits = 0;
    (void)cached_has_bits;

    _this->_internal_mutable_custom_attributes()->MergeFrom(from._internal_custom_attributes());
    cached_has_bits = from._impl_._has_bits_[0];
    if (cached_has_bits & 0x0000000fu) {
        if (cached_has_bits & 0x00000001u) {
            _this->_internal_set_access_token(from._internal_access_token());
        }
        if (cached_has_bits & 0x00000002u) {
            _this->_internal_set_name(from._internal_name());
        }
        if (cached_has_bits & 0x00000004u) {
            _this->_internal_set_intro(from._internal_intro());
        }
        if (cached_has_bits & 0x00000008u) {
            _this->_internal_set_password(from._internal_password());
        }
    }
    if (from._internal_id() != 0) {
        _this->_impl_.id_ = from._impl_.id_;
    }
    if (cached_has_bits & 0x00000030u) {
        if (cached_has_bits & 0x00000010u) {
            _this->_impl_.user_id_ = from._impl_.user_id_;
        }
        if (cached_has_bits & 0x00000020u) {
            _this->_impl_.group_id_ = from._impl_.group_id_;
        }
    }
    if (from._internal_creator_id() != 0) {
        _this->_impl_.creator_id_ = from._impl_.creator_id_;
    }
    if (from._internal_start_date() != 0) {
        _this->_impl_.start_date_ = from._impl_.start_date_;
    }
    if (cached_has_bits & 0x000000c0u) {
        if (cached_has_bits & 0x00000040u) {
            _this->_impl_.end_date_ = from._impl_.end_date_;
        }
        if (cached_has_bits & 0x00000080u) {
            _this->_impl_.cancel_date_ = from._impl_.cancel_date_;
        }
    }
    _this->_impl_._has_bits_[0] |= cached_has_bits;
    _this->_internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
}

void Meeting::CopyFrom(const Meeting& from) {
    // @@protoc_insertion_point(class_specific_copy_from_start:turms.client.model.proto.Meeting)
    if (&from == this)
        return;
    Clear();
    MergeFrom(from);
}

void Meeting::InternalSwap(Meeting* PROTOBUF_RESTRICT other) {
    using std::swap;
    auto* arena = GetArena();
    ABSL_DCHECK_EQ(arena, other->GetArena());
    _internal_metadata_.InternalSwap(&other->_internal_metadata_);
    swap(_impl_._has_bits_[0], other->_impl_._has_bits_[0]);
    _impl_.custom_attributes_.InternalSwap(&other->_impl_.custom_attributes_);
    ::_pbi::ArenaStringPtr::InternalSwap(
        &_impl_.access_token_, &other->_impl_.access_token_, arena);
    ::_pbi::ArenaStringPtr::InternalSwap(&_impl_.name_, &other->_impl_.name_, arena);
    ::_pbi::ArenaStringPtr::InternalSwap(&_impl_.intro_, &other->_impl_.intro_, arena);
    ::_pbi::ArenaStringPtr::InternalSwap(&_impl_.password_, &other->_impl_.password_, arena);
    ::google::protobuf::internal::memswap<PROTOBUF_FIELD_OFFSET(Meeting, _impl_.cancel_date_) +
                                          sizeof(Meeting::_impl_.cancel_date_) -
                                          PROTOBUF_FIELD_OFFSET(Meeting, _impl_.id_)>(
        reinterpret_cast<char*>(&_impl_.id_), reinterpret_cast<char*>(&other->_impl_.id_));
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