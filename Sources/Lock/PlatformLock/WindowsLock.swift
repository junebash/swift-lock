#if canImport(WinSDK)
@_implementationOnly import WinSDK

internal struct PlatformLock: PlatformLockProtocol {
  typealias Primitive = SRWLOCK
  typealias PrimitivePointer = UnsafeMutablePointer<Primitive>

  let primitive: PrimitivePointer

  init(_ primitive: PrimitivePointer) {
    self.primitive = primitive
  }

  static func initialize(_ primitive: PrimitivePointer) {
    InitializeSRWLock(primitive)
  }

  static func deinitialize(_ primitive: PrimitivePointer) {
    primitive.deinitialize(count: 1)
  }

  static func lock(_ primitive: PrimitivePointer) {
    AcquireSRWLockExclusive(primitive)
  }

  static func unlock(_ primitive: PrimitivePointer) {
    ReleaseSRWLockExclusive(primitive)
  }
}
#endif
