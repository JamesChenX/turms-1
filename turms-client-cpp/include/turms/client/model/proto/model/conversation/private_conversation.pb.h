// Generated by the protocol buffer compiler.  DO NOT EDIT!
// NO CHECKED-IN PROTOBUF GENCODE
// source: model/conversation/private_conversation.proto
// Protobuf C++ Version: 5.27.2

#ifndef GOOGLE_PROTOBUF_INCLUDED_model_2fconversation_2fprivate_5fconversation_2eproto_2epb_2eh
#define GOOGLE_PROTOBUF_INCLUDED_model_2fconversation_2fprivate_5fconversation_2eproto_2epb_2eh

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

#define PROTOBUF_INTERNAL_EXPORT_model_2fconversation_2fprivate_5fconversation_2eproto

namespace google {
namespace protobuf {
namespace internal {
class AnyMetadata;
}  // namespace internal
}  // namespace protobuf
}  // namespace google

// Internal implementation detail -- do not use these members.
struct TableStruct_model_2fconversation_2fprivate_5fconversation_2eproto {
    static const ::uint32_t offsets[];
};
namespace turms {
namespace client {
namespace model {
namespace proto {
class PrivateConversation;
struct PrivateConversationDefaultTypeInternal;
extern PrivateConversationDefaultTypeInternal _PrivateConversation_default_instance_;
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

class PrivateConversation final : public ::google::protobuf::MessageLite
/* @@protoc_insertion_point(class_definition:turms.client.model.proto.PrivateConversation) */ {
   public:
    inline PrivateConversation()
        : PrivateConversation(nullptr) {
    }
    ~PrivateConversation() override;
    template <typename = void>
    explicit PROTOBUF_CONSTEXPR PrivateConversation(
        ::google::protobuf::internal::ConstantInitialized);

    inline PrivateConversation(const PrivateConversation& from)
        : PrivateConversation(nullptr, from) {
    }
    inline PrivateConversation(PrivateConversation&& from) noexcept
        : PrivateConversation(nullptr, std::move(from)) {
    }
    inline PrivateConversation& operator=(const PrivateConversation& from) {
        CopyFrom(from);
        return *this;
    }
    inline PrivateConversation& operator=(PrivateConversation&& from) noexcept {
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

    static const PrivateConversation& default_instance() {
        return *internal_default_instance();
    }
    static inline const PrivateConversation* internal_default_instance() {
        return reinterpret_cast<const PrivateConversation*>(
            &_PrivateConversation_default_instance_);
    }
    static constexpr int kIndexInFileMessages = 0;
    friend void swap(PrivateConversation& a, PrivateConversation& b) {
        a.Swap(&b);
    }
    inline void Swap(PrivateConversation* other) {
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
    void UnsafeArenaSwap(PrivateConversation* other) {
        if (other == this)
            return;
        ABSL_DCHECK(GetArena() == other->GetArena());
        InternalSwap(other);
    }

    // implements Message ----------------------------------------------

    PrivateConversation* New(::google::protobuf::Arena* arena = nullptr) const final {
        return ::google::protobuf::MessageLite::DefaultConstruct<PrivateConversation>(arena);
    }
    void CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from) final;
    void CopyFrom(const PrivateConversation& from);
    void MergeFrom(const PrivateConversation& from);
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
    void InternalSwap(PrivateConversation* other);

   private:
    friend class ::google::protobuf::internal::AnyMetadata;
    static ::absl::string_view FullMessageName() {
        return "turms.client.model.proto.PrivateConversation";
    }

   protected:
    explicit PrivateConversation(::google::protobuf::Arena* arena);
    PrivateConversation(::google::protobuf::Arena* arena, const PrivateConversation& from);
    PrivateConversation(::google::protobuf::Arena* arena, PrivateConversation&& from) noexcept
        : PrivateConversation(arena) {
        *this = ::std::move(from);
    }
    const ::google::protobuf::MessageLite::ClassData* GetClassData() const final;

   public:
    // nested types ----------------------------------------------------

    // accessors -------------------------------------------------------
    enum : int {
        kCustomAttributesFieldNumber = 15,
        kOwnerIdFieldNumber = 1,
        kTargetIdFieldNumber = 2,
        kReadDateFieldNumber = 3,
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
    // int64 owner_id = 1;
    void clear_owner_id();
    ::int64_t owner_id() const;
    void set_owner_id(::int64_t value);

   private:
    ::int64_t _internal_owner_id() const;
    void _internal_set_owner_id(::int64_t value);

   public:
    // int64 target_id = 2;
    void clear_target_id();
    ::int64_t target_id() const;
    void set_target_id(::int64_t value);

   private:
    ::int64_t _internal_target_id() const;
    void _internal_set_target_id(::int64_t value);

   public:
    // int64 read_date = 3;
    void clear_read_date();
    ::int64_t read_date() const;
    void set_read_date(::int64_t value);

   private:
    ::int64_t _internal_read_date() const;
    void _internal_set_read_date(::int64_t value);

   public:
    // @@protoc_insertion_point(class_scope:turms.client.model.proto.PrivateConversation)
   private:
    class _Internal;
    friend class ::google::protobuf::internal::TcParser;
    static const ::google::protobuf::internal::TcParseTable<3, 4, 1, 0, 2> _table_;

    static constexpr const void* _raw_default_instance_ = &_PrivateConversation_default_instance_;

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
                              const PrivateConversation& from_msg);
        ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>
            custom_attributes_;
        ::int64_t owner_id_;
        ::int64_t target_id_;
        ::int64_t read_date_;
        mutable ::google::protobuf::internal::CachedSize _cached_size_;
        PROTOBUF_TSAN_DECLARE_MEMBER
    };
    union {
        Impl_ _impl_;
    };
    friend struct ::TableStruct_model_2fconversation_2fprivate_5fconversation_2eproto;
};

// ===================================================================

// ===================================================================

#ifdef __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// -------------------------------------------------------------------

// PrivateConversation

// int64 owner_id = 1;
inline void PrivateConversation::clear_owner_id() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.owner_id_ = ::int64_t{0};
}
inline ::int64_t PrivateConversation::owner_id() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.PrivateConversation.owner_id)
    return _internal_owner_id();
}
inline void PrivateConversation::set_owner_id(::int64_t value) {
    _internal_set_owner_id(value);
    // @@protoc_insertion_point(field_set:turms.client.model.proto.PrivateConversation.owner_id)
}
inline ::int64_t PrivateConversation::_internal_owner_id() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.owner_id_;
}
inline void PrivateConversation::_internal_set_owner_id(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.owner_id_ = value;
}

// int64 target_id = 2;
inline void PrivateConversation::clear_target_id() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.target_id_ = ::int64_t{0};
}
inline ::int64_t PrivateConversation::target_id() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.PrivateConversation.target_id)
    return _internal_target_id();
}
inline void PrivateConversation::set_target_id(::int64_t value) {
    _internal_set_target_id(value);
    // @@protoc_insertion_point(field_set:turms.client.model.proto.PrivateConversation.target_id)
}
inline ::int64_t PrivateConversation::_internal_target_id() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.target_id_;
}
inline void PrivateConversation::_internal_set_target_id(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.target_id_ = value;
}

// int64 read_date = 3;
inline void PrivateConversation::clear_read_date() {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.read_date_ = ::int64_t{0};
}
inline ::int64_t PrivateConversation::read_date() const {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.PrivateConversation.read_date)
    return _internal_read_date();
}
inline void PrivateConversation::set_read_date(::int64_t value) {
    _internal_set_read_date(value);
    // @@protoc_insertion_point(field_set:turms.client.model.proto.PrivateConversation.read_date)
}
inline ::int64_t PrivateConversation::_internal_read_date() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.read_date_;
}
inline void PrivateConversation::_internal_set_read_date(::int64_t value) {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    _impl_.read_date_ = value;
}

// repeated .turms.client.model.proto.Value custom_attributes = 15;
inline int PrivateConversation::_internal_custom_attributes_size() const {
    return _internal_custom_attributes().size();
}
inline int PrivateConversation::custom_attributes_size() const {
    return _internal_custom_attributes_size();
}
inline ::turms::client::model::proto::Value* PrivateConversation::mutable_custom_attributes(
    int index) ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_mutable:turms.client.model.proto.PrivateConversation.custom_attributes)
    return _internal_mutable_custom_attributes()->Mutable(index);
}
inline ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
PrivateConversation::mutable_custom_attributes() ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_mutable_list:turms.client.model.proto.PrivateConversation.custom_attributes)
    ::google::protobuf::internal::TSanWrite(&_impl_);
    return _internal_mutable_custom_attributes();
}
inline const ::turms::client::model::proto::Value& PrivateConversation::custom_attributes(
    int index) const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_get:turms.client.model.proto.PrivateConversation.custom_attributes)
    return _internal_custom_attributes().Get(index);
}
inline ::turms::client::model::proto::Value* PrivateConversation::add_custom_attributes()
    ABSL_ATTRIBUTE_LIFETIME_BOUND {
    ::google::protobuf::internal::TSanWrite(&_impl_);
    ::turms::client::model::proto::Value* _add = _internal_mutable_custom_attributes()->Add();
    // @@protoc_insertion_point(field_add:turms.client.model.proto.PrivateConversation.custom_attributes)
    return _add;
}
inline const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
PrivateConversation::custom_attributes() const ABSL_ATTRIBUTE_LIFETIME_BOUND {
    // @@protoc_insertion_point(field_list:turms.client.model.proto.PrivateConversation.custom_attributes)
    return _internal_custom_attributes();
}
inline const ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>&
PrivateConversation::_internal_custom_attributes() const {
    ::google::protobuf::internal::TSanRead(&_impl_);
    return _impl_.custom_attributes_;
}
inline ::google::protobuf::RepeatedPtrField<::turms::client::model::proto::Value>*
PrivateConversation::_internal_mutable_custom_attributes() {
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

#endif  // GOOGLE_PROTOBUF_INCLUDED_model_2fconversation_2fprivate_5fconversation_2eproto_2epb_2eh
