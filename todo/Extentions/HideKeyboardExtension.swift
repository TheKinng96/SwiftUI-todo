//
//  HideKeyboardExtension.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/14.
//

import SwiftUI

#if canImport(UIKit)
extension View {
  func hideKeyboard() {
    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
#endif
