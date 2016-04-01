class Peg
  def initialize pegId, type, position
    @pegId = pegId
    @type = type
    @position = position
  end
  
  attr_reader :pegId, :type, :position
  
  def neutral?
    return @type != :red && @type != :green
  end
end
