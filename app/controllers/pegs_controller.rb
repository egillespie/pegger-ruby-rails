class PegsController < ApplicationController
  before_filter :parse_request

  def update
    gameId = Integer(params[:gameId]) rescue nil
    pegId = Integer(params[:pegId]) rescue nil

    if !pegId
      render nothing: true, status: :bad_request
      return
    elsif pegId != @peg.pegId
      render nothing: true, status: :conflict
      return
    end
    
    begin
      game = Game.find_by_id gameId
    rescue => e
      render json: {:message => e.message}, status: :not_found
    end
    
    game.movePeg @peg
    game.save
    render nothing: true, status: :see_other, location: games_url(gameId: gameId)
  rescue
    render json: {:message => e.message}, status: :unprocessable_entity
  end
  
private

  def parse_request
    request_body = request.body.read
    if request_body.blank?
      @peg = nil
    else
      json = JSON.parse request_body, object_class: OpenStruct
      @peg = Peg.new(json.pegId, json.type, Position.new(json.position.row, json.position.column))
    end
  end

end
