//
//  BlankView.swift
//  todo
//
//  Created by Feng Yuan Yap on 2022/07/16.
//

import SwiftUI

struct BlankView: View {
  var backgroundColor: Color
  var backgroundOpacity: Double

  var body: some View {
    VStack {
     Spacer()
    }
    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    .background(backgroundColor)
    .opacity(backgroundOpacity)
    .blendMode(.overlay)
    .ignoresSafeArea(.all)
  }
}

struct BlankView_Previews: PreviewProvider {
  static var previews: some View {
    BlankView(backgroundColor: Color.black, backgroundOpacity: 0.3)
      .background(BackgroundImageView())
      .background(backgroundGradient.ignoresSafeArea(.all))
  }
}
