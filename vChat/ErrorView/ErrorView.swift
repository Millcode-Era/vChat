//
//  ErrorView.swift
//  vChat
//
//  Created by Akivili Collindort on 2023/7/27.
//

import SwiftUI

struct ErrorView: View {
    var errorArea: String?
    var error: Error?
    var body: some View {
        ZStack {
            Color(.red)
                .opacity(0.1)
                .ignoresSafeArea()
            VStack {
                Text("Some error occurd!")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Image(systemName: "xmark.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .symbolRenderingMode(.multicolor)
                    .frame(width: 100)
                    .symbolEffect(.pulse.wholeSymbol)
                    .padding()
                Text("Relax, it's not your fault.")
                    .padding()
                
                Text("Error Area: \(errorArea ?? "nil")")
                Text("Error Description: \(error?.localizedDescription ?? "nil")")
                Text("Error Info: \(error.debugDescription)")
                Spacer().frame(height: 50)
                Button(role: .cancel) {
                    exit(0)
                } label: {
                    Text("Exit")
                        .font(.title3)
                        .padding(.horizontal)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .padding()
                Spacer()
            }
            .scenePadding()
        }
    }
}

#Preview {
    ErrorView()
}
