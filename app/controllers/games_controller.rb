class GamesController < ApplicationController
  def create
    game = start_game
    render json: game, status: :created, location: game_url(id: game.gameId)
  rescue => e
    render json: {:message => e.message}, status: :internal_server_error
  end

  def show
    game = Game.find_by_id params[:id].to_i
    render json: game, status: :ok
  rescue => e
    render json: {:message => e.message}, status: :not_found
  end
  
private

  def start_game
    game = Game.start Game.next_id
    game.save
    return game
  end

end
