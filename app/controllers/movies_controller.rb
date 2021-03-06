require 'byebug'
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
    if !params[:sort_by]  && session[:sort_by]
      #flash.keep
      redirect_to movies_path(sort_by: session[:sort_by], ratings: params[:ratings]) and return
    end
    if !params[:ratings]  && session[:ratings]
      #flash.keep
      redirect_to movies_path(ratings: session[:ratings], sort_by: params[:sort_by]) and return
    end
    @all_ratings = Movie.possible_ratings
    @movies = Movie.all
    @selected_sort = params[:sort_by]
    @selected_ratings = params[:ratings]


    if @selected_ratings
      @selected_ratings_array = @selected_ratings.keys
      @movies = @movies.where(:rating => @selected_ratings_array) 
    end

    if @selected_sort
      @movies = @movies.order(@selected_sort)
      @title_header = 'hilite' if @selected_sort == 'title'
      @release_date_header = 'hilite' if @selected_sort == 'release_date'
    end
    session[:sort_by] = params[:sort_by]
    session[:ratings] = params[:ratings]

  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    #@movie.title = movie_params[:title]
    #@movie.release_date = movie_params[:release_date]
    #@movie.rating = movie_params[:rating]
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
