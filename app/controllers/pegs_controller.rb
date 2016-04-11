class PegsController < ApplicationController
  before_filter :parse_request

  def update
    game_id = Integer(params[:game_id]) rescue nil
    peg_id = Integer(params[:id]) rescue nil

    if !peg_id
      render nothing: true, status: :bad_request
      return
    elsif peg_id != @peg.pegId
      render nothing: true, status: :conflict
      return
    end
    
    begin
      game = Game.find_by_id game_id
    rescue => e
      render json: {:message => e.message}, status: :not_found
    end
    
    game.movePeg @peg
    game.save
    render nothing: true, status: :see_other, location: game_url(id: game_id)
  rescue => e
    render json: {:message => e.message}, status: :unprocessable_entity
  end
  
private

  def parse_request
    request_body = request.body.read
    if request_body.blank?
      @peg = nil
    else
      json = JSON.parse request_body, object_class: OpenStruct
      @peg = Peg.new(json.pegId, json.type.to_sym, Position.new(json.position.row, json.position.column))
    end
  end

end
