#if canImport(Glibc)
@_implementationOnly import Glibc

internal struct PlatformLock: PlatformLockProtocol {
  typealias Primitive = pthread_mutex_t
  typealias PrimitivePointer = UnsafeMutablePointer<Primitive>

  let primitive: PrimitivePointer

  init(_ primitive: PrimitivePointer) {
    self.primitive = primitive
  }

  static func initialize(_ primitive: PrimitivePointer) {
    pthread_mutex_init(primitive, nil)
  }

  static func deinitialize(_ primitive: PrimitivePointer) {
    pthread_mutex_destroy(primitive)
    primitive.deinitialize(count: 1)
  }

  static func lock(_ primitive: PrimitivePointer) {
    pthread_mutex_lock(primitive)
  }

  static func unlock(_ primitive: PrimitivePointer) {
    pthread_mutex_unlock(platformLock)
  }
}
#endif
