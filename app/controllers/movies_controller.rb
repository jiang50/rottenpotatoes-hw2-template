class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    if params[:ratings]
      session[:set_ratings] = params[:ratings]
    elsif !session[:set_ratings]   #first time
      session[:set_ratings] = Hash.new
      @all_ratings.each {|rating| session[:set_ratings][rating] = 1}
    end
    @set_ratings = session[:set_ratings]
    if params[:sort_by]
      session[:sort_by] = params[:sort_by] #update 
    end
    @sort_column = params[:sort_by]
    @movies = Movie.where({rating:  session[:set_ratings].keys }) #filter
    
    if session[:sort_by]
      @movies = @movies.order(session[:sort_by])
    end

    url_hash = {'ratings'=> session[:set_ratings], 'sort_by' => session[:sort_by]}
    if ( session[:set_ratings] != params[:ratings] || session[:sort_by] != params[:sort_by] )
      redirect_to(url_hash)
    end
    

    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
