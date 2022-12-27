public struct Lock<State>: @unchecked Sendable {
  private final class LockedBuffer: ManagedBuffer<State, PlatformLock.Primitive> {
    deinit {
      withUnsafeMutablePointerToElements { PlatformLock.deinitialize($0) }
    }
  }

  private let buffer: ManagedBuffer<State, PlatformLock.Primitive>

  public init(uncheckedCreate: () throws -> State) rethrows {
    buffer = try LockedBuffer.create(minimumCapacity: 1) { buffer in
      buffer.withUnsafeMutablePointerToElements { PlatformLock.initialize($0) }
      return try uncheckedCreate()
    }
  }

  public init(unchecked state: State) {
    self.init(uncheckedCreate: { state })
  }

  public func withLock<R>(_ perform: (inout State) throws -> R) rethrows -> R {
    try buffer.withUnsafeMutablePointers { header, lock in
      PlatformLock.lock(lock)
      defer { PlatformLock.unlock(lock) }
      return try perform(&header.pointee)
    }
  }

  public func withLock(_ perform: (inout State) throws -> Void) rethrows {
    try buffer.withUnsafeMutablePointers { header, lock in
      PlatformLock.lock(lock)
      defer { PlatformLock.unlock(lock) }
      try perform(&header.pointee)
    }
  }
}

extension Lock {
  public init(initialState: State) where State: Sendable {
    self.init(unchecked: initialState)
  }

  public init(create: () throws -> State) rethrows where State: Sendable {
    try self.init(uncheckedCreate: create)
  }

  public init() where State == Void {
    self.init(unchecked: ())
  }

  public func withLock<R>(_ perform: () throws -> R) rethrows -> R
  where State == Void {
    try buffer.withUnsafeMutablePointerToElements { lock in
      PlatformLock.lock(lock)
      defer { PlatformLock.unlock(lock) }
      return try perform()
    }
  }
}

extension Lock: Equatable where State: Equatable {
  public static func == (lhs: Lock<State>, rhs: Lock<State>) -> Bool {
    lhs.withLock { l in
      rhs.withLock { r in
        l == r
      }
    }
  }
}

extension Lock: Hashable where State: Hashable {
  public func hash(into hasher: inout Hasher) {
    withLock { state in
      hasher.combine(state)
    }
  }
}
