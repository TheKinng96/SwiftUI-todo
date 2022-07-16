//
//  TaskItemView.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/15.
//

import SwiftUI

struct TaskItemView: View {
  @Environment(\.managedObjectContext) private var viewContext
  @State private var task = ""
  @Binding var isShowing: Bool
  
  private var isButtonDisabled: Bool {
    task.isEmpty
  }
  
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
      isShowing = false
    }
  }

  var body: some View {
    VStack {
      Spacer()
      
      VStack(spacing: 10) {
        TextField("Task", text: $task)
          .foregroundColor(.pink)
          .font(.system(size: 24, weight: .bold, design: .rounded))
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
            .font(.system(size: 24, weight: .bold, design: .rounded))
          Spacer()
        })
        .disabled(isButtonDisabled)
        .padding()
        .foregroundColor(.white)
        .background(
          isButtonDisabled ? Color.blue : Color.pink
        )
        .cornerRadius(10)
      } //: VSTACK
      .padding(.horizontal)
      .padding(.vertical, 20)
      .background(
        Color.white
      )
      .cornerRadius(16)
      .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.65), radius: 24)
      .frame(maxWidth: 640)
    } //: VSTACK
    .padding()
  }
}

struct TaskItemView_Previews: PreviewProvider {
  static var previews: some View {
    TaskItemView(isShowing: .constant(true))
      .background(Color.gray.ignoresSafeArea(.all))
  }
}
