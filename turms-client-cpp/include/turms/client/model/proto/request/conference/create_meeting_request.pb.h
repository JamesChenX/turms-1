// Generated by the protocol buffer compiler.  DO NOT EDIT!
// NO CHECKED-IN PROTOBUF GENCODE
// source: request/conference/create_meeting_request.proto
// Protobuf C++ Version: 5.27.2

#ifndef GOOGLE_PROTOBUF_INCLUDED_request_2fconference_2fcreate_5fmeeting_5frequest_2eproto_2epb_2eh
#define GOOGLE_PROTOBUF_INCLUDED_request_2fconference_2fcreate_5fmeeting_5frequest_2eproto_2epb_2eh

#include <limits>
#include <string>
#include <type_traits>
#include <utility>

#include "google/protobuf/runtime_version.h"
#if PROTOBUF_VERSION != 5027002
#error "Protobuf C++ gencode is built with an incompatible version of"
#error "Protobuf C++ headers/runtime. See"
#error "https://protobuf.dev/support/cross-version-runtime-guarantee/#cpp"
#endif
#include "google/protobuf/arena.h"
#include "google/protobuf/arenastring.h"
#include "google/protobuf/extension_set.h"  // IWYU pragma: export
#include "google/protobuf/generated_message_tctable_decl.h"
#include "google/protobuf/generated_message_util.h"
#include "google/protobuf/io/coded_stream.h"
#include "google/protobuf/message_lite.h"
#include "google/protobuf/metadata_lite.h"
#include "google/protobuf/repeated_field.h"  // IWYU pragma: export
#include "turms/client/model/proto/model/common/value.pb.h"
// @@protoc_insertion_point(includes)

// Must be included last.
#include "google/protobuf/port_def.inc"

#define PROTOBUF_INTERNAL_EXPORT_request_2fconference_2fcreate_5fmeeting_5frequest_2eproto

namespace google {
namespace protobuf {
namespace internal {
class AnyMetadata;
}  // namespace internal
}  // namespace protobuf
}  // namespace google

// Internal implementation detail -- do not use these members.
struct TableStruct_request_2fconference_2fcreate_5fmeeting_5frequest_2eproto {
    static const ::uint32_t offsets[];
};
namespace turms {
namespace client {
namespace model {
namespace proto {
class CreateMeetingRequest;
struct CreateMeetingRequestDefaultTypeInternal;
extern CreateMeetingRequestDefaultTypeInternal _CreateMeetingRequest_default_instance_;
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace google {
namespace protobuf {}  // namespace protobuf
}  // namespace google

namespace turms {
namespace client {
namespace model {
namespace proto {

// ===================================================================

// -------------------------------------------------------------------

class CreateMeetingRequest final : public ::google::protobuf::MessageLite
/* @@protoc_insertion_point(class_definition:turms.client.model.proto.CreateMeetingRequest) */ {
   public:
    inline CreateMeetingRequest()
        : CreateMeetingRequest(nullptr) {
    }
    ~CreateMeetingRequest() override;
    template <typename = void>
    explicit PROTOBUF_CONSTEXPR CreateMeetingRequest(
        ::google::protobuf::internal::ConstantInitialized);

    inline CreateMeetingRequest(const CreateMeetingRequest& from)
        : CreateMeetingRequest(nullptr, from) {
    }
    inline CreateMeetingRequest(CreateMeetingRequest&& from) noexcept
        : CreateMeetingRequest(nullptr, std::move(from)) {
    }
    inline CreateMeetingRequest& operator=(const CreateMeetingRequest& from) {
        CopyFrom(from);
        return *this;
    }
    inline CreateMeetingRequest& operator=(CreateMeetingRequest&& from) noexcept {
        if (this == &from)
            return *this;
        if (GetArena() == from.GetArena()
#ifdef PROTOBUF_FORCE_COPY_IN_MOVE
            && GetArena() != nullptr
#endif  // !PROTOBUF_FORCE_COPY_IN_MOVE
        ) {
            InternalSwap(&from);
        } else {
            CopyFrom(from);
        }
        return *this;
    }

    inline const std::string& unknown_fields() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
        return _internal_metadata_.unknown_fields<std::string>(
            ::google::protobuf::internal::GetEmptyString);
    }
    inline std::string* mutable_unknown_fields() ABSL_ATTRIBUTE_LIFETIME_BOUND {
        return _internal_metadata_.mutable_unknown_fields<std::string>();
    }

    static const CreateMeetingRequest& default_instance() {
        return *internal_default_instance();
    }
    static inline const CreateMeetingRequest* internal_default_instance() {
        return reinterpret_cast<const CreateMeetingRequest*>(
            &_CreateMeetingRequest_default_instance_);
    }
    static constexpr int kIndexInFileMessages = 0;
    friend void swap(CreateMeetingRequest& a, CreateMeetingRequest& b) {
        a.Swap(&b);
    }
    inline void Swap(CreateMeetingRequest* other) {
        if (other == this)
            return;
#ifdef PROTOBUF_FORCE_COPY_IN_SWAP
        if (GetArena() != nullptr && GetArena() == other->GetArena()) {
#else   // PROTOBUF_FORCE_COPY_IN_SWAP
        if (GetArena() == other->GetArena()) {
#endif  // !PROTOBUF_FORCE_COPY_IN_SWAP
            InternalSwap(other);
        } else {
            ::google::protobuf::internal::GenericSwap(this, other);
        }
    }
    void UnsafeArenaSwap(CreateMeetingRequest* other) {
        if (other == this)
            return;
        ABSL_DCHECK(GetArena() == other->GetArena());
        InternalSwap(other);
    }

    // implements Message ----------------------------------------------

    CreateMeetingRequest* New(::google::protobuf::Arena* arena = nullptr) const final {
        return ::google::protobuf::MessageLite::DefaultConstruct<CreateMeetingRequest>(arena);
    }
    void CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from) final;
    void CopyFrom(const CreateMeetingRequest& from);
    void MergeFrom(const CreateMeetingRequest& from);
    bool IsInitialized() const {
        return true;
    }
    ABSL_ATTRIBUTE_REINITIALIZES void Clear() final;
    ::size_t ByteSizeLong() const final;
    ::uint8_t* _InternalSerialize(::uint8_t* target,
                                  ::google::protobuf::io::EpsCopyOutputStream* stream) const final;
    int GetCachedSize() const {
        return _impl_._cached_size_.Get();
    }

   private:
    void SharedCtor(::google::protobuf::Arena* arena);
    void SharedDtor();
    void InternalSwap(CreateMeetingRequest* other);

   private:
    friend class ::google::protobuf::internal::AnyMetadata;
    static ::absl::string_view FullMessageName() {
        return "turms.client.model.proto.CreateMeetingRequest";
    }

   protected:
    explicit CreateMeetingRequest(::google::protobuf::Arena* arena);
    CreateMeetingRequest(::google::protobuf::Arena* arena, const CreateMeetingRequest& from);
    CreateMeetingRequest(::google::protobuf::Arena* arena, CreateMeetingRequest&& from) noexcept
        : CreateMeetingRequest(arena) {
        *this = ::std::move(from);
    }
    const ::google::protobuf::MessageLite::ClassData* GetClassData() const final;

   public:
    // nested types ----------------------------------------------------

    // accessors -------------------------------------------------------
    enum : int {
        kCustomAttributesFieldNumber = 15,
        kNameFieldNumber = 3,
        kIntroFieldNumber = 4,
        kPasswordFieldNumber = 5,
        kUserIdFieldNumber = 1,
        kGroupIdFieldNumber = 2,
        kStartDateFieldNumber = 6,
    };
    // repeated .turms.client.model.proto.Value custom_attributes = 15;
    int custom_attributes_size() const;

   private:
    int _internal_custom_attributes_size() const;

   public:
    void clear_custom_attributes();
    ::turms::client::model::proto::Value* mutable_custom_attributes(int index);
    ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
    mutable_custom_attributes();

   private:
    const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
    _internal_custom_attributes() const;
    ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
    _internal_mutable_custom_attributes();

   public:
    const ::turms::client::model::proto::Value& custom_attributes(int index) const;
    ::turms::client::model::proto::Value* add_custom_attributes();
    const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
    custom_attributes() const;
    // optional string name = 3;
    bool has_name() const;
    void clear_name();
    const std::string& name() const;
    template <typename Arg_ = const std::string&, typename... Args_>
    void set_name(Arg_&& arg, Args_... args);
    std::string* mutable_name();
    PROTOBUF_NODISCARD std::string* release_name();
    void set_allocated_name(std::string* value);

   private:
    const std::string& _internal_name() const;
    inline PROTOBUF_ALWAYS_INLINE void _internal_set_name(const std::string& value);
    std::string* _internal_mutable_name();

   public:
    // optional string intro = 4;
    bool has_intro() const;
    void clear_intro();
    const std::string& intro() const;
    template <typename Arg_ = const std::string&, typename... Args_>
    void set_intro(Arg_&& arg, Args_... args);
    std::string* mutable_intro();
    PROTOBUF_NODISCARD std::string* release_intro();
    void set_allocated_intro(std::string* value);

   private:
    const std::string& _internal_intro() const;
    inline PROTOBUF_ALWAYS_INLINE void _internal_set_intro(const std::string& value);
    std::string* _internal_mutable_intro();

   public:
    // optional string password = 5;
    bool has_password() const;
    void clear_password();
    const std::string& password() const;
    template <typename Arg_ = const std::string&, typename... Args_>
    void set_password(Arg_&& arg, Args_... args);
    std::string* mutable_password();
    PROTOBUF_NODISCARD std::string* release_password();
    void set_allocated_password(std::string* value);

   private:
    const std::string& _internal_password() const;
    inline PROTOBUF_ALWAYS_INLINE void _internal_set_password(const std::string& value);
    std::string* _internal_mutable_password();

   public:
    // optional int64 user_id = 1;
    bool has_user_id() const;
    void clear_user_id();
    ::int64_t user_id() const;
    void set_user_id(::int64_t value);

   private:
    ::int64_t _internal_user_id() const;
    void _internal_set_user_id(::int64_t value);

   public:
    // optional int64 group_id = 2;
    bool has_group_id() const;
    void clear_group_id();
    ::int64_t group_id() const;
    void set_group_id(::int64_t value);

   private:
    ::int64_t _internal_group_id() const;
    void _internal_set_group_id(::int64_t value);

   public:
    // optional int64 start_date = 6;
    bool has_start_date() const;
    void clear_start_date();
    ::int64_t start_date() const;
    void set_start_date(::int64_t value);

   private:
    ::int64_t _internal_start_date() const;
    void _internal_set_start_date(::int64_t value);

   public:
    // @@protoc_insertion_point(class_scope:turms.client.model.proto.CreateMeetingRequest)
   private:
    class _Internal;
    friend class ::google::protobuf::internal::TcParser;
    static const ::google::protobuf::internal::TcParseTable<3, 7, 1, 71, 2> _table_;

    static constexpr const void* _raw_default_instance_ = &_CreateMeetingRequest_default_instance_;

    friend class ::google::protobuf::MessageLite;
    friend class ::google::protobuf::Arena;
    template <typename T>
    friend class ::google::protobuf::Arena::InternalHelper;
    using InternalArenaConstructable_ = void;
    using DestructorSkippable_ = void;
    struct Impl_ {
        inline explicit constexpr Impl_(::google::protobuf::internal::ConstantInitialized) noexcept;
        inline explicit Impl_(::google::protobuf::internal::InternalVisibility visibility,
                              ::google::protobuf::Arena* arena);
        inline explicit Impl_(::google::protobuf::internal::InternalVisibility visibility,
                              ::google::protobuf::Arena* arena,
                              const Impl_& from,
                              const CreateMeetingRequest& from_msg);
        ::google::protobuf::internal::HasBits<1> _has_bits_;
        mutable ::google::protobuf::internal::CachedSize _cached_size_;
        ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>
            custom_attributes_;
        ::google::protobuf::internal::ArenaStringPtr name_;
        ::google::protobuf::internal::ArenaStringPtr intro_;
        ::google::protobuf::internal::ArenaStringPtr password_;
        ::int64_t user_id_;
        ::int64_t group_id_;
        ::int64_t start_date_;
        PROTOBUF_TSAN_DECLARE_MEMBER
    };
    union {
        Impl_ _impl_;
    };
    friend struct ::TableStruct_request_2fconference_2fcreate_5fmeeting_5frequest_2eproto;
};

// ===================================================================

// ===================================================================

#ifdef __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// -------------------------------------------------------------------

// CreateMeetingRequest

// optional int64 user_id = 1;
inline bool CreateMeetingRequest::has_user_id() const {
    bool value = (_impl_._has_bits_[0] & 0x00000008u) != 0;
    return value;
}
inline void CreateMeetingRequest::clear_user_id() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.user_id_ = ::int64_t{0};
    _impl_._has_bits_[0] &= ~0x00000008u;
}
inline ::int64_t CreateMeetingRequest::user_id() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.user_id)
    return _internal_user_id();
}
inline void CreateMeetingRequest::set_user_id(::int64_t value) {
    _internal_set_user_id(value);
    _impl_._has_bits_[0] |= 0x00000008u;
    // @@protoc_insertion_point(field_set:turms.client.model.proto.CreateMeetingRequest.user_id)
}
inline ::int64_t CreateMeetingRequest::_internal_user_id() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.user_id_;
}
inline void CreateMeetingRequest::_internal_set_user_id(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.user_id_ = value;
}

// optional int64 group_id = 2;
inline bool CreateMeetingRequest::has_group_id() const {
    bool value = (_impl_._has_bits_[0] & 0x00000010u) != 0;
    return value;
}
inline void CreateMeetingRequest::clear_group_id() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.group_id_ = ::int64_t{0};
    _impl_._has_bits_[0] &= ~0x00000010u;
}
inline ::int64_t CreateMeetingRequest::group_id() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.group_id)
    return _internal_group_id();
}
inline void CreateMeetingRequest::set_group_id(::int64_t value) {
    _internal_set_group_id(value);
    _impl_._has_bits_[0] |= 0x00000010u;
    // @@protoc_insertion_point(field_set:turms.client.model.proto.CreateMeetingRequest.group_id)
}
inline ::int64_t CreateMeetingRequest::_internal_group_id() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.group_id_;
}
inline void CreateMeetingRequest::_internal_set_group_id(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.group_id_ = value;
}

// optional string name = 3;
inline bool CreateMeetingRequest::has_name() const {
    bool value = (_impl_._has_bits_[0] & 0x00000001u) != 0;
    return value;
}
inline void CreateMeetingRequest::clear_name() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.name_.ClearToEmpty();
    _impl_._has_bits_[0] &= ~0x00000001u;
}
inline const std::string& CreateMeetingRequest::name() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.name)
    return _internal_name();
}
template <typename Arg_, typename... Args_>
inline PROTOBUF_ALWAYS_INLINE void CreateMeetingRequest::set_name(Arg_&& arg, Args_... args) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000001u;
    _impl_.name_.Set(static_cast<Arg_&&>(arg), args..., GetArena());
    // @@protoc_insertion_point(field_set:turms.client.model.proto.CreateMeetingRequest.name)
}
inline std::string* CreateMeetingRequest::mutable_name() ABSL_ATTRIBUTE_LIFETIME_BOUND {
    std::string* _s = _internal_mutable_name();
    // @@protoc_insertion_point(field_mutable:turms.client.model.proto.CreateMeetingRequest.name)
    return _s;
}
inline const std::string& CreateMeetingRequest::_internal_name() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.name_.Get();
}
inline void CreateMeetingRequest::_internal_set_name(const std::string& value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000001u;
    _impl_.name_.Set(value, GetArena());
}
inline std::string* CreateMeetingRequest::_internal_mutable_name() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000001u;
    return _impl_.name_.Mutable(GetArena());
}
inline std::string* CreateMeetingRequest::release_name() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    // @@protoc_insertion_point(field_release:turms.client.model.proto.CreateMeetingRequest.name)
    if ((_impl_._has_bits_[0] & 0x00000001u) == 0) {
        return nullptr;
    }
    _impl_._has_bits_[0] &= ~0x00000001u;
    auto* released = _impl_.name_.Release();
#ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
    _impl_.name_.Set("", GetArena());
#endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
    return released;
}
inline void CreateMeetingRequest::set_allocated_name(std::string* value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    if (value != nullptr) {
        _impl_._has_bits_[0] |= 0x00000001u;
    } else {
        _impl_._has_bits_[0] &= ~0x00000001u;
    }
    _impl_.name_.SetAllocated(value, GetArena());
#ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
    if (_impl_.name_.IsDefault()) {
        _impl_.name_.Set("", GetArena());
    }
#endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
    // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.CreateMeetingRequest.name)
}

// optional string intro = 4;
inline bool CreateMeetingRequest::has_intro() const {
    bool value = (_impl_._has_bits_[0] & 0x00000002u) != 0;
    return value;
}
inline void CreateMeetingRequest::clear_intro() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.intro_.ClearToEmpty();
    _impl_._has_bits_[0] &= ~0x00000002u;
}
inline const std::string& CreateMeetingRequest::intro() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.intro)
    return _internal_intro();
}
template <typename Arg_, typename... Args_>
inline PROTOBUF_ALWAYS_INLINE void CreateMeetingRequest::set_intro(Arg_&& arg, Args_... args) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000002u;
    _impl_.intro_.Set(static_cast<Arg_&&>(arg), args..., GetArena());
    // @@protoc_insertion_point(field_set:turms.client.model.proto.CreateMeetingRequest.intro)
}
inline std::string* CreateMeetingRequest::mutable_intro() ABSL_ATTRIBUTE_LIFETIME_BOUND {
    std::string* _s = _internal_mutable_intro();
    // @@protoc_insertion_point(field_mutable:turms.client.model.proto.CreateMeetingRequest.intro)
    return _s;
}
inline const std::string& CreateMeetingRequest::_internal_intro() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.intro_.Get();
}
inline void CreateMeetingRequest::_internal_set_intro(const std::string& value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000002u;
    _impl_.intro_.Set(value, GetArena());
}
inline std::string* CreateMeetingRequest::_internal_mutable_intro() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000002u;
    return _impl_.intro_.Mutable(GetArena());
}
inline std::string* CreateMeetingRequest::release_intro() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    // @@protoc_insertion_point(field_release:turms.client.model.proto.CreateMeetingRequest.intro)
    if ((_impl_._has_bits_[0] & 0x00000002u) == 0) {
        return nullptr;
    }
    _impl_._has_bits_[0] &= ~0x00000002u;
    auto* released = _impl_.intro_.Release();
#ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
    _impl_.intro_.Set("", GetArena());
#endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
    return released;
}
inline void CreateMeetingRequest::set_allocated_intro(std::string* value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    if (value != nullptr) {
        _impl_._has_bits_[0] |= 0x00000002u;
    } else {
        _impl_._has_bits_[0] &= ~0x00000002u;
    }
    _impl_.intro_.SetAllocated(value, GetArena());
#ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
    if (_impl_.intro_.IsDefault()) {
        _impl_.intro_.Set("", GetArena());
    }
#endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
    // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.CreateMeetingRequest.intro)
}

// optional string password = 5;
inline bool CreateMeetingRequest::has_password() const {
    bool value = (_impl_._has_bits_[0] & 0x00000004u) != 0;
    return value;
}
inline void CreateMeetingRequest::clear_password() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.password_.ClearToEmpty();
    _impl_._has_bits_[0] &= ~0x00000004u;
}
inline const std::string& CreateMeetingRequest::password() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.password)
    return _internal_password();
}
template <typename Arg_, typename... Args_>
inline PROTOBUF_ALWAYS_INLINE void CreateMeetingRequest::set_password(Arg_&& arg, Args_... args) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000004u;
    _impl_.password_.Set(static_cast<Arg_&&>(arg), args..., GetArena());
    // @@protoc_insertion_point(field_set:turms.client.model.proto.CreateMeetingRequest.password)
}
inline std::string* CreateMeetingRequest::mutable_password() ABSL_ATTRIBUTE_LIFETIME_BOUND {
    std::string* _s = _internal_mutable_password();
    // @@protoc_insertion_point(field_mutable:turms.client.model.proto.CreateMeetingRequest.password)
    return _s;
}
inline const std::string& CreateMeetingRequest::_internal_password() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.password_.Get();
}
inline void CreateMeetingRequest::_internal_set_password(const std::string& value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000004u;
    _impl_.password_.Set(value, GetArena());
}
inline std::string* CreateMeetingRequest::_internal_mutable_password() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_._has_bits_[0] |= 0x00000004u;
    return _impl_.password_.Mutable(GetArena());
}
inline std::string* CreateMeetingRequest::release_password() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    // @@protoc_insertion_point(field_release:turms.client.model.proto.CreateMeetingRequest.password)
    if ((_impl_._has_bits_[0] & 0x00000004u) == 0) {
        return nullptr;
    }
    _impl_._has_bits_[0] &= ~0x00000004u;
    auto* released = _impl_.password_.Release();
#ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
    _impl_.password_.Set("", GetArena());
#endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
    return released;
}
inline void CreateMeetingRequest::set_allocated_password(std::string* value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    if (value != nullptr) {
        _impl_._has_bits_[0] |= 0x00000004u;
    } else {
        _impl_._has_bits_[0] &= ~0x00000004u;
    }
    _impl_.password_.SetAllocated(value, GetArena());
#ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
    if (_impl_.password_.IsDefault()) {
        _impl_.password_.Set("", GetArena());
    }
#endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
    // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.CreateMeetingRequest.password)
}

// optional int64 start_date = 6;
inline bool CreateMeetingRequest::has_start_date() const {
    bool value = (_impl_._has_bits_[0] & 0x00000020u) != 0;
    return value;
}
inline void CreateMeetingRequest::clear_start_date() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.start_date_ = ::int64_t{0};
    _impl_._has_bits_[0] &= ~0x00000020u;
}
inline ::int64_t CreateMeetingRequest::start_date() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.start_date)
    return _internal_start_date();
}
inline void CreateMeetingRequest::set_start_date(::int64_t value) {
    _internal_set_start_date(value);
    _impl_._has_bits_[0] |= 0x00000020u;
    // @@protoc_insertion_point(field_set:turms.client.model.proto.CreateMeetingRequest.start_date)
}
inline ::int64_t CreateMeetingRequest::_internal_start_date() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.start_date_;
}
inline void CreateMeetingRequest::_internal_set_start_date(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.start_date_ = value;
}

// repeated .turms.client.model.proto.Value custom_attributes = 15;
inline int CreateMeetingRequest::_internal_custom_attributes_size() const {
    return _internal_custom_attributes().size();
}
inline int CreateMeetingRequest::custom_attributes_size() const {
    return _internal_custom_attributes_size();
}
inline ::turms::client::model::proto::Value* CreateMeetingRequest::mutable_custom_attributes(
    int index) ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_mutable:turms.client.model.proto.CreateMeetingRequest.custom_attributes)
    return _internal_mutable_custom_attributes()->Mutable(index);
}
inline ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
CreateMeetingRequest::mutable_custom_attributes() ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_mutable_list:turms.client.model.proto.CreateMeetingRequest.custom_attributes)
    ::google::protobuf::internal::TSanWrite(&_impl_);
    return _internal_mutable_custom_attributes();
}
inline const ::turms::client::model::proto::Value& CreateMeetingRequest::custom_attributes(
    int index) const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.CreateMeetingRequest.custom_attributes)
    return _internal_custom_attributes().Get(index);
}
inline ::turms::client::model::proto::Value* CreateMeetingRequest::add_custom_attributes()
    ABSL_ATTRIBUTE_LIFETIME_BOUND {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    ::turms::client::model::proto::Value* _add = _internal_mutable_custom_attributes()->Add();
    // @@protoc_insertion_point(field_add:turms.client.model.proto.CreateMeetingRequest.custom_attributes)
    return _add;
}
inline const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
CreateMeetingRequest::custom_attributes() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_list:turms.client.model.proto.CreateMeetingRequest.custom_attributes)
    return _internal_custom_attributes();
}
inline const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
CreateMeetingRequest::_internal_custom_attributes() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.custom_attributes_;
}
inline ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
CreateMeetingRequest::_internal_mutable_custom_attributes() {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return &_impl_.custom_attributes_;
}

#ifdef __GNUC__
#pragma GCC diagnostic pop
#endif  // __GNUC__

// @@protoc_insertion_point(namespace_scope)
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms

// @@protoc_insertion_point(global_scope)

#include "google/protobuf/port_undef.inc"

#endif  // GOOGLE_PROTOBUF_INCLUDED_request_2fconference_2fcreate_5fmeeting_5frequest_2eproto_2epb_2eh
