require 'position'
require 'peg'

class Game
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

    def directed(data)
      new(data,true)
    end

    private :new
  end

  def initialize gameId, lastPegMoved, pegs
    @gameId = gameId
    @lastPegMoved = lastPegMoved
    @pegs = pegs
    calculate_game_over
  end
  
  def gameId
    @gameId
  end
  
  def lastPegMoved
    @lastPegMoved
  end
  
  def pegs
    @pegs
  end

  def gameOver
    @gameOver
  end
  
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
