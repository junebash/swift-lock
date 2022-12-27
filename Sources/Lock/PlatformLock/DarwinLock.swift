#if canImport(Darwin)
@_implementationOnly import Darwin

internal struct PlatformLock: PlatformLockProtocol {
  typealias Primitive = os_unfair_lock
  typealias PrimitivePointer = UnsafeMutablePointer<Primitive>

  let primitive: PrimitivePointer

  init(_ primitive: PrimitivePointer) {
    self.primitive = primitive
  }

  static func initialize(_ primitive: PrimitivePointer) {
    primitive.initialize(to: os_unfair_lock())
  }

  static func deinitialize(_ primitive: PrimitivePointer) {
    primitive.deinitialize(count: 1)
  }

  static func lock(_ primitive: PrimitivePointer) {
    os_unfair_lock_lock(primitive)
  }

  static func unlock(_ primitive: PrimitivePointer) {
    os_unfair_lock_unlock(primitive)
  }
}
#endif
