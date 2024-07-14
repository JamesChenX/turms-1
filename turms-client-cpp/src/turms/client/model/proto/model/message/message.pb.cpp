// Generated by the protocol buffer compiler.  DO NOT EDIT!
// NO CHECKED-IN PROTOBUF GENCODE
// source: model/message/message.proto
// Protobuf C++ Version: 5.27.2

#include "turms/client/model/proto/model/message/message.pb.h"

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

inline constexpr Message::Impl_::Impl_(::_pbi::ConstantInitialized) noexcept
    : _cached_size_{0},
      records_{},
      reaction_groups_{},
      custom_attributes_{},
      text_(&::google::protobuf::internal::fixed_address_empty_string,
            ::_pbi::ConstantInitialized()),
      id_{::int64_t{0}},
      delivery_date_{::int64_t{0}},
      modification_date_{::int64_t{0}},
      sender_id_{::int64_t{0}},
      group_id_{::int64_t{0}},
      recipient_id_{::int64_t{0}},
      is_system_message_{false},
      sequence_id_{0},
      pre_message_id_{::int64_t{0}} {
}

template <typename>
PROTOBUF_CONSTEXPR Message::Message(::_pbi::ConstantInitialized)
    : _impl_(::_pbi::ConstantInitialized()) {
}
struct MessageDefaultTypeInternal {
    PROTOBUF_CONSTEXPR MessageDefaultTypeInternal()
        : _instance(::_pbi::ConstantInitialized{}) {
    }
    ~MessageDefaultTypeInternal() {
    }
    union {
        Message _instance;
    };
};

PROTOBUF_ATTRIBUTE_NO_DESTROY PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1
    MessageDefaultTypeInternal _Message_default_instance_;
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace turms {
namespace client {
namespace model {
namespace proto {
// ===================================================================

class Message::_Internal {
   public:
    using HasBits = decltype(std::declval<Message>()._impl_._has_bits_);
    static constexpr ::int32_t kHasBitsOffset =
        8 * PROTOBUF_FIELD_OFFSET(Message, _impl_._has_bits_);
};

void Message::clear_reaction_groups() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.reaction_groups_.Clear();
}
void Message::clear_custom_attributes() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.custom_attributes_.Clear();
}
Message::Message(::google::protobuf::Arena* arena)
    : ::google::protobuf::MessageLite(arena) {
    SharedCtor(arena);
    // @@protoc_insertion_point(arena_constructor:turms.client.model.proto.Message)
}
inline PROTOBUF_NDEBUG_INLINE Message::Impl_::Impl_(
    ::google::protobuf::internal::InternalVisibility visibility,
    ::google::protobuf::Arena* arena,
    const Impl_& from,
    const ::turms::client::model::proto::Message& from_msg)
    : _has_bits_{from._has_bits_},
      _cached_size_{0},
      records_{visibility, arena, from.records_},
      reaction_groups_{visibility, arena, from.reaction_groups_},
      custom_attributes_{visibility, arena, from.custom_attributes_},
      text_(arena, from.text_) {
}

Message::Message(::google::protobuf::Arena* arena, const Message& from)
    : ::google::protobuf::MessageLite(arena) {
    Message* const _this = this;
    (void)_this;
    _internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
    new (&_impl_) Impl_(internal_visibility(), arena, from._impl_, from);
    ::memcpy(
        reinterpret_cast<char*>(&_impl_) + offsetof(Impl_, id_),
        reinterpret_cast<const char*>(&from._impl_) + offsetof(Impl_, id_),
        offsetof(Impl_, pre_message_id_) - offsetof(Impl_, id_) + sizeof(Impl_::pre_message_id_));

    // @@protoc_insertion_point(copy_constructor:turms.client.model.proto.Message)
}
inline PROTOBUF_NDEBUG_INLINE Message::Impl_::Impl_(
    ::google::protobuf::internal::InternalVisibility visibility, ::google::protobuf::Arena* arena)
    : _cached_size_{0},
      records_{visibility, arena},
      reaction_groups_{visibility, arena},
      custom_attributes_{visibility, arena},
      text_(arena) {
}

inline void Message::SharedCtor(::_pb::Arena* arena) {
    new (&_impl_) Impl_(internal_visibility(), arena);
    ::memset(
        reinterpret_cast<char*>(&_impl_) + offsetof(Impl_, id_),
        0,
        offsetof(Impl_, pre_message_id_) - offsetof(Impl_, id_) + sizeof(Impl_::pre_message_id_));
}
Message::~Message() {
    // @@protoc_insertion_point(destructor:turms.client.model.proto.Message)
    _internal_metadata_.Delete<std::string>();
    SharedDtor();
}
inline void Message::SharedDtor() {
    ABSL_DCHECK(GetArena() == nullptr);
    _impl_.text_.Destroy();
    _impl_.~Impl_();
}

const ::google::protobuf::MessageLite::ClassData* Message::GetClassData() const {
    PROTOBUF_CONSTINIT static const ClassDataLite<33> _data_ = {
        {
            &_table_.header,
            nullptr,  // OnDemandRegisterArenaDtor
            nullptr,  // IsInitialized
            PROTOBUF_FIELD_OFFSET(Message, _impl_._cached_size_),
            true,
        },
        "turms.client.model.proto.Message",
    };

    return _data_.base();
}
PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1 const ::_pbi::TcParseTable<4, 13, 2, 53, 2>
    Message::_table_ = {
        {
            PROTOBUF_FIELD_OFFSET(Message, _impl_._has_bits_),
            0,  // no _extensions_
            15,
            120,  // max_field_number, fast_idx_mask
            offsetof(decltype(_table_), field_lookup_table),
            4294946816,  // skipmap
            offsetof(decltype(_table_), field_entries),
            13,  // num_field_entries
            2,   // num_aux_entries
            offsetof(decltype(_table_), aux_entries),
            &_Message_default_instance_._instance,
            nullptr,                                // post_loop_handler
            ::_pbi::TcParser::GenericFallbackLite,  // fallback
#ifdef PROTOBUF_PREFETCH_PARSE_TABLE
            ::_pbi::TcParser::GetTable<::turms::client::model::proto::Message>(),  // to_prefetch
#endif  // PROTOBUF_PREFETCH_PARSE_TABLE
        },
        {{
            {::_pbi::TcParser::MiniParse, {}},
            // optional int64 id = 1;
            {::_pbi::TcParser::FastV64S1, {8, 1, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.id_)}},
            // optional int64 delivery_date = 2;
            {::_pbi::TcParser::FastV64S1,
             {16, 2, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.delivery_date_)}},
            // optional int64 modification_date = 3;
            {::_pbi::TcParser::FastV64S1,
             {24, 3, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.modification_date_)}},
            // optional string text = 4;
            {::_pbi::TcParser::FastUS1, {34, 0, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.text_)}},
            // optional int64 sender_id = 5;
            {::_pbi::TcParser::FastV64S1,
             {40, 4, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.sender_id_)}},
            // optional int64 group_id = 6;
            {::_pbi::TcParser::FastV64S1,
             {48, 5, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.group_id_)}},
            // optional bool is_system_message = 7;
            {::_pbi::TcParser::FastV8S1,
             {56, 7, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.is_system_message_)}},
            // optional int64 recipient_id = 8;
            {::_pbi::TcParser::FastV64S1,
             {64, 6, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.recipient_id_)}},
            // repeated bytes records = 9;
            {::_pbi::TcParser::FastBR1,
             {74, 63, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.records_)}},
            // optional int32 sequence_id = 10;
            {::_pbi::TcParser::FastV32S1,
             {80, 8, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.sequence_id_)}},
            // optional int64 pre_message_id = 11;
            {::_pbi::TcParser::FastV64S1,
             {88, 9, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.pre_message_id_)}},
            // repeated .turms.client.model.proto.MessageReactionGroup reaction_groups = 12;
            {::_pbi::TcParser::FastMtR1,
             {98, 63, 0, PROTOBUF_FIELD_OFFSET(Message, _impl_.reaction_groups_)}},
            {::_pbi::TcParser::MiniParse, {}},
            {::_pbi::TcParser::MiniParse, {}},
            // repeated .turms.client.model.proto.Value custom_attributes = 15;
            {::_pbi::TcParser::FastMtR1,
             {122, 63, 1, PROTOBUF_FIELD_OFFSET(Message, _impl_.custom_attributes_)}},
        }},
        {{65535, 65535}},
        {{
            // optional int64 id = 1;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.id_),
             _Internal::kHasBitsOffset + 1,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional int64 delivery_date = 2;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.delivery_date_),
             _Internal::kHasBitsOffset + 2,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional int64 modification_date = 3;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.modification_date_),
             _Internal::kHasBitsOffset + 3,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional string text = 4;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.text_),
             _Internal::kHasBitsOffset + 0,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kUtf8String | ::_fl::kRepAString)},
            // optional int64 sender_id = 5;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.sender_id_),
             _Internal::kHasBitsOffset + 4,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional int64 group_id = 6;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.group_id_),
             _Internal::kHasBitsOffset + 5,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // optional bool is_system_message = 7;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.is_system_message_),
             _Internal::kHasBitsOffset + 7,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kBool)},
            // optional int64 recipient_id = 8;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.recipient_id_),
             _Internal::kHasBitsOffset + 6,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // repeated bytes records = 9;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.records_),
             -1,
             0,
             (0 | ::_fl::kFcRepeated | ::_fl::kBytes | ::_fl::kRepSString)},
            // optional int32 sequence_id = 10;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.sequence_id_),
             _Internal::kHasBitsOffset + 8,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt32)},
            // optional int64 pre_message_id = 11;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.pre_message_id_),
             _Internal::kHasBitsOffset + 9,
             0,
             (0 | ::_fl::kFcOptional | ::_fl::kInt64)},
            // repeated .turms.client.model.proto.MessageReactionGroup reaction_groups = 12;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.reaction_groups_),
             -1,
             0,
             (0 | ::_fl::kFcRepeated | ::_fl::kMessage | ::_fl::kTvTable)},
            // repeated .turms.client.model.proto.Value custom_attributes = 15;
            {PROTOBUF_FIELD_OFFSET(Message, _impl_.custom_attributes_),
             -1,
             1,
             (0 | ::_fl::kFcRepeated | ::_fl::kMessage | ::_fl::kTvTable)},
        }},
        {{
            {::_pbi::TcParser::GetTable<::turms::client::model::proto::MessageReactionGroup>()},
            {::_pbi::TcParser::GetTable<::turms::client::model::proto::Value>()},
        }},
        {{"\40\0\0\0\4\0\0\0\0\0\0\0\0\0\0\0"
          "turms.client.model.proto.Message"
          "text"}},
};

PROTOBUF_NOINLINE void Message::Clear() {
    // @@protoc_insertion_point(message_clear_start:turms.client.model.proto.Message)
    ::google::protobuf::internal::TSanWrite(&_impl_);
    ::uint32_t cached_has_bits = 0;
    // Prevent compiler warnings about cached_has_bits being unused
    (void)cached_has_bits;

    _impl_.records_.Clear();
    _impl_.reaction_groups_.Clear();
    _impl_.custom_attributes_.Clear();
    cached_has_bits = _impl_._has_bits_[0];
    if (cached_has_bits & 0x00000001u) {
        _impl_.text_.ClearNonDefaultToEmpty();
    }
    if (cached_has_bits & 0x000000feu) {
        ::memset(&_impl_.id_,
                 0,
                 static_cast<::size_t>(reinterpret_cast<char*>(&_impl_.is_system_message_) -
                                       reinterpret_cast<char*>(&_impl_.id_)) +
                     sizeof(_impl_.is_system_message_));
    }
    if (cached_has_bits & 0x00000300u) {
        ::memset(&_impl_.sequence_id_,
                 0,
                 static_cast<::size_t>(reinterpret_cast<char*>(&_impl_.pre_message_id_) -
                                       reinterpret_cast<char*>(&_impl_.sequence_id_)) +
                     sizeof(_impl_.pre_message_id_));
    }
    _impl_._has_bits_.Clear();
    _internal_metadata_.Clear<std::string>();
}

::uint8_t* Message::_InternalSerialize(::uint8_t* target,
                                       ::google::protobuf::io::EpsCopyOutputStream* stream) const {
    // @@protoc_insertion_point(serialize_to_array_start:turms.client.model.proto.Message)
    ::uint32_t cached_has_bits = 0;
    (void)cached_has_bits;

    cached_has_bits = _impl_._has_bits_[0];
    // optional int64 id = 1;
    if (cached_has_bits & 0x00000002u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<1>(
            stream, this->_internal_id(), target);
    }

    // optional int64 delivery_date = 2;
    if (cached_has_bits & 0x00000004u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<2>(
            stream, this->_internal_delivery_date(), target);
    }

    // optional int64 modification_date = 3;
    if (cached_has_bits & 0x00000008u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<3>(
            stream, this->_internal_modification_date(), target);
    }

    // optional string text = 4;
    if (cached_has_bits & 0x00000001u) {
        const std::string& _s = this->_internal_text();
        ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
            _s.data(),
            static_cast<int>(_s.length()),
            ::google::protobuf::internal::WireFormatLite::SERIALIZE,
            "turms.client.model.proto.Message.text");
        target = stream->WriteStringMaybeAliased(4, _s, target);
    }

    // optional int64 sender_id = 5;
    if (cached_has_bits & 0x00000010u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<5>(
            stream, this->_internal_sender_id(), target);
    }

    // optional int64 group_id = 6;
    if (cached_has_bits & 0x00000020u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<6>(
            stream, this->_internal_group_id(), target);
    }

    // optional bool is_system_message = 7;
    if (cached_has_bits & 0x00000080u) {
        target = stream->EnsureSpace(target);
        target = ::_pbi::WireFormatLite::WriteBoolToArray(
            7, this->_internal_is_system_message(), target);
    }

    // optional int64 recipient_id = 8;
    if (cached_has_bits & 0x00000040u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<8>(
            stream, this->_internal_recipient_id(), target);
    }

    // repeated bytes records = 9;
    for (int i = 0, n = this->_internal_records_size(); i < n; ++i) {
        const auto& s = this->_internal_records().Get(i);
        target = stream->WriteBytes(9, s, target);
    }

    // optional int32 sequence_id = 10;
    if (cached_has_bits & 0x00000100u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt32ToArrayWithField<10>(
            stream, this->_internal_sequence_id(), target);
    }

    // optional int64 pre_message_id = 11;
    if (cached_has_bits & 0x00000200u) {
        target = ::google::protobuf::internal::WireFormatLite::WriteInt64ToArrayWithField<11>(
            stream, this->_internal_pre_message_id(), target);
    }

    // repeated .turms.client.model.proto.MessageReactionGroup reaction_groups = 12;
    for (unsigned i = 0, n = static_cast<unsigned>(this->_internal_reaction_groups_size()); i < n;
         i++) {
        const auto& repfield = this->_internal_reaction_groups().Get(i);
        target = ::google::protobuf::internal::WireFormatLite::InternalWriteMessage(
            12, repfield, repfield.GetCachedSize(), target, stream);
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
    // @@protoc_insertion_point(serialize_to_array_end:turms.client.model.proto.Message)
    return target;
}

::size_t Message::ByteSizeLong() const {
    // @@protoc_insertion_point(message_byte_size_start:turms.client.model.proto.Message)
    ::size_t total_size = 0;

    ::uint32_t cached_has_bits = 0;
    // Prevent compiler warnings about cached_has_bits being unused
    (void)cached_has_bits;

    ::_pbi::Prefetch5LinesFrom7Lines(reinterpret_cast<const void*>(this));
    // repeated bytes records = 9;
    total_size += 1 * ::google::protobuf::internal::FromIntSize(_internal_records().size());
    for (int i = 0, n = _internal_records().size(); i < n; ++i) {
        total_size +=
            ::google::protobuf::internal::WireFormatLite::BytesSize(_internal_records().Get(i));
    }
    // repeated .turms.client.model.proto.MessageReactionGroup reaction_groups = 12;
    total_size += 1UL * this->_internal_reaction_groups_size();
    for (const auto& msg : this->_internal_reaction_groups()) {
        total_size += ::google::protobuf::internal::WireFormatLite::MessageSize(msg);
    }
    // repeated .turms.client.model.proto.Value custom_attributes = 15;
    total_size += 1UL * this->_internal_custom_attributes_size();
    for (const auto& msg : this->_internal_custom_attributes()) {
        total_size += ::google::protobuf::internal::WireFormatLite::MessageSize(msg);
    }
    cached_has_bits = _impl_._has_bits_[0];
    if (cached_has_bits & 0x000000ffu) {
        // optional string text = 4;
        if (cached_has_bits & 0x00000001u) {
            total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                  this->_internal_text());
        }

        // optional int64 id = 1;
        if (cached_has_bits & 0x00000002u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_id());
        }

        // optional int64 delivery_date = 2;
        if (cached_has_bits & 0x00000004u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_delivery_date());
        }

        // optional int64 modification_date = 3;
        if (cached_has_bits & 0x00000008u) {
            total_size +=
                ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_modification_date());
        }

        // optional int64 sender_id = 5;
        if (cached_has_bits & 0x00000010u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_sender_id());
        }

        // optional int64 group_id = 6;
        if (cached_has_bits & 0x00000020u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_group_id());
        }

        // optional int64 recipient_id = 8;
        if (cached_has_bits & 0x00000040u) {
            total_size += ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_recipient_id());
        }

        // optional bool is_system_message = 7;
        if (cached_has_bits & 0x00000080u) {
            total_size += 2;
        }
    }
    if (cached_has_bits & 0x00000300u) {
        // optional int32 sequence_id = 10;
        if (cached_has_bits & 0x00000100u) {
            total_size += ::_pbi::WireFormatLite::Int32SizePlusOne(this->_internal_sequence_id());
        }

        // optional int64 pre_message_id = 11;
        if (cached_has_bits & 0x00000200u) {
            total_size +=
                ::_pbi::WireFormatLite::Int64SizePlusOne(this->_internal_pre_message_id());
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

void Message::CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from) {
    MergeFrom(*::_pbi::DownCast<const Message*>(&from));
}

void Message::MergeFrom(const Message& from) {
    Message* const _this = this;
    // @@protoc_insertion_point(class_specific_merge_from_start:turms.client.model.proto.Message)
    ABSL_DCHECK_NE(&from, _this);
    ::uint32_t cached_has_bits = 0;
    (void)cached_has_bits;

    _this->_internal_mutable_records()->MergeFrom(from._internal_records());
    _this->_internal_mutable_reaction_groups()->MergeFrom(from._internal_reaction_groups());
    _this->_internal_mutable_custom_attributes()->MergeFrom(from._internal_custom_attributes());
    cached_has_bits = from._impl_._has_bits_[0];
    if (cached_has_bits & 0x000000ffu) {
        if (cached_has_bits & 0x00000001u) {
            _this->_internal_set_text(from._internal_text());
        }
        if (cached_has_bits & 0x00000002u) {
            _this->_impl_.id_ = from._impl_.id_;
        }
        if (cached_has_bits & 0x00000004u) {
            _this->_impl_.delivery_date_ = from._impl_.delivery_date_;
        }
        if (cached_has_bits & 0x00000008u) {
            _this->_impl_.modification_date_ = from._impl_.modification_date_;
        }
        if (cached_has_bits & 0x00000010u) {
            _this->_impl_.sender_id_ = from._impl_.sender_id_;
        }
        if (cached_has_bits & 0x00000020u) {
            _this->_impl_.group_id_ = from._impl_.group_id_;
        }
        if (cached_has_bits & 0x00000040u) {
            _this->_impl_.recipient_id_ = from._impl_.recipient_id_;
        }
        if (cached_has_bits & 0x00000080u) {
            _this->_impl_.is_system_message_ = from._impl_.is_system_message_;
        }
    }
    if (cached_has_bits & 0x00000300u) {
        if (cached_has_bits & 0x00000100u) {
            _this->_impl_.sequence_id_ = from._impl_.sequence_id_;
        }
        if (cached_has_bits & 0x00000200u) {
            _this->_impl_.pre_message_id_ = from._impl_.pre_message_id_;
        }
    }
    _this->_impl_._has_bits_[0] |= cached_has_bits;
    _this->_internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
}

void Message::CopyFrom(const Message& from) {
    // @@protoc_insertion_point(class_specific_copy_from_start:turms.client.model.proto.Message)
    if (&from == this)
        return;
    Clear();
    MergeFrom(from);
}

void Message::InternalSwap(Message* PROTOBUF_RESTRICT other) {
    using std::swap;
    auto* arena = GetArena();
    ABSL_DCHECK_EQ(arena, other->GetArena());
    _internal_metadata_.InternalSwap(&other->_internal_metadata_);
    swap(_impl_._has_bits_[0], other->_impl_._has_bits_[0]);
    _impl_.records_.InternalSwap(&other->_impl_.records_);
    _impl_.reaction_groups_.InternalSwap(&other->_impl_.reaction_groups_);
    _impl_.custom_attributes_.InternalSwap(&other->_impl_.custom_attributes_);
    ::_pbi::ArenaStringPtr::InternalSwap(&_impl_.text_, &other->_impl_.text_, arena);
    ::google::protobuf::internal::memswap<PROTOBUF_FIELD_OFFSET(Message, _impl_.pre_message_id_) +
                                          sizeof(Message::_impl_.pre_message_id_) -
                                          PROTOBUF_FIELD_OFFSET(Message, _impl_.id_)>(
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