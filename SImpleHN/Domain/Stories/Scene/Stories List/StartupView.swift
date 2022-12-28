//
//  StartupView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 25.12.2022.
//

import SwiftUI

struct StartupView: View {
    var body: some View {
        ZStack {
            Color("RowBackgroundColor")
                .ignoresSafeArea(.all)
            
            Text("Y")
                .font(.custom("Helvetica", size: 128, relativeTo: .title))
                .padding()
                .foregroundColor(.white)
                .background {
                    Rectangle()
                        .aspectRatio(contentMode: .fill)
                        .foregroundColor(Color("MainColor"))
                        .border(Color.white, width: 10)
                        .overlay {
                            Rectangle()
                                .foregroundColor(.clear)
                                .border(Color("MainColor"), width: 4)
                        }
                }
        }
    }
}

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
