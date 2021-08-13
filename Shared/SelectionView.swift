//
//  SelectionView.swift
//  SelectionView
//
//  Created by Dmytro Anokhin on 13/08/2021.
//

import SwiftUI


/// Drag direction, counter clockwise
enum Direction: CaseIterable {

    case top

    case topLeft

    case left

    case bottomLeft

    case bottom

    case bottomRight

    case right

    case topRight

    func translateRect(_ rect: CGRect, translation: CGSize) -> CGRect {
        CGRect(origin: translatePoint(rect.origin, translation: translation),
               size: translateSize(rect.size, translation: translation))
    }

    func translatePoint(_ point: CGPoint, translation: CGSize) -> CGPoint {
        var result = point

        switch self {
            case .top:
                result.y += translation.height

            case .topLeft:
                result.x += translation.width
                result.y += translation.height

            case .left:
                result.x += translation.width

            case .bottomLeft:
                result.x += translation.width

            case .bottom:
                break

            case .bottomRight:
                break

            case .right:
                break

            case .topRight:
                result.y += translation.height
        }

        return result
    }

    func translateSize(_ size: CGSize, translation: CGSize) -> CGSize {
        var result = size

        switch self {
            case .top:
                result.height -= translation.height

            case .topLeft:
                result.width -= translation.width
                result.height -= translation.height

            case .left:
                result.width -= translation.width

            case .bottomLeft:
                result.width -= translation.width
                result.height += translation.height

            case .bottom:
                result.height += translation.height

            case .bottomRight:
                result.width += translation.width
                result.height += translation.height

            case .right:
                result.width += translation.width

            case .topRight:
                result.width += translation.width
                result.height -= translation.height
        }

        return result
    }
}


enum DragState {

    case inactive
    case pressing
    case dragging(translation: CGSize, direction: Direction)

    var translation: CGSize {
        switch self {
            case .inactive, .pressing:
                return .zero
            case .dragging(let translation, _):
                return translation
        }
    }

    var direction: Direction? {
        switch self {
            case .inactive, .pressing:
                return nil
            case .dragging(_, let direction):
                return direction
        }
    }

    func translateRect(_ rect: CGRect) -> CGRect {
        switch self {
            case .inactive, .pressing:
                return rect
            case .dragging(let translation, let direction):
                return direction.translateRect(rect, translation: translation)
        }
    }
}

struct SelectionView: View {

    @Binding var selectionRect: CGRect

    var knobRadius: CGFloat = 10.0

    var body: some View {
        let rect = dragState.translateRect(selectionRect)

        return ZStack(alignment: .topLeading) {
            Rectangle()
                .stroke(Color.blue)
                .frame(width: rect.width, height: rect.height)

            ForEach(0..<Direction.allCases.count) { index in
                knobView(direction: Direction.allCases[index],
                         size: rect.size)
            }
        }
        .frame(width: rect.width, height: rect.height)
        .position(x: rect.midX, y: rect.midY)
        .animation(.linear(duration: minimumLongPressDuration))
    }

    @GestureState private var dragState = DragState.inactive

    #if os(macOS)
    private let minimumLongPressDuration = 0.01
    #else
    private let minimumLongPressDuration = 0.3
    #endif

    private func knobView(direction: Direction, size: CGSize) -> some View {
        let bounds = CGRect(origin: .zero, size: size)
        let rect = knobRect(direction: direction, in: bounds)

        let gesture = LongPressGesture(minimumDuration: minimumLongPressDuration)
            .sequenced(before: DragGesture())
            .updating($dragState) { value, state, transaction in
                switch value {
                    case .first(true):
                        state = .pressing

                    case .second(true, let drag):
                            state = .dragging(translation: drag?.translation ?? .zero,
                                              direction: direction)
                    default:
                        state = .inactive
                }
            }
            .onEnded { value in
                guard case .second(true, let drag?) = value else {
                    return
                }
                
                selectionRect = direction.translateRect(selectionRect,
                                                        translation: drag.translation)
            }

        return ZStack {
            Circle()
                .fill(Color.white)
            Circle()
                .stroke(Color.blue)
        }
        .frame(width: rect.width, height: rect.height)
        .position(x: rect.midX, y: rect.midY)
        .gesture(gesture)
    }

    private func knobRect(direction: Direction, in rect: CGRect) -> CGRect {

        let size = CGSize(width: knobRadius * 2.0, height: knobRadius * 2.0)
        let origin: CGPoint

        switch direction {
            case .top:
                origin = CGPoint(x: rect.midX - knobRadius, y: rect.minY - knobRadius)
            case .topLeft:
                origin = CGPoint(x: rect.minX - knobRadius, y: rect.minY - knobRadius)
            case .left:
                origin = CGPoint(x: rect.minX - knobRadius, y: rect.midY - knobRadius)
            case .bottomLeft:
                origin = CGPoint(x: rect.minX - knobRadius, y: rect.maxY - knobRadius)
            case .bottom:
                origin = CGPoint(x: rect.midX - knobRadius, y: rect.maxY - knobRadius)
            case .bottomRight:
                origin = CGPoint(x: rect.maxX - knobRadius, y: rect.maxY - knobRadius)
            case .right:
                origin = CGPoint(x: rect.maxX - knobRadius, y: rect.midY - knobRadius)
            case .topRight:
                origin = CGPoint(x: rect.maxX - knobRadius, y: rect.minY - knobRadius)
        }

        return CGRect(origin: origin, size: size)
    }
}

struct SelectionView_Previews: PreviewProvider {
    static var previews: some View {
        let rect = CGRect(x: 40.0, y: 40.0, width: 320.0, height: 480.0)
        return SelectionView(selectionRect: .constant(rect))
    }
}
