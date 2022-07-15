//
//  ContentView.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/12.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @State private var task = ""
  
  private var isButtonDisabled: Bool {
    task.isEmpty
  }
  
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  
  private func addItem() {
    withAnimation {
      let newItem = Item(context: viewContext)
      newItem.timestamp = Date()
      newItem.completed = false
      newItem.task = task
      newItem.id = UUID()
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
      task = ""
      hideKeyboard()
    }
  }
  
  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      offsets.map { items[$0] }.forEach(viewContext.delete)
      
      do {
        try viewContext.save()
      } catch {
        let nsError = error as NSError
        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
      }
    }
  }
  
  var body: some View {
    NavigationView {
      ZStack {
        VStack {
          VStack(spacing: 10) {
            TextField("Task", text: $task)
              .padding()
              .background(
                Color(UIColor.systemGray6)
              )
              .cornerRadius(10)
            
            Button(action: {
              addItem()
            }, label: {
              Spacer()
              Text("save")
              Spacer()
            })
            .disabled(isButtonDisabled)
            .font(.headline)
            .padding()
            .foregroundColor(.white)
            .background(
              isButtonDisabled ? Color.gray : Color.pink
            )
            .cornerRadius(10)

          }
          .padding()
          
          List {
            ForEach(items) { item in
              VStack(alignment: .leading) {
                Text(item.task ?? "")
                  .font(.headline)
                  .fontWeight(.bold)
                
                Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                  .font(.footnote)
                  .foregroundColor(.gray)
              }
            } //: LIST ITEM
            .onDelete(perform: deleteItems)
          } //: LIST
          .listStyle(InsetGroupedListStyle())
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
          .padding(.vertical, 0)
          .frame(maxWidth: 640)
        } //: VSTACK
      } //: ZSTACK
      .onAppear() {
        UITableView.appearance().backgroundColor = .clear
      }
      .navigationTitle("Daily Task")
      .navigationBarTitleDisplayMode(.large)
      .toolbar {
        ToolbarItem(placement: .navigationBarTrailing) {
          EditButton()
        }
      }//: TOOLBAR
      .background(
        BackgroundImageView()
      )
      .background(
        backgroundGradient.ignoresSafeArea(.all)
      )
      
      Text("Select an item")
    } //: NAVIGATION
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
  }
}
