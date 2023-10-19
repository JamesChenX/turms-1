// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: model/file/file.proto

#ifndef GOOGLE_PROTOBUF_INCLUDED_model_2ffile_2ffile_2eproto_2epb_2eh
#define GOOGLE_PROTOBUF_INCLUDED_model_2ffile_2ffile_2eproto_2epb_2eh

#include <limits>
#include <string>
#include <type_traits>

#include "google/protobuf/port_def.inc"
#if PROTOBUF_VERSION < 4024000
#error "This file was generated by a newer version of protoc which is"
#error "incompatible with your Protocol Buffer headers. Please update"
#error "your headers."
#endif  // PROTOBUF_VERSION

#if 4024000 < PROTOBUF_MIN_PROTOC_VERSION
#error "This file was generated by an older version of protoc which is"
#error "incompatible with your Protocol Buffer headers. Please"
#error "regenerate this file with a newer version of protoc."
#endif  // PROTOBUF_MIN_PROTOC_VERSION
#include "google/protobuf/port_undef.inc"
#include "google/protobuf/io/coded_stream.h"
#include "google/protobuf/arena.h"
#include "google/protobuf/arenastring.h"
#include "google/protobuf/generated_message_tctable_decl.h"
#include "google/protobuf/generated_message_util.h"
#include "google/protobuf/metadata_lite.h"
#include "google/protobuf/message_lite.h"
#include "google/protobuf/repeated_field.h"  // IWYU pragma: export
#include "google/protobuf/extension_set.h"  // IWYU pragma: export
// @@protoc_insertion_point(includes)

// Must be included last.
#include "google/protobuf/port_def.inc"

#define PROTOBUF_INTERNAL_EXPORT_model_2ffile_2ffile_2eproto

namespace google {
namespace protobuf {
namespace internal {
class AnyMetadata;
}  // namespace internal
}  // namespace protobuf
}  // namespace google

// Internal implementation detail -- do not use these members.
struct TableStruct_model_2ffile_2ffile_2eproto {
  static const ::uint32_t offsets[];
};
namespace turms {
namespace client {
namespace model {
namespace proto {
class File;
struct FileDefaultTypeInternal;
extern FileDefaultTypeInternal _File_default_instance_;
class File_Description;
struct File_DescriptionDefaultTypeInternal;
extern File_DescriptionDefaultTypeInternal _File_Description_default_instance_;
}  // namespace proto
}  // namespace model
}  // namespace client
}  // namespace turms
namespace google {
namespace protobuf {
}  // namespace protobuf
}  // namespace google

namespace turms {
namespace client {
namespace model {
namespace proto {

// ===================================================================


// -------------------------------------------------------------------

class File_Description final :
    public ::google::protobuf::MessageLite /* @@protoc_insertion_point(class_definition:turms.client.model.proto.File.Description) */ {
 public:
  inline File_Description() : File_Description(nullptr) {}
  ~File_Description() override;
  template<typename = void>
  explicit PROTOBUF_CONSTEXPR File_Description(::google::protobuf::internal::ConstantInitialized);

  File_Description(const File_Description& from);
  File_Description(File_Description&& from) noexcept
    : File_Description() {
    *this = ::std::move(from);
  }

  inline File_Description& operator=(const File_Description& from) {
    CopyFrom(from);
    return *this;
  }
  inline File_Description& operator=(File_Description&& from) noexcept {
    if (this == &from) return *this;
    if (GetOwningArena() == from.GetOwningArena()
  #ifdef PROTOBUF_FORCE_COPY_IN_MOVE
        && GetOwningArena() != nullptr
  #endif  // !PROTOBUF_FORCE_COPY_IN_MOVE
    ) {
      InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }

  inline const std::string& unknown_fields() const {
    return _internal_metadata_.unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString);
  }
  inline std::string* mutable_unknown_fields() {
    return _internal_metadata_.mutable_unknown_fields<std::string>();
  }

  static const File_Description& default_instance() {
    return *internal_default_instance();
  }
  static inline const File_Description* internal_default_instance() {
    return reinterpret_cast<const File_Description*>(
               &_File_Description_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    0;

  friend void swap(File_Description& a, File_Description& b) {
    a.Swap(&b);
  }
  inline void Swap(File_Description* other) {
    if (other == this) return;
  #ifdef PROTOBUF_FORCE_COPY_IN_SWAP
    if (GetOwningArena() != nullptr &&
        GetOwningArena() == other->GetOwningArena()) {
   #else  // PROTOBUF_FORCE_COPY_IN_SWAP
    if (GetOwningArena() == other->GetOwningArena()) {
  #endif  // !PROTOBUF_FORCE_COPY_IN_SWAP
      InternalSwap(other);
    } else {
      ::google::protobuf::internal::GenericSwap(this, other);
    }
  }
  void UnsafeArenaSwap(File_Description* other) {
    if (other == this) return;
    ABSL_DCHECK(GetOwningArena() == other->GetOwningArena());
    InternalSwap(other);
  }

  // implements Message ----------------------------------------------

  File_Description* New(::google::protobuf::Arena* arena = nullptr) const final {
    return CreateMaybeMessage<File_Description>(arena);
  }
  void CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from)  final;
  void CopyFrom(const File_Description& from);
  void MergeFrom(const File_Description& from);
  PROTOBUF_ATTRIBUTE_REINITIALIZES void Clear() final;
  bool IsInitialized() const final;

  ::size_t ByteSizeLong() const final;
  const char* _InternalParse(const char* ptr, ::google::protobuf::internal::ParseContext* ctx) final;
  ::uint8_t* _InternalSerialize(
      ::uint8_t* target, ::google::protobuf::io::EpsCopyOutputStream* stream) const final;
  int GetCachedSize() const final { return _impl_._cached_size_.Get(); }

  private:
  void SharedCtor(::google::protobuf::Arena* arena);
  void SharedDtor();
  void SetCachedSize(int size) const;
  void InternalSwap(File_Description* other);

  private:
  friend class ::google::protobuf::internal::AnyMetadata;
  static ::absl::string_view FullMessageName() {
    return "turms.client.model.proto.File.Description";
  }
  protected:
  explicit File_Description(::google::protobuf::Arena* arena);
  public:

  std::string GetTypeName() const final;

  // nested types ----------------------------------------------------

  // accessors -------------------------------------------------------

  enum : int {
    kUrlFieldNumber = 1,
    kFormatFieldNumber = 3,
    kSizeFieldNumber = 2,
  };
  // string url = 1;
  void clear_url() ;
  const std::string& url() const;
  template <typename Arg_ = const std::string&, typename... Args_>
  void set_url(Arg_&& arg, Args_... args);
  std::string* mutable_url();
  PROTOBUF_NODISCARD std::string* release_url();
  void set_allocated_url(std::string* ptr);

  private:
  const std::string& _internal_url() const;
  inline PROTOBUF_ALWAYS_INLINE void _internal_set_url(
      const std::string& value);
  std::string* _internal_mutable_url();

  public:
  // optional string format = 3;
  bool has_format() const;
  void clear_format() ;
  const std::string& format() const;
  template <typename Arg_ = const std::string&, typename... Args_>
  void set_format(Arg_&& arg, Args_... args);
  std::string* mutable_format();
  PROTOBUF_NODISCARD std::string* release_format();
  void set_allocated_format(std::string* ptr);

  private:
  const std::string& _internal_format() const;
  inline PROTOBUF_ALWAYS_INLINE void _internal_set_format(
      const std::string& value);
  std::string* _internal_mutable_format();

  public:
  // optional int32 size = 2;
  bool has_size() const;
  void clear_size() ;
  ::int32_t size() const;
  void set_size(::int32_t value);

  private:
  ::int32_t _internal_size() const;
  void _internal_set_size(::int32_t value);

  public:
  // @@protoc_insertion_point(class_scope:turms.client.model.proto.File.Description)
 private:
  class _Internal;

  friend class ::google::protobuf::internal::TcParser;
  static const ::google::protobuf::internal::TcParseTable<2, 3, 0, 59, 2> _table_;
  template <typename T> friend class ::google::protobuf::Arena::InternalHelper;
  typedef void InternalArenaConstructable_;
  typedef void DestructorSkippable_;
  struct Impl_ {
    ::google::protobuf::internal::HasBits<1> _has_bits_;
    mutable ::google::protobuf::internal::CachedSize _cached_size_;
    ::google::protobuf::internal::ArenaStringPtr url_;
    ::google::protobuf::internal::ArenaStringPtr format_;
    ::int32_t size_;
    PROTOBUF_TSAN_DECLARE_MEMBER;
  };
  union { Impl_ _impl_; };
  friend struct ::TableStruct_model_2ffile_2ffile_2eproto;
};// -------------------------------------------------------------------

class File final :
    public ::google::protobuf::MessageLite /* @@protoc_insertion_point(class_definition:turms.client.model.proto.File) */ {
 public:
  inline File() : File(nullptr) {}
  ~File() override;
  template<typename = void>
  explicit PROTOBUF_CONSTEXPR File(::google::protobuf::internal::ConstantInitialized);

  File(const File& from);
  File(File&& from) noexcept
    : File() {
    *this = ::std::move(from);
  }

  inline File& operator=(const File& from) {
    CopyFrom(from);
    return *this;
  }
  inline File& operator=(File&& from) noexcept {
    if (this == &from) return *this;
    if (GetOwningArena() == from.GetOwningArena()
  #ifdef PROTOBUF_FORCE_COPY_IN_MOVE
        && GetOwningArena() != nullptr
  #endif  // !PROTOBUF_FORCE_COPY_IN_MOVE
    ) {
      InternalSwap(&from);
    } else {
      CopyFrom(from);
    }
    return *this;
  }

  inline const std::string& unknown_fields() const {
    return _internal_metadata_.unknown_fields<std::string>(::google::protobuf::internal::GetEmptyString);
  }
  inline std::string* mutable_unknown_fields() {
    return _internal_metadata_.mutable_unknown_fields<std::string>();
  }

  static const File& default_instance() {
    return *internal_default_instance();
  }
  static inline const File* internal_default_instance() {
    return reinterpret_cast<const File*>(
               &_File_default_instance_);
  }
  static constexpr int kIndexInFileMessages =
    1;

  friend void swap(File& a, File& b) {
    a.Swap(&b);
  }
  inline void Swap(File* other) {
    if (other == this) return;
  #ifdef PROTOBUF_FORCE_COPY_IN_SWAP
    if (GetOwningArena() != nullptr &&
        GetOwningArena() == other->GetOwningArena()) {
   #else  // PROTOBUF_FORCE_COPY_IN_SWAP
    if (GetOwningArena() == other->GetOwningArena()) {
  #endif  // !PROTOBUF_FORCE_COPY_IN_SWAP
      InternalSwap(other);
    } else {
      ::google::protobuf::internal::GenericSwap(this, other);
    }
  }
  void UnsafeArenaSwap(File* other) {
    if (other == this) return;
    ABSL_DCHECK(GetOwningArena() == other->GetOwningArena());
    InternalSwap(other);
  }

  // implements Message ----------------------------------------------

  File* New(::google::protobuf::Arena* arena = nullptr) const final {
    return CreateMaybeMessage<File>(arena);
  }
  void CheckTypeAndMergeFrom(const ::google::protobuf::MessageLite& from)  final;
  void CopyFrom(const File& from);
  void MergeFrom(const File& from);
  PROTOBUF_ATTRIBUTE_REINITIALIZES void Clear() final;
  bool IsInitialized() const final;

  ::size_t ByteSizeLong() const final;
  const char* _InternalParse(const char* ptr, ::google::protobuf::internal::ParseContext* ctx) final;
  ::uint8_t* _InternalSerialize(
      ::uint8_t* target, ::google::protobuf::io::EpsCopyOutputStream* stream) const final;
  int GetCachedSize() const final { return _impl_._cached_size_.Get(); }

  private:
  void SharedCtor(::google::protobuf::Arena* arena);
  void SharedDtor();
  void SetCachedSize(int size) const;
  void InternalSwap(File* other);

  private:
  friend class ::google::protobuf::internal::AnyMetadata;
  static ::absl::string_view FullMessageName() {
    return "turms.client.model.proto.File";
  }
  protected:
  explicit File(::google::protobuf::Arena* arena);
  public:

  std::string GetTypeName() const final;

  // nested types ----------------------------------------------------

  typedef File_Description Description;

  // accessors -------------------------------------------------------

  enum : int {
    kDataFieldNumber = 2,
    kDescriptionFieldNumber = 1,
  };
  // optional bytes data = 2;
  bool has_data() const;
  void clear_data() ;
  const std::string& data() const;
  template <typename Arg_ = const std::string&, typename... Args_>
  void set_data(Arg_&& arg, Args_... args);
  std::string* mutable_data();
  PROTOBUF_NODISCARD std::string* release_data();
  void set_allocated_data(std::string* ptr);

  private:
  const std::string& _internal_data() const;
  inline PROTOBUF_ALWAYS_INLINE void _internal_set_data(
      const std::string& value);
  std::string* _internal_mutable_data();

  public:
  // optional .turms.client.model.proto.File.Description description = 1;
  bool has_description() const;
  void clear_description() ;
  const ::turms::client::model::proto::File_Description& description() const;
  PROTOBUF_NODISCARD ::turms::client::model::proto::File_Description* release_description();
  ::turms::client::model::proto::File_Description* mutable_description();
  void set_allocated_description(::turms::client::model::proto::File_Description* value);
  void unsafe_arena_set_allocated_description(::turms::client::model::proto::File_Description* value);
  ::turms::client::model::proto::File_Description* unsafe_arena_release_description();

  private:
  const ::turms::client::model::proto::File_Description& _internal_description() const;
  ::turms::client::model::proto::File_Description* _internal_mutable_description();

  public:
  // @@protoc_insertion_point(class_scope:turms.client.model.proto.File)
 private:
  class _Internal;

  friend class ::google::protobuf::internal::TcParser;
  static const ::google::protobuf::internal::TcParseTable<1, 2, 1, 0, 2> _table_;
  template <typename T> friend class ::google::protobuf::Arena::InternalHelper;
  typedef void InternalArenaConstructable_;
  typedef void DestructorSkippable_;
  struct Impl_ {
    ::google::protobuf::internal::HasBits<1> _has_bits_;
    mutable ::google::protobuf::internal::CachedSize _cached_size_;
    ::google::protobuf::internal::ArenaStringPtr data_;
    ::turms::client::model::proto::File_Description* description_;
    PROTOBUF_TSAN_DECLARE_MEMBER;
  };
  union { Impl_ _impl_; };
  friend struct ::TableStruct_model_2ffile_2ffile_2eproto;
};

// ===================================================================




// ===================================================================


#ifdef __GNUC__
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wstrict-aliasing"
#endif  // __GNUC__
// -------------------------------------------------------------------

// File_Description

// string url = 1;
inline void File_Description::clear_url() {
  _impl_.url_.ClearToEmpty();
}
inline const std::string& File_Description::url() const {
  // @@protoc_insertion_point(field_get:turms.client.model.proto.File.Description.url)
  return _internal_url();
}
template <typename Arg_, typename... Args_>
inline PROTOBUF_ALWAYS_INLINE void File_Description::set_url(Arg_&& arg,
                                                     Args_... args) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  ;
  _impl_.url_.Set(static_cast<Arg_&&>(arg), args..., GetArenaForAllocation());
  // @@protoc_insertion_point(field_set:turms.client.model.proto.File.Description.url)
}
inline std::string* File_Description::mutable_url() {
  std::string* _s = _internal_mutable_url();
  // @@protoc_insertion_point(field_mutable:turms.client.model.proto.File.Description.url)
  return _s;
}
inline const std::string& File_Description::_internal_url() const {
  PROTOBUF_TSAN_READ(&_impl_._tsan_detect_race);
  return _impl_.url_.Get();
}
inline void File_Description::_internal_set_url(const std::string& value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  ;
  _impl_.url_.Set(value, GetArenaForAllocation());
}
inline std::string* File_Description::_internal_mutable_url() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  ;
  return _impl_.url_.Mutable( GetArenaForAllocation());
}
inline std::string* File_Description::release_url() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  // @@protoc_insertion_point(field_release:turms.client.model.proto.File.Description.url)
  return _impl_.url_.Release();
}
inline void File_Description::set_allocated_url(std::string* value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_.url_.SetAllocated(value, GetArenaForAllocation());
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        if (_impl_.url_.IsDefault()) {
          _impl_.url_.Set("", GetArenaForAllocation());
        }
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.File.Description.url)
}

// optional int32 size = 2;
inline bool File_Description::has_size() const {
  bool value = (_impl_._has_bits_[0] & 0x00000002u) != 0;
  return value;
}
inline void File_Description::clear_size() {
  _impl_.size_ = 0;
  _impl_._has_bits_[0] &= ~0x00000002u;
}
inline ::int32_t File_Description::size() const {
  // @@protoc_insertion_point(field_get:turms.client.model.proto.File.Description.size)
  return _internal_size();
}
inline void File_Description::set_size(::int32_t value) {
  _internal_set_size(value);
  // @@protoc_insertion_point(field_set:turms.client.model.proto.File.Description.size)
}
inline ::int32_t File_Description::_internal_size() const {
  PROTOBUF_TSAN_READ(&_impl_._tsan_detect_race);
  return _impl_.size_;
}
inline void File_Description::_internal_set_size(::int32_t value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000002u;
  _impl_.size_ = value;
}

// optional string format = 3;
inline bool File_Description::has_format() const {
  bool value = (_impl_._has_bits_[0] & 0x00000001u) != 0;
  return value;
}
inline void File_Description::clear_format() {
  _impl_.format_.ClearToEmpty();
  _impl_._has_bits_[0] &= ~0x00000001u;
}
inline const std::string& File_Description::format() const {
  // @@protoc_insertion_point(field_get:turms.client.model.proto.File.Description.format)
  return _internal_format();
}
template <typename Arg_, typename... Args_>
inline PROTOBUF_ALWAYS_INLINE void File_Description::set_format(Arg_&& arg,
                                                     Args_... args) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000001u;
  _impl_.format_.Set(static_cast<Arg_&&>(arg), args..., GetArenaForAllocation());
  // @@protoc_insertion_point(field_set:turms.client.model.proto.File.Description.format)
}
inline std::string* File_Description::mutable_format() {
  std::string* _s = _internal_mutable_format();
  // @@protoc_insertion_point(field_mutable:turms.client.model.proto.File.Description.format)
  return _s;
}
inline const std::string& File_Description::_internal_format() const {
  PROTOBUF_TSAN_READ(&_impl_._tsan_detect_race);
  return _impl_.format_.Get();
}
inline void File_Description::_internal_set_format(const std::string& value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000001u;
  _impl_.format_.Set(value, GetArenaForAllocation());
}
inline std::string* File_Description::_internal_mutable_format() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000001u;
  return _impl_.format_.Mutable( GetArenaForAllocation());
}
inline std::string* File_Description::release_format() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  // @@protoc_insertion_point(field_release:turms.client.model.proto.File.Description.format)
  if ((_impl_._has_bits_[0] & 0x00000001u) == 0) {
    return nullptr;
  }
  _impl_._has_bits_[0] &= ~0x00000001u;
  auto* released = _impl_.format_.Release();
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
  _impl_.format_.Set("", GetArenaForAllocation());
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  return released;
}
inline void File_Description::set_allocated_format(std::string* value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  if (value != nullptr) {
    _impl_._has_bits_[0] |= 0x00000001u;
  } else {
    _impl_._has_bits_[0] &= ~0x00000001u;
  }
  _impl_.format_.SetAllocated(value, GetArenaForAllocation());
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        if (_impl_.format_.IsDefault()) {
          _impl_.format_.Set("", GetArenaForAllocation());
        }
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.File.Description.format)
}

// -------------------------------------------------------------------

// File

// optional .turms.client.model.proto.File.Description description = 1;
inline bool File::has_description() const {
  bool value = (_impl_._has_bits_[0] & 0x00000002u) != 0;
  PROTOBUF_ASSUME(!value || _impl_.description_ != nullptr);
  return value;
}
inline void File::clear_description() {
  if (_impl_.description_ != nullptr) _impl_.description_->Clear();
  _impl_._has_bits_[0] &= ~0x00000002u;
}
inline const ::turms::client::model::proto::File_Description& File::_internal_description() const {
  PROTOBUF_TSAN_READ(&_impl_._tsan_detect_race);
  const ::turms::client::model::proto::File_Description* p = _impl_.description_;
  return p != nullptr ? *p : reinterpret_cast<const ::turms::client::model::proto::File_Description&>(::turms::client::model::proto::_File_Description_default_instance_);
}
inline const ::turms::client::model::proto::File_Description& File::description() const {
  // @@protoc_insertion_point(field_get:turms.client.model.proto.File.description)
  return _internal_description();
}
inline void File::unsafe_arena_set_allocated_description(::turms::client::model::proto::File_Description* value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  if (GetArenaForAllocation() == nullptr) {
    delete reinterpret_cast<::google::protobuf::MessageLite*>(_impl_.description_);
  }
  _impl_.description_ = reinterpret_cast<::turms::client::model::proto::File_Description*>(value);
  if (value != nullptr) {
    _impl_._has_bits_[0] |= 0x00000002u;
  } else {
    _impl_._has_bits_[0] &= ~0x00000002u;
  }
  // @@protoc_insertion_point(field_unsafe_arena_set_allocated:turms.client.model.proto.File.description)
}
inline ::turms::client::model::proto::File_Description* File::release_description() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);

  _impl_._has_bits_[0] &= ~0x00000002u;
  ::turms::client::model::proto::File_Description* released = _impl_.description_;
  _impl_.description_ = nullptr;
#ifdef PROTOBUF_FORCE_COPY_IN_RELEASE
  auto* old = reinterpret_cast<::google::protobuf::MessageLite*>(released);
  released = ::google::protobuf::internal::DuplicateIfNonNull(released);
  if (GetArenaForAllocation() == nullptr) {
    delete old;
  }
#else   // PROTOBUF_FORCE_COPY_IN_RELEASE
  if (GetArenaForAllocation() != nullptr) {
    released = ::google::protobuf::internal::DuplicateIfNonNull(released);
  }
#endif  // !PROTOBUF_FORCE_COPY_IN_RELEASE
  return released;
}
inline ::turms::client::model::proto::File_Description* File::unsafe_arena_release_description() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  // @@protoc_insertion_point(field_release:turms.client.model.proto.File.description)

  _impl_._has_bits_[0] &= ~0x00000002u;
  ::turms::client::model::proto::File_Description* temp = _impl_.description_;
  _impl_.description_ = nullptr;
  return temp;
}
inline ::turms::client::model::proto::File_Description* File::_internal_mutable_description() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000002u;
  if (_impl_.description_ == nullptr) {
    auto* p = CreateMaybeMessage<::turms::client::model::proto::File_Description>(GetArenaForAllocation());
    _impl_.description_ = reinterpret_cast<::turms::client::model::proto::File_Description*>(p);
  }
  return _impl_.description_;
}
inline ::turms::client::model::proto::File_Description* File::mutable_description() {
  ::turms::client::model::proto::File_Description* _msg = _internal_mutable_description();
  // @@protoc_insertion_point(field_mutable:turms.client.model.proto.File.description)
  return _msg;
}
inline void File::set_allocated_description(::turms::client::model::proto::File_Description* value) {
  ::google::protobuf::Arena* message_arena = GetArenaForAllocation();
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  if (message_arena == nullptr) {
    delete reinterpret_cast<::turms::client::model::proto::File_Description*>(_impl_.description_);
  }

  if (value != nullptr) {
    ::google::protobuf::Arena* submessage_arena =
        ::google::protobuf::Arena::InternalGetOwningArena(reinterpret_cast<::turms::client::model::proto::File_Description*>(value));
    if (message_arena != submessage_arena) {
      value = ::google::protobuf::internal::GetOwnedMessage(message_arena, value, submessage_arena);
    }
    _impl_._has_bits_[0] |= 0x00000002u;
  } else {
    _impl_._has_bits_[0] &= ~0x00000002u;
  }

  _impl_.description_ = reinterpret_cast<::turms::client::model::proto::File_Description*>(value);
  // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.File.description)
}

// optional bytes data = 2;
inline bool File::has_data() const {
  bool value = (_impl_._has_bits_[0] & 0x00000001u) != 0;
  return value;
}
inline void File::clear_data() {
  _impl_.data_.ClearToEmpty();
  _impl_._has_bits_[0] &= ~0x00000001u;
}
inline const std::string& File::data() const {
  // @@protoc_insertion_point(field_get:turms.client.model.proto.File.data)
  return _internal_data();
}
template <typename Arg_, typename... Args_>
inline PROTOBUF_ALWAYS_INLINE void File::set_data(Arg_&& arg,
                                                     Args_... args) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000001u;
  _impl_.data_.SetBytes(static_cast<Arg_&&>(arg), args..., GetArenaForAllocation());
  // @@protoc_insertion_point(field_set:turms.client.model.proto.File.data)
}
inline std::string* File::mutable_data() {
  std::string* _s = _internal_mutable_data();
  // @@protoc_insertion_point(field_mutable:turms.client.model.proto.File.data)
  return _s;
}
inline const std::string& File::_internal_data() const {
  PROTOBUF_TSAN_READ(&_impl_._tsan_detect_race);
  return _impl_.data_.Get();
}
inline void File::_internal_set_data(const std::string& value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000001u;
  _impl_.data_.Set(value, GetArenaForAllocation());
}
inline std::string* File::_internal_mutable_data() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  _impl_._has_bits_[0] |= 0x00000001u;
  return _impl_.data_.Mutable( GetArenaForAllocation());
}
inline std::string* File::release_data() {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  // @@protoc_insertion_point(field_release:turms.client.model.proto.File.data)
  if ((_impl_._has_bits_[0] & 0x00000001u) == 0) {
    return nullptr;
  }
  _impl_._has_bits_[0] &= ~0x00000001u;
  auto* released = _impl_.data_.Release();
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
  _impl_.data_.Set("", GetArenaForAllocation());
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  return released;
}
inline void File::set_allocated_data(std::string* value) {
  PROTOBUF_TSAN_WRITE(&_impl_._tsan_detect_race);
  if (value != nullptr) {
    _impl_._has_bits_[0] |= 0x00000001u;
  } else {
    _impl_._has_bits_[0] &= ~0x00000001u;
  }
  _impl_.data_.SetAllocated(value, GetArenaForAllocation());
  #ifdef PROTOBUF_FORCE_COPY_DEFAULT_STRING
        if (_impl_.data_.IsDefault()) {
          _impl_.data_.Set("", GetArenaForAllocation());
        }
  #endif  // PROTOBUF_FORCE_COPY_DEFAULT_STRING
  // @@protoc_insertion_point(field_set_allocated:turms.client.model.proto.File.data)
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

#endif  // GOOGLE_PROTOBUF_INCLUDED_model_2ffile_2ffile_2eproto_2epb_2eh