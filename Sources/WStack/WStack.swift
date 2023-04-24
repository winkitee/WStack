import SwiftUI

public struct WStack<Data, Content>: View where Data: RandomAccessCollection, Content: View {
    public var data: Data
    var alignment: HorizontalAlignment
    var spacing: CGFloat
    var lineSpacing: CGFloat
    var lineLimit: Int?
    var isHiddenLastItem: Bool
    @ViewBuilder var content: (Data.Element) -> Content

    @State private var framesOfIndecies: [Int: CGRect] = [:]
    @State private var frame: CGRect = CGRect()

    public init(
        _ data: Data,
        alignment: HorizontalAlignment = .leading,
        spacing: CGFloat = 8,
        lineSpacing: CGFloat = 8,
        lineLimit: Int? = nil,
        isHiddenLastItem: Bool = false,
        content: @escaping (Data.Element) -> Content
    ) {
        self.data = data
        self.alignment = alignment
        self.spacing = spacing
        self.lineSpacing = lineSpacing
        self.lineLimit = lineLimit
        self.isHiddenLastItem = isHiddenLastItem
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
                    content(data[i as! Data.Index])
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
                    content(data[i as! Data.Index])
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
            if i == data.count - 1 && isHiddenLastItem {
                if currentWidth + width + spacing > frame.width {
                    result.append(currentRow)
                    currentRow = [i]
                    currentWidth = width
                }
                break
            }

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

        if currentRow.count == 1 && currentRow.last == data.count - 1 && isHiddenLastItem {
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

        if count(matrix: matrix) < data.count - 1 {
            lastRow.append(data.count - 1)
            matrix[matrix.endIndex - 1] = lastRow
        }

        if lastRow.count == 1 && lastRow.last == data.count - 1 {
            _ = matrix.popLast()
        }
    }

    private func count(matrix: [[Int]]) -> Int {
        var sum = 0
        for array in matrix {
            for _ in array {
                sum += 1
            }
        }
        return sum
    }
}
