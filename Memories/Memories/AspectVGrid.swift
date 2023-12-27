//
//  AspectVGrid.swift
//  Memories
//
//  Created by Gideon Boateng on 11/19/23.
//

import SwiftUI


// MARK: - AspectVGrid View

/// A view that displays items in a grid with an adaptive aspect ratio.
/// - Parameters:
///   - items: An array of items to be displayed in the grid.
///   - aspectRatio: The desired aspect ratio of each grid item.
///   - content: A closure that produces the content of each grid item.
struct AspectVGrid<Item, ItemView>: View where ItemView: View, Item: Identifiable {
    
    // MARK: - Properties
    
    /// An array of items to be displayed in the grid.
    var items: [Item]
    
    /// The desired aspect ratio of each grid item.
    var aspectRatio: CGFloat
    
    /// A closure that produces the content of each grid item.
    var content: (Item) -> ItemView
    
    // MARK: - Initialization
    
    /// Initializes the AspectVGrid with items, aspect ratio, and content closure.
    /// - Parameters:
    ///   - items: An array of items to be displayed in the grid.
    ///   - aspectRatio: The desired aspect ratio of each grid item.
    ///   - content: A closure that produces the content of each grid item.
    init(items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    // MARK: - Body
    
    /// The body of the AspectVGrid, defining its structure and layout.
    var body: some View {
        GeometryReader { geometry in
            VStack {
                let width: CGFloat = widthThatFits(itemCount: items.count, in: geometry.size, itemAspectRatio: aspectRatio)
                LazyVGrid(columns: [adaptiveGridItem(width: width)], spacing: 0) {
                    ForEach(items) { item in
                        content(item).aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                Spacer(minLength: 0)
            }
        }
    }
    
    // MARK: - Private Methods
    
    /// Creates an adaptive grid item with the specified width.
    /// - Parameter width: The width of the grid item.
    /// - Returns: An adaptive GridItem.
    private func adaptiveGridItem(width: CGFloat) -> GridItem {
        var gridItem = GridItem(.adaptive(minimum: width))
        gridItem.spacing = 0
        return gridItem
    }
    
    /// Calculates the width that fits the items in the given size with the specified aspect ratio.
    /// - Parameters:
    ///   - itemCount: The total number of items.
    ///   - size: The size in which the grid is displayed.
    ///   - itemAspectRatio: The desired aspect ratio of each grid item.
    /// - Returns: The width that fits the items in the grid.
    private func widthThatFits(itemCount: Int, in size: CGSize, itemAspectRatio: CGFloat) -> CGFloat {
        var columnCount = 1
        var rowCount = itemCount
        
        repeat {
            let itemWidth = size.width / CGFloat(columnCount)
            let itemHeight = itemWidth / itemAspectRatio
            
            if CGFloat(rowCount) * itemHeight < size.height {
                break
            }
            
            columnCount += 1
            rowCount = (itemCount + (columnCount - 1)) / columnCount
            
        } while columnCount < itemCount
        
        if columnCount > itemCount {
            columnCount = itemCount
        }
        
        return floor(size.width / CGFloat(columnCount))
    }
}
