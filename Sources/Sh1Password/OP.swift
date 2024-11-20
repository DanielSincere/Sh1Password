import Sh
import Foundation

public final class OP {

  public init() {}

  public func get(item: String, vault: String, fields: String, reveal: Bool = false) throws -> String {
    let cmd =
    """
    op item get "\(item)" --vault "\(vault)" --fields "\(fields)" \(reveal ? " --reveal" : "")
    """
    if let value = try sh(cmd) {
      return value
    } else {
      throw ItemFieldsNotFoundError(item: item, vault: vault, fields: fields)
    }
  }

  // async version
  public func get(item: String, vault: String, fields: String, reveal: Bool = false) async throws -> String {
    let cmd =
    """
    op item get "\(item)" --vault "\(vault)" --fields "\(fields)" \(reveal ? " --reveal" : "")
    """
    if let value = try await sh(cmd) {
      return value
    } else {
      throw ItemFieldsNotFoundError(item: item, vault: vault, fields: fields)
    }
  }

  public func get(item: String, vault: String, section: String, field: String) throws -> String {

    let output = try self.get(item: item, vault: vault)

    guard let value = output.valueOf(field: field, section: section) else {
      throw FieldNotFoundError(item: item, vault: vault, section: section, field: field)
    }

    return value
  }

  // async version
  public func get(item: String, vault: String, section: String, field: String) async throws -> String {

    let output = try await self.get(item: item, vault: vault)

    guard let value = output.valueOf(field: field, section: section) else {
      throw FieldNotFoundError(item: item, vault: vault, section: section, field: field)
    }

    return value
  }

  public func get(item: String, vault: String) throws -> Output {
    let cmd =
    """
    op item get "\(item)" --vault "\(vault)" --format json
    """
    return try sh(Output.self, cmd)
  }


  // async version
  public func get(item: String, vault: String) async throws -> Output {
    let cmd =
    """
    op item get "\(item)" --vault "\(vault)" --format json
    """
    return try await sh(Output.self, cmd)
  }

  public struct ItemFieldsNotFoundError: Error {
    public let item: String, vault: String, fields: String
  }

  public struct FieldNotFoundError: Error {
    public let item: String, vault: String, section: String, field: String
  }

  public struct Output: Decodable {

    public let fields: [Field]

    public struct Field: Decodable {
      public let id: String
      public let label: String
      public let value: String?
      public let section: Section?
    }

    public struct Section: Decodable {
      public let id: String
      public let label: String?
    }

    public func valueOf(field: String, section: String) -> String? {
      self.fields.filter { $0.label == field && $0.section?.label == section }.first?.value
    }
    
    public func valueOf(field: String) -> String? {
      self.fields.filter { $0.label == field }.first?.value
    }
  }
}
