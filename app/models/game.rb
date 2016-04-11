require 'position'
require 'peg'

class Game
  @@games = []

  COLUMNS=4
  ROWS=2

  class << self
    def start gameId
      new gameId, nil, [
        Peg.new(1, :red, Position.new(1, 1)),
        Peg.new(2, :red, Position.new(2, 4)),
        Peg.new(3, :green, Position.new(1, 4)),
        Peg.new(4, :green, Position.new(2, 1)),
        Peg.new(5, :yellow, Position.new(1, 2)),
        Peg.new(6, :yellow, Position.new(2, 3))
      ]
    end
    
    def next_id
      return @@games.length
    end

    def find_by_id gameId
      # Call Game.find_by(gameId: gameId) when attached to database
      game = @@games[gameId]
      if !game
        raise "Game ID #{gameId} does not exist."
      end
      return game
    end

    private :new
  end

  def initialize gameId, lastPegMoved, pegs
    @gameId = gameId
    @lastPegMoved = lastPegMoved
    @pegs = pegs
    calculate_game_over
  end
  
  attr_reader :gameId, :lastPegMoved, :pegs, :gameOver
  
  def getPeg pegId
    @pegs.each do |peg|
      if peg.pegId == pegId
        return peg
      end
    end
    return nil
  end
  
  def movePeg peg
    validate_move peg
    @pegs.each_with_index do |oldPeg, index|
      if oldPeg.pegId == peg.pegId
        @lastPegMoved = oldPeg
        @pegs[index] = peg
        calculate_game_over
        return
      end
    end
  end

  # Remove when attached to database
  def save
    @@games[@gameId] = self
  end

private

  def calculate_game_over
    pegs.each do |peg|
      if !peg.neutral?
        pegs.each do |testPeg|
          if peg.pegId != testPeg.pegId && peg.type == testPeg.type && peg.position.adjacent_to?(testPeg.position)
            @gameOver = true
            return
          end
        end
      end
    end
    @gameOver = false
  end

  def validate_move pegWithNewPosition
    if @gameOver
      raise 'The game is over. No additional pegs may be moved.'
    end
    
    pegWithOldPosition = getPeg pegWithNewPosition.pegId
    
    if pegWithOldPosition.type != pegWithNewPosition.type
      raise 'The peg type cannot be changed.'
    end
    
    fromPosition = pegWithOldPosition.position
    toPosition = pegWithNewPosition.position

    if toPosition.column < 1 || toPosition.column > COLUMNS
      raise 'The peg cannot be moved to that column.'
    elsif toPosition.row < 1 || toPosition.row > ROWS
      raise 'The peg cannot be moved to that row.'
    elsif toPosition == fromPosition
      raise 'The peg must be moved.'
    elsif toPosition.column != fromPosition.column && toPosition.row != fromPosition.row
      raise 'The peg cannot be moved diagonally.'
    elsif (toPosition.column - fromPosition.column).abs > 2
      raise 'That location is too far away.'
    elsif (toPosition.column - fromPosition.column).abs == 2
      foundMiddlePeg = false
      middleColumn = (toPosition.column + fromPosition.column) / 2
      @pegs.each do |peg|
        position = peg.position
        if position.row == toPosition.row && position.column == middleColumn
          foundMiddlePeg = true
          break
        end
      end
      if !foundMiddlePeg
        raise 'The peg cannot jump an empty space.'
      end
    end

    @pegs.each do |peg|
      if toPosition == peg.position
        raise 'Another peg is in that position.'
      end
    end

    if @lastPegMoved && @lastPegMoved.pegId === pegWithNewPosition.pegId && @lastPegMoved.position == toPosition
      raise 'This peg cannot be returned to its previous location.'
    end
  end
end
