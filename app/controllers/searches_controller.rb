class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    @range = params[:range]
    @word = params[:word]
    @method = params[:method]

    if @range == "User"
      @searches = User.search_for(@method, @word)
    else
      @searches = Book.search_for(@method, @word)
    end
  end
end