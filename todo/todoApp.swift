//
//  todoApp.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/12.
//

import SwiftUI

@main
struct todoApp: App {
  @AppStorage("isDarkMode") var isDarkMode: Bool = false
  let persistenceController = PersistenceController.shared
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .preferredColorScheme(isDarkMode ? .dark : .light)
    }
  }
}
