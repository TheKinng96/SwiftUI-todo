//
//  BlankView.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/16.
//

import SwiftUI

struct BlankView: View {
  var body: some View {
    VStack {
     Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    .background(.black)
    .opacity(0.5)
    .ignoresSafeArea(.all)
  }
}

struct BlankView_Previews: PreviewProvider {
  static var previews: some View {
    BlankView()
  }
}
