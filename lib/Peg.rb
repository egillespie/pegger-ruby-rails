class Peg
  def initialize pegId, type, position
    @pegId = pegId
    @type = type
    @position = position
  end
  
  def pegId
    @pegId
  end
  
  def type
    @type
  end
  
  def position
    @position
  end
  
  def neutral?
    return @type != :red && @type != :green
  end
end
