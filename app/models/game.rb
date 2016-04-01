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
end
