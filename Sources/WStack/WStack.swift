import SwiftUI

public struct WStack<Content>: View where Content: View {
    let data: [any Hashable]
    var alignment: HorizontalAlignment = .leading
    var spacing: CGFloat = 8
    var lineSpacing: CGFloat = 8
    var lineLimit: Int?
    @ViewBuilder var content: (any Hashable) -> Content

    @State private var framesOfIndecies: [Int: CGRect] = [:]
    @State private var frame: CGRect = CGRect()

    public init(
        _ data: [any Hashable],
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 8,
        lineSpacing: CGFloat = 8,
        lineLimit: Int? = nil,
        content: @escaping (any Hashable) -> Content
    ) {
        self.data = data
        self.alignment = alignment
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.lineLimit = lineLimit
        self.content = content
    }

    public var body: some View {
        VStack(alignment: alignment, spacing: lineSpacing) {
            reader
            wrappingHStack
        }
    }

    private var reader: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(0..<data.count, id: \.self) { i in
                    content(data[i])
                        .overlay(
                            GeometryReader { proxy in
                                Color.clear.onAppear {
                                    framesOfIndecies[i] = proxy.frame(in: .global)
                                }
                            }
                        )
                }
            }
            .opacity(0)
            .onAppear {
                frame = proxy.frame(in: .global)
            }
        }
        .frame(height: 0)
    }

    private var wrappingHStack: some View {
        ForEach(matrix(), id: \.self) { items in
            HStack(spacing: spacing) {
                ForEach(items, id: \.self) { i in
                    content(data[i])
                }
            }
        }
    }

    private func matrix() -> [[Int]] {
        var result: [[Int]] = []

        var currentRow: [Int] = []
        var currentWidth: CGFloat = 0

        for i in 0..<data.count {
            if let lineLimit = lineLimit, lineLimit == result.count {
                lineLimitHandler(&result)
                return result
            }

            guard let width = framesOfIndecies[i]?.width else { continue }
            if currentWidth + width + spacing <= frame.width {
                currentWidth += width + spacing
                currentRow.append(i)
            } else {
                result.append(currentRow)
                currentRow = [i]
                currentWidth = width
            }
        }

        if let lineLimit = lineLimit, lineLimit == result.count {
            lineLimitHandler(&result)
            return result
        }
        result.append(currentRow)
        return result
    }

    private func lineLimitHandler(_ matrix: inout [[Int]]) {
        guard var lastRow = matrix.last else { return }
        var lastWidth = lastRow.reduce(0) { currentWidth, i in
            guard let frame = framesOfIndecies[i] else { return currentWidth }
            return currentWidth + frame.width
        }

        guard let lastItemWidth = framesOfIndecies[data.count - 1]?.width else { return }
        while lastWidth + lastItemWidth + spacing > frame.width {
            guard
                let i = lastRow.popLast(),
                let frame = framesOfIndecies[i]
            else { return }
            lastWidth -= (frame.width + spacing)
        }

        lastRow.append(data.count - 1)
        matrix[matrix.endIndex - 1] = lastRow
    }
}
