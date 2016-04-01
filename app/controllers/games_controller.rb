class GamesController < JsonController
  def create
    game = start_game
    render json: game, status: :created, location: games_url(gameId: game.gameId)
  rescue => e
    render json: {:message => e.message}, status: :internal_server_error
  end

  def show
    render nothing: true, status: :ok
  end
  
private

  def start_game
    game = Game.start Game.next_id
    game.save
    return game
  end

end
