class GamesController < JsonController
  def create
    render nothing: true, status: :created
  end

  def show
    render nothing: true, status: :ok
  end
end
