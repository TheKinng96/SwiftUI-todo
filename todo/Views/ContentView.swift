//
//  ContentView.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/12.
//

import SwiftUI
import CoreData

struct ContentView: View {
  @AppStorage("isDarkMode") private var isDarkMode: Bool = false
  @State private var task = ""
  @State private var showAddTaskModal = false
  @Environment(\.managedObjectContext) private var viewContext
  
  @FetchRequest(
    sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
    animation: .default)
  private var items: FetchedResults<Item>
  
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
          HStack {
            Text("Devote")
              .font(.system(size: 30, weight: .bold, design: .rounded))
            
            Spacer()
            
            EditButton()
              .font(.system(size: 16, weight: .semibold, design: .rounded))
              .padding(.horizontal, 10)
              .frame(minWidth: 70, minHeight: 24)
              .background(
                Capsule().stroke(lineWidth: 2)
              )
            
            Button(action: {
              isDarkMode.toggle()
            }, label: {
              Image(systemName: isDarkMode ? "moon.circle.fill" : "moon.circle")
                .resizable()
                .frame(width: 24, height: 24)
                .font(.system(.title, design: .rounded))
            })
            
          }
          .padding()
          .foregroundColor(.white)
          
          Spacer(minLength: 80)
          
          Button(action: {
            showAddTaskModal = true
          }, label: {
            Image(systemName: "plus.circle")
              .font(.system(size: 30, weight: .bold, design: .rounded))
            Text("New Task")
              .font(.system(size: 24, weight: .bold, design: .rounded))
          })
          .foregroundColor(.white)
          .padding(.horizontal, 20)
          .padding(.vertical, 15)
          .background(
            LinearGradient(gradient: Gradient(colors: [.red, .blue]), startPoint: .leading, endPoint: .trailing)
          )
          .clipShape(Capsule())
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 16, x: 0, y: 4)
          
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
        
        if showAddTaskModal {
          BlankView()
            .onTapGesture {
              withAnimation() {
                showAddTaskModal = false
              }
            }
          TaskItemView(isShowing: $showAddTaskModal)
        }
        
      } //: ZSTACK
      .onAppear() {
        UITableView.appearance().backgroundColor = .clear
      }
      .navigationTitle("Daily Task")
      .navigationBarTitleDisplayMode(.large)
      .navigationBarHidden(true)
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
