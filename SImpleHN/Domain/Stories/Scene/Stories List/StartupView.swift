//
//  StartupView.swift
//  SImpleHN
//
//  Created by Miroslav Taleiko on 25.12.2022.
//

import SwiftUI

struct StartupView: View {
    @State private var isAnimating = false
    @State private var scale = 1.0

    
    var body: some View {
        ZStack {
            Color("RowBackgroundColor")
                .ignoresSafeArea(.all)
            
            HNLogoView()
                .scaleEffect(x: 1.0 / scale, y: scale, anchor: .center)
                .offset(y: yOffset)
                .onAppear {
                    animate()
                }
        }
    }
    
    private var yOffset: CGFloat {
        isAnimating ? -100 : 0
    }
    
    private var duration: CGFloat = 0.5
    private func animate() {
        withAnimation(.easeInOut(duration: duration).repeatForever()) {
            isAnimating = true
        }
        
        withAnimation(.easeOut(duration: duration).repeatForever()) {
            scale = 0.85
        }
    }
}

struct HNLogoView: View {
    var body: some View {

            
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

struct StartupView_Previews: PreviewProvider {
    static var previews: some View {
        StartupView()
    }
}
