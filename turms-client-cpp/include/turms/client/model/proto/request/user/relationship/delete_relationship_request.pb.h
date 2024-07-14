// Generated by the protocol buffer compiler.  DO NOT EDIT!
// NO CHECKED-IN PROTOBUF GENCODE
// source: request/user/relationship/delete_relationship_request.proto
// Protobuf C++ Version: 5.27.2

#ifndef GOOGLE_PROTOBUF_INCLUDED_request_2fuser_2frelationship_2fdelete_5frelationship_5frequest_2eproto_2epb_2eh
#define GOOGLE_PROTOBUF_INCLUDED_request_2fuser_2frelationship_2fdelete_5frelationship_5frequest_2eproto_2epb_2eh

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

#define PROTOBUF_INTERNAL_EXPORT_request_2fuser_2frelationship_2fdelete_5frelationship_5frequest_2eproto

namespace google {
namespace protobuf {
namespace internal {
class AnyMetadata;
}  // namespace internal
}  // namespace protobuf
}  // namespace google

// Internal implementation detail -- do not use these members.
struct TableStruct_request_2fuser_2frelationship_2fdelete_5frelationship_5frequest_2eproto {
    static const ::uint32_t offsets[];
};
namespace turms {
namespace client {
namespace model {
namespace proto {
class DeleteRelationshipRequest;
struct DeleteRelationshipRequestDefaultTypeInternal;
extern DeleteRelationshipRequestDefaultTypeInternal _DeleteRelationshipRequest_default_instance_;
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

class DeleteRelationshipRequest final : public ::google::protobuf::MessageLite
/* @@protoc_insertion_point(class_definition:turms.client.model.proto.DeleteRelationshipRequest) */
{
   public:
    inline DeleteRelationshipRequest()
        : DeleteRelationshipRequest(nullptr) {
    }
    ~DeleteRelationshipRequest() override;
    template <typename = void>
    explicit PROTOBUF_CONSTEXPR DeleteRelationshipRequest(
        ::google::protobuf::internal::ConstantInitialized);

    inline DeleteRelationshipRequest(const DeleteRelationshipRequest& from)
        : DeleteRelationshipRequest(nullptr, from) {
    }
    inline DeleteRelationshipRequest(DeleteRelationshipRequest&& from) noexcept
        : DeleteRelationshipRequest(nullptr, std::move(from)) {
    }
    inline DeleteRelationshipRequest& operator=(const DeleteRelationshipRequest& from) {
        CopyFrom(from);
        return *this;
    }
    inline DeleteRelationshipRequest& operator=(DeleteRelationshipRequest&& from) noexcept {
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

    static const DeleteRelationshipRequest& default_instance() {
        return *internal_default_instance();
    }
    static inline const DeleteRelationshipRequest* internal_default_instance() {
        return reinterpret_cast<const DeleteRelationshipRequest*>(
            &_DeleteRelationshipRequest_default_instance_);
    }
    static constexpr int kIndexInFileMessages = 0;
    friend void swap(DeleteRelationshipRequest& a, DeleteRelationshipRequest& b) {
        a.Swap(&b);
    }
    inline void Swap(DeleteRelationshipRequest* other) {
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
    void UnsafeArenaSwap(DeleteRelationshipRequest* other) {
        if (other == this)
            return;
        ABSL_DCHECK(GetArena() == other->GetArena());
        InternalSwap(other);
    }

    // implements Message ----------------------------------------------

    DeleteRelationshipRequest* New(::google::protobuf::Arena* arena = nullptr) const final {
        return ::google::protobuf::MessageLite::DefaultConstruct<DeleteRelationshipRequest>(arena);
    }
    void CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from) final;
    void CopyFrom(const DeleteRelationshipRequest& from);
    void MergeFrom(const DeleteRelationshipRequest& from);
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
    void InternalSwap(DeleteRelationshipRequest* other);

   private:
    friend class ::google::protobuf::internal::AnyMetadata;
    static ::absl::string_view FullMessageName() {
        return "turms.client.model.proto.DeleteRelationshipRequest";
    }

   protected:
    explicit DeleteRelationshipRequest(::google::protobuf::Arena* arena);
    DeleteRelationshipRequest(::google::protobuf::Arena* arena,
                              const DeleteRelationshipRequest& from);
    DeleteRelationshipRequest(::google::protobuf::Arena* arena,
                              DeleteRelationshipRequest&& from) noexcept
        : DeleteRelationshipRequest(arena) {
        *this = ::std::move(from);
    }
    const ::google::protobuf::MessageLite::ClassData* GetClassData() const final;

   public:
    // nested types ----------------------------------------------------

    // accessors -------------------------------------------------------
    enum : int {
        kCustomAttributesFieldNumber = 15,
        kUserIdFieldNumber = 1,
        kGroupIndexFieldNumber = 2,
        kTargetGroupIndexFieldNumber = 3,
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
    // int64 user_id = 1;
    void clear_user_id();
    ::int64_t user_id() const;
    void set_user_id(::int64_t value);

   private:
    ::int64_t _internal_user_id() const;
    void _internal_set_user_id(::int64_t value);

   public:
    // optional int32 group_index = 2;
    bool has_group_index() const;
    void clear_group_index();
    ::int32_t group_index() const;
    void set_group_index(::int32_t value);

   private:
    ::int32_t _internal_group_index() const;
    void _internal_set_group_index(::int32_t value);

   public:
    // optional int32 target_group_index = 3;
    bool has_target_group_index() const;
    void clear_target_group_index();
    ::int32_t target_group_index() const;
    void set_target_group_index(::int32_t value);

   private:
    ::int32_t _internal_target_group_index() const;
    void _internal_set_target_group_index(::int32_t value);

   public:
    // @@protoc_insertion_point(class_scope:turms.client.model.proto.DeleteRelationshipRequest)
   private:
    class _Internal;
    friend class ::google::protobuf::internal::TcParser;
    static const ::google::protobuf::internal::TcParseTable<3, 4, 1, 0, 2> _table_;

    static constexpr const void* _raw_default_instance_ =
        &_DeleteRelationshipRequest_default_instance_;

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
                              const DeleteRelationshipRequest& from_msg);
        ::google::protobuf::internal::HasBits<1> _has_bits_;
        mutable ::google::protobuf::internal::CachedSize _cached_size_;
        ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>
            custom_attributes_;
        ::int64_t user_id_;
        ::int32_t group_index_;
        ::int32_t target_group_index_;
        PROTOBUF_TSAN_DECLARE_MEMBER
    };
    union {
        Impl_ _impl_;
    };
    friend struct ::
        TableStruct_request_2fuser_2frelationship_2fdelete_5frelationship_5frequest_2eproto;
};

// ===================================================================

// ===================================================================

#ifdef __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// -------------------------------------------------------------------

// DeleteRelationshipRequest

// int64 user_id = 1;
inline void DeleteRelationshipRequest::clear_user_id() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.user_id_ = ::int64_t{0};
}
inline ::int64_t DeleteRelationshipRequest::user_id() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.DeleteRelationshipRequest.user_id)
    return _internal_user_id();
}
inline void DeleteRelationshipRequest::set_user_id(::int64_t value) {
    _internal_set_user_id(value);
    // @@protoc_insertion_point(field_set:turms.client.model.proto.DeleteRelationshipRequest.user_id)
}
inline ::int64_t DeleteRelationshipRequest::_internal_user_id() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.user_id_;
}
inline void DeleteRelationshipRequest::_internal_set_user_id(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.user_id_ = value;
}

// optional int32 group_index = 2;
inline bool DeleteRelationshipRequest::has_group_index() const {
    bool value = (_impl_._has_bits_[0] & 0x00000001u) != 0;
    return value;
}
inline void DeleteRelationshipRequest::clear_group_index() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.group_index_ = 0;
    _impl_._has_bits_[0] &= ~0x00000001u;
}
inline ::int32_t DeleteRelationshipRequest::group_index() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.DeleteRelationshipRequest.group_index)
    return _internal_group_index();
}
inline void DeleteRelationshipRequest::set_group_index(::int32_t value) {
    _internal_set_group_index(value);
    _impl_._has_bits_[0] |= 0x00000001u;
    // @@protoc_insertion_point(field_set:turms.client.model.proto.DeleteRelationshipRequest.group_index)
}
inline ::int32_t DeleteRelationshipRequest::_internal_group_index() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.group_index_;
}
inline void DeleteRelationshipRequest::_internal_set_group_index(::int32_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.group_index_ = value;
}

// optional int32 target_group_index = 3;
inline bool DeleteRelationshipRequest::has_target_group_index() const {
    bool value = (_impl_._has_bits_[0] & 0x00000002u) != 0;
    return value;
}
inline void DeleteRelationshipRequest::clear_target_group_index() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.target_group_index_ = 0;
    _impl_._has_bits_[0] &= ~0x00000002u;
}
inline ::int32_t DeleteRelationshipRequest::target_group_index() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.DeleteRelationshipRequest.target_group_index)
    return _internal_target_group_index();
}
inline void DeleteRelationshipRequest::set_target_group_index(::int32_t value) {
    _internal_set_target_group_index(value);
    _impl_._has_bits_[0] |= 0x00000002u;
    // @@protoc_insertion_point(field_set:turms.client.model.proto.DeleteRelationshipRequest.target_group_index)
}
inline ::int32_t DeleteRelationshipRequest::_internal_target_group_index() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.target_group_index_;
}
inline void DeleteRelationshipRequest::_internal_set_target_group_index(::int32_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.target_group_index_ = value;
}

// repeated .turms.client.model.proto.Value custom_attributes = 15;
inline int DeleteRelationshipRequest::_internal_custom_attributes_size() const {
    return _internal_custom_attributes().size();
}
inline int DeleteRelationshipRequest::custom_attributes_size() const {
    return _internal_custom_attributes_size();
}
inline ::turms::client::model::proto::Value* DeleteRelationshipRequest::mutable_custom_attributes(
    int index) ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_mutable:turms.client.model.proto.DeleteRelationshipRequest.custom_attributes)
    return _internal_mutable_custom_attributes()->Mutable(index);
}
inline ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
DeleteRelationshipRequest::mutable_custom_attributes() ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_mutable_list:turms.client.model.proto.DeleteRelationshipRequest.custom_attributes)
    ::google::protobuf::internal::TSanWrite(&_impl_);
    return _internal_mutable_custom_attributes();
}
inline const ::turms::client::model::proto::Value& DeleteRelationshipRequest::custom_attributes(
    int index) const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.DeleteRelationshipRequest.custom_attributes)
    return _internal_custom_attributes().Get(index);
}
inline ::turms::client::model::proto::Value* DeleteRelationshipRequest::add_custom_attributes()
    ABSL_ATTRIBUTE_LIFETIME_BOUND {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    ::turms::client::model::proto::Value* _add = _internal_mutable_custom_attributes()->Add();
    // @@protoc_insertion_point(field_add:turms.client.model.proto.DeleteRelationshipRequest.custom_attributes)
    return _add;
}
inline const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
DeleteRelationshipRequest::custom_attributes() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_list:turms.client.model.proto.DeleteRelationshipRequest.custom_attributes)
    return _internal_custom_attributes();
}
inline const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
DeleteRelationshipRequest::_internal_custom_attributes() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.custom_attributes_;
}
inline ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
DeleteRelationshipRequest::_internal_mutable_custom_attributes() {
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

#endif  // GOOGLE_PROTOBUF_INCLUDED_request_2fuser_2frelationship_2fdelete_5frelationship_5frequest_2eproto_2epb_2eh
