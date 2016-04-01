class Position
  def initialize row, column
    @row = row
    @column = column
  end
  
  attr_reader :row, :column
  
  def adjacent_to? position
    if @row == position.row
      return @column == position.column - 1 || @column == position.column + 1
    elsif @column == position.column
      return @row == position.row - 1 || @row == position.row + 1
    end
    
    return false
  end
end
