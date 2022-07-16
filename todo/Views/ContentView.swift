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
              playSound(fileName: "sound-tap", type: "mp3")
              feedback.notificationOccurred(.success)
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
            playSound(fileName: "sound-ding", type: "mp3")
            feedback.notificationOccurred(.success)
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
              ListRowView(item: item)
            } //: LIST ITEM
            .onDelete(perform: deleteItems)
          } //: LIST
          .listStyle(InsetGroupedListStyle())
          .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.3), radius: 12)
          .padding(.vertical, 0)
          .frame(maxWidth: 640)
        } //: VSTACK
        .blur(radius: showAddTaskModal ? 8.0 : 0, opaque: false)
        .transition(.move(edge: .bottom))
        .animation(.easeOut(duration: 0.5), value: showAddTaskModal)
        
        if showAddTaskModal {
          BlankView(
            backgroundColor: isDarkMode ? Color.black : Color.gray,
            backgroundOpacity: isDarkMode ? 0.3 : 0.5
          )
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
          .blur(radius: showAddTaskModal ? 8.0 : 0, opaque: false)
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
