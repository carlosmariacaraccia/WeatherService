import UIKit

class NQueens:CustomStringConvertible {
    
    var description: String {
         ""
    }
    
    
    private var numberOfQueens:Int
    private var chessboard = [[Int]]()
    
    init(numberOfQueens:Int) {
        self.numberOfQueens = numberOfQueens
        
        // Initialize the number of rows and columns to 0
        for i in 0..<numberOfQueens {
            for j in 0..<numberOfQueens {
                self.chessboard[i][j] = 0
            }
        }
    }
    
    func solveNQueens() {
        if solve(0) {
            print(description)
        } else {
            print(description)
        }
    }
    
    func solve(_ columnIndex:Int) -> Bool {
        
        // Base case. When the problem is solved then the number of queens will match the number of columns, I'd successfully have placed one queen in each column.
        
        if columnIndex == numberOfQueens {
            return true
        }
        
        // now I have to check if I can place the queen in the chessboard
        for rowIndex in 0..<numberOfQueens {
            // we have to check if the queens are not attaching to each other.
            if isNotAttacked(rowIndex, columnIndex) {
                // we will place a one on the board instead of a 0
                chessboard[rowIndex][columnIndex] = 1
                
                // the we recurse and call the same function again
                if solve(columnIndex + 1) {
                    return true
                }
                // otherwise we should backtrack and turn the position of the queen to 0
                chessboard[rowIndex][columnIndex] = 0
            }
        }
        return false
    }
    
    private func isNotAttacked(_ rowIndex:Int, _ columnIndex:Int) -> Bool {
        
        // check if there are any queens on the same x axis
        for colIdx in 0..<columnIndex {
            if chessboard[rowIndex][colIdx] == 1 {
                return false
            }
        }
        
        // there are not supposed to be any queens in the vertical axis sice I'm placing only one. I will continue to the diagonal axis.
        var rowIdx = rowIndex
        var colIdx = columnIndex
        
        // check from position to the end (diagonally down)
        while (rowIdx < numberOfQueens && colIdx < numberOfQueens) {
            if chessboard[rowIdx][colIdx] == 1 {
                return false
            }
            rowIdx += 1
            colIdx += 1
        }
        
        while (rowIdx < )
        
    }
}
