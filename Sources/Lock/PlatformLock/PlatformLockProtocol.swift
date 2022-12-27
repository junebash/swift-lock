internal protocol PlatformLockProtocol {
  associatedtype Primitive

  typealias PrimitivePointer = UnsafeMutablePointer<Primitive>

  var primitive: PrimitivePointer { get }

  init(_ primitive: PrimitivePointer)

  static func initialize(_ primitive: PrimitivePointer)
  static func deinitialize(_ primitive: PrimitivePointer)
  static func lock(_ primitive: PrimitivePointer)
  static func unlock(_ primitive: PrimitivePointer)
}

extension PlatformLockProtocol {
  static func allocate() -> Self {
    let platformLock = PrimitivePointer.allocate(capacity: 1)
    Self.initialize(platformLock)
    return Self(platformLock)
  }

  func deinitialize() {
    Self.deinitialize(primitive)
  }

  func lock() {
    Self.lock(primitive)
  }

  func unlock() {
    Self.unlock(primitive)
  }
}
