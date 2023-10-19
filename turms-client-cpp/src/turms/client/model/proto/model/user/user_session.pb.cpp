// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: model/user/user_session.proto

#include "turms/client/model/proto/model/user/user_session.pb.h"

#include <algorithm>
#include "google/protobuf/io/coded_stream.h"
#include "google/protobuf/extension_set.h"
#include "google/protobuf/wire_format_lite.h"
#include "google/protobuf/io/zero_copy_stream_impl_lite.h"
#include "google/protobuf/generated_message_tctable_impl.h"
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
        template <typename>
PROTOBUF_CONSTEXPR UserSession::UserSession(::_pbi::ConstantInitialized)
    : _impl_{
      /*decltype(_impl_.session_id_)*/ {
          &::_pbi::fixed_address_empty_string,
          ::_pbi::ConstantInitialized{},
      },
      /*decltype(_impl_.server_id_)*/ {
          &::_pbi::fixed_address_empty_string,
          ::_pbi::ConstantInitialized{},
      },
      /*decltype(_impl_._cached_size_)*/ {},
    } {}
struct UserSessionDefaultTypeInternal {
  PROTOBUF_CONSTEXPR UserSessionDefaultTypeInternal() : _instance(::_pbi::ConstantInitialized{}) {}
  ~UserSessionDefaultTypeInternal() {}
  union {
    UserSession _instance;
  };
};

PROTOBUF_ATTRIBUTE_NO_DESTROY PROTOBUF_CONSTINIT
    PROTOBUF_ATTRIBUTE_INIT_PRIORITY1 UserSessionDefaultTypeInternal _UserSession_default_instance_;
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace turms {
namespace client {
namespace model {
namespace proto {
// ===================================================================

class UserSession::_Internal {
 public:
};

UserSession::UserSession(::google::protobuf::Arena* arena)
    : ::google::protobuf::MessageLite(arena) {
  SharedCtor(arena);
  // @@protoc_insertion_point(arena_constructor:turms.client.model.proto.UserSession)
}
UserSession::UserSession(const UserSession& from) : ::google::protobuf::MessageLite() {
  UserSession* const _this = this;
  (void)_this;
  new (&_impl_) Impl_{
      decltype(_impl_.session_id_){},
      decltype(_impl_.server_id_){},
      /*decltype(_impl_._cached_size_)*/ {},
  };
  _internal_metadata_.MergeFrom<std::string>(
      from._internal_metadata_);
  _impl_.session_id_.InitDefault();
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        _impl_.session_id_.Set("", GetArenaForAllocation());
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  if (!from._internal_session_id().empty()) {
    _this->_impl_.session_id_.Set(from._internal_session_id(), _this->GetArenaForAllocation());
  }
  _impl_.server_id_.InitDefault();
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        _impl_.server_id_.Set("", GetArenaForAllocation());
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  if (!from._internal_server_id().empty()) {
    _this->_impl_.server_id_.Set(from._internal_server_id(), _this->GetArenaForAllocation());
  }

  // @@protoc_insertion_point(copy_constructor:turms.client.model.proto.UserSession)
}
inline void UserSession::SharedCtor(::_pb::Arena* arena) {
  (void)arena;
  new (&_impl_) Impl_{
      decltype(_impl_.session_id_){},
      decltype(_impl_.server_id_){},
      /*decltype(_impl_._cached_size_)*/ {},
  };
  _impl_.session_id_.InitDefault();
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        _impl_.session_id_.Set("", GetArenaForAllocation());
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  _impl_.server_id_.InitDefault();
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        _impl_.server_id_.Set("", GetArenaForAllocation());
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
}
UserSession::~UserSession() {
  // @@protoc_insertion_point(destructor:turms.client.model.proto.UserSession)
  _internal_metadata_.Delete<std::string>();
  SharedDtor();
}
inline void UserSession::SharedDtor() {
  ABSL_DCHECK(GetArenaForAllocation() == nullptr);
  _impl_.session_id_.Destroy();
  _impl_.server_id_.Destroy();
}
void UserSession::SetCachedSize(int size) const {
  _impl_._cached_size_.Set(size);
}

PROTOBUF_NOINLINE void UserSession::Clear() {
// @@protoc_insertion_point(message_clear_start:turms.client.model.proto.UserSession)
  ::uint32_t cached_has_bits = 0;
  // Prevent compiler warnings about cached_has_bits being unused
  (void) cached_has_bits;

  _impl_.session_id_.ClearToEmpty();
  _impl_.server_id_.ClearToEmpty();
  _internal_metadata_.Clear<std::string>();
}

const char* UserSession::_InternalParse(
    const char* ptr, ::_pbi::ParseContext* ctx) {
  ptr = ::_pbi::TcParser::ParseLoop(this, ptr, ctx, &_table_.header);
  return ptr;
}


PROTOBUF_CONSTINIT PROTOBUF_ATTRIBUTE_INIT_PRIORITY1
const ::_pbi::TcParseTable<1, 2, 0, 64, 2> UserSession::_table_ = {
  {
    0,  // no _has_bits_
    0, // no _extensions_
    2, 8,  // max_field_number, fast_idx_mask
    offsetof(decltype(_table_), field_lookup_table),
    4294967292,  // skipmap
    offsetof(decltype(_table_), field_entries),
    2,  // num_field_entries
    0,  // num_aux_entries
    offsetof(decltype(_table_), field_names),  // no aux_entries
    &_UserSession_default_instance_._instance,
    ::_pbi::TcParser::GenericFallbackLite,  // fallback
  }, {{
    // string server_id = 2;
    {::_pbi::TcParser::FastUS1,
     {18, 63, 0, PROTOBUF_FIELD_OFFSET(UserSession, _impl_.server_id_)}},
    // string session_id = 1;
    {::_pbi::TcParser::FastUS1,
     {10, 63, 0, PROTOBUF_FIELD_OFFSET(UserSession, _impl_.session_id_)}},
  }}, {{
    65535, 65535
  }}, {{
    // string session_id = 1;
    {PROTOBUF_FIELD_OFFSET(UserSession, _impl_.session_id_), 0, 0,
    (0 | ::_fl::kFcSingular | ::_fl::kUtf8String | ::_fl::kRepAString)},
    // string server_id = 2;
    {PROTOBUF_FIELD_OFFSET(UserSession, _impl_.server_id_), 0, 0,
    (0 | ::_fl::kFcSingular | ::_fl::kUtf8String | ::_fl::kRepAString)},
  }},
  // no aux_entries
  {{
    "\44\12\11\0\0\0\0\0"
    "turms.client.model.proto.UserSession"
    "session_id"
    "server_id"
  }},
};

::uint8_t* UserSession::_InternalSerialize(
    ::uint8_t* target,
    ::google::protobuf::io::EpsCopyOutputStream* stream) const {
  // @@protoc_insertion_point(serialize_to_array_start:turms.client.model.proto.UserSession)
  ::uint32_t cached_has_bits = 0;
  (void)cached_has_bits;

  // string session_id = 1;
  if (!this->_internal_session_id().empty()) {
    const std::string& _s = this->_internal_session_id();
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
        _s.data(), static_cast<int>(_s.length()), ::google::protobuf::internal::WireFormatLite::SERIALIZE, "turms.client.model.proto.UserSession.session_id");
    target = stream->WriteStringMaybeAliased(1, _s, target);
  }

  // string server_id = 2;
  if (!this->_internal_server_id().empty()) {
    const std::string& _s = this->_internal_server_id();
    ::google::protobuf::internal::WireFormatLite::VerifyUtf8String(
        _s.data(), static_cast<int>(_s.length()), ::google::protobuf::internal::WireFormatLite::SERIALIZE, "turms.client.model.proto.UserSession.server_id");
    target = stream->WriteStringMaybeAliased(2, _s, target);
  }

  if (PROTOBUF_PREDICT_FALSE(_internal_metadata_.have_unknown_fields())) {
    target = stream->WriteRaw(
        _internal_metadata_.unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString).data(),
        static_cast<int>(_internal_metadata_.unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString).size()), target);
  }
  // @@protoc_insertion_point(serialize_to_array_end:turms.client.model.proto.UserSession)
  return target;
}

::size_t UserSession::ByteSizeLong() const {
// @@protoc_insertion_point(message_byte_size_start:turms.client.model.proto.UserSession)
  ::size_t total_size = 0;

  ::uint32_t cached_has_bits = 0;
  // Prevent compiler warnings about cached_has_bits being unused
  (void) cached_has_bits;

  // string session_id = 1;
  if (!this->_internal_session_id().empty()) {
    total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                    this->_internal_session_id());
  }

  // string server_id = 2;
  if (!this->_internal_server_id().empty()) {
    total_size += 1 + ::google::protobuf::internal::WireFormatLite::StringSize(
                                    this->_internal_server_id());
  }

  if (PROTOBUF_PREDICT_FALSE(_internal_metadata_.have_unknown_fields())) {
    total_size += _internal_metadata_.unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString).size();
  }
  int cached_size = ::_pbi::ToCachedSize(total_size);
  SetCachedSize(cached_size);
  return total_size;
}

void UserSession::CheckTypeAndMergeFrom(
    const ::google::protobuf::MessageLite& from) {
  MergeFrom(*::_pbi::DownCast<const UserSession*>(
      &from));
}

void UserSession::MergeFrom(const UserSession& from) {
  UserSession* const _this = this;
  // @@protoc_insertion_point(class_specific_merge_from_start:turms.client.model.proto.UserSession)
  ABSL_DCHECK_NE(&from, _this);
  ::uint32_t cached_has_bits = 0;
  (void) cached_has_bits;

  if (!from._internal_session_id().empty()) {
    _this->_internal_set_session_id(from._internal_session_id());
  }
  if (!from._internal_server_id().empty()) {
    _this->_internal_set_server_id(from._internal_server_id());
  }
  _this->_internal_metadata_.MergeFrom<std::string>(from._internal_metadata_);
}

void UserSession::CopyFrom(const UserSession& from) {
// @@protoc_insertion_point(class_specific_copy_from_start:turms.client.model.proto.UserSession)
  if (&from == this) return;
  Clear();
  MergeFrom(from);
}

PROTOBUF_NOINLINE bool UserSession::IsInitialized() const {
  return true;
}

void UserSession::InternalSwap(UserSession* other) {
  using std::swap;
  auto* lhs_arena = GetArenaForAllocation();
  auto* rhs_arena = other->GetArenaForAllocation();
  _internal_metadata_.InternalSwap(&other->_internal_metadata_);
  ::_pbi::ArenaStringPtr::InternalSwap(&_impl_.session_id_, lhs_arena,
                                       &other->_impl_.session_id_, rhs_arena);
  ::_pbi::ArenaStringPtr::InternalSwap(&_impl_.server_id_, lhs_arena,
                                       &other->_impl_.server_id_, rhs_arena);
}

std::string UserSession::GetTypeName() const {
  return "turms.client.model.proto.UserSession";
}

// @@protoc_insertion_point(namespace_scope)
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace google {
namespace protobuf {
}  // namespace protobuf
}  // namespace google
// @@protoc_insertion_point(global_scope)
#include "google/protobuf/port_undef.inc"