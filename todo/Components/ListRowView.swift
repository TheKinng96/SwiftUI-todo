//
//  ListRowView.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/16.
//

import SwiftUI

struct ListRowView: View {
  @Environment(\.managedObjectContext) var viewContext
  @ObservedObject var item: Item
  
  var body: some View {
    Toggle(isOn: $item.completed) {
      Text(item.task ?? "")
        .font(.system(.title2, design: .rounded))
        .fontWeight(.heavy)
        .foregroundColor(item.completed ? .pink : .primary)
        .padding(.vertical, 12)
        .animation(.default, value: item.completed)
    } //: TOGGLE
    .toggleStyle(CheckboxStyle())
    .onReceive(item.objectWillChange) { _ in
      if self.viewContext.hasChanges {
        try? self.viewContext.save()
      }
    }
  }
}
