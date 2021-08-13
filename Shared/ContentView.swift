//
//  ContentView.swift
//  Shared
//
//  Created by Dmytro Anokhin on 13/08/2021.
//

import SwiftUI

struct ContentView: View {

    var size = CGSize(width: 800.0, height: 800.0)

    var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical]) {
                ZStack(alignment: .topLeading) {
                    Rectangle()
                        .fill(.green)
                        .frame(width: innerRect.width, height: innerRect.height)
                        .position(x: innerRect.midX, y: innerRect.midY)

                    SelectionView(selectionRect: $outerRect)
                }
                .frame(width: size.width, height: size.height)
                .background(Color.gray)
            }
            VStack(alignment: .leading) {
                HStack {
                    TextField("Width", value: $width, formatter: ContentView.formatter)
                        .textFieldStyle(.roundedBorder)
                    Text("x")
                    TextField("Height", value: $height, formatter: ContentView.formatter)
                        .textFieldStyle(.roundedBorder)
                }
            }
            .padding(.all)
        }
        .onChange(of: outerRect) { _ in
            updateInnerRect()
        }
        .onChange(of: width) { _ in
            updateInnerRect()
        }
        .onChange(of: height) { _ in
            updateInnerRect()
        }
        .onAppear {
            updateInnerRect()
        }
    }

    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal

        return formatter
    }()

    @State private var width: CGFloat = 1.0
    @State private var height: CGFloat = 1.0

    @State private var innerRect: CGRect = .zero
    @State private var outerRect: CGRect = CGRect(x: 20.0, y: 20.0, width: 200.0, height: 200.0)

    private func updateInnerRect() {
        let rect = CGRect(origin: .zero, size: CGSize(width: width, height: height))
        innerRect = aspectFit(rect: rect, in: outerRect)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
