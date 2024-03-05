//
//  AttributedScopes.swift
//  AttributedString
//
//  Created by Andrew Cunningham on 3/4/24.
//

import SwiftUI

public extension AttributeScopes {
  struct CustomAttributes: AttributeScope {
    let customColor: CustomColorAttributes
    let swiftUI: SwiftUIAttributes
  }

  var customAttributes: CustomAttributes.Type { CustomAttributes.self }
}

public enum CustomColorAttributes: CodableAttributedStringKey, MarkdownDecodableAttributedStringKey {
  public enum Value: String, Codable {
    case yellow, green, red
  }

  public static var name = "customColor"
}

public extension AttributeDynamicLookup {
  subscript<T: AttributedStringKey>(
    dynamicMember keyPath: KeyPath<AttributeScopes.CustomAttributes, T>
  ) -> T {
    self[T.self]
  }
}
