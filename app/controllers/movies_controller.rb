class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  def index
     @movies = Movie.all
     @all_ratings = Movie.ratings
     @checkbox_rating_selections = []
     if !params[:ratings].nil? 
     @checkbox_rating_selections = params[:ratings].keys
     @movies = Movie.where(:rating =>@checkbox_rating_selections) # filter based on rating selections    
     session[:rating_selections] = @checkbox_rating_selections # remember rating selections 
     end
     @checked_values = session[:rating_selections]
     if !session[:rating_selections].nil?
     @movies = Movie.where(:rating=>@checked_values)
     end
     #added below for hw2-part1. sorting and filtering
     if params.has_key? :title_header
     session[:title_header] = params[:title_header]
     session[:title_release_date] = nil
     @movies = Movie.where(:rating=>@checked_values).order(params[:title_header])
     @css_title_header_class = 'hilite'
     elsif params.has_key? :title_release_date
     session[:title_release_date] = params[:title_release_date]
     session[:title_header] = nil
     @css_release_date_header_class = 'hilite'
     @movies = Movie.where(:rating=>@checked_values).order(params[:title_release_date])
     end  
     if !session[:title_header].nil? == true && params[:title_release_date].nil? == true  
     @movies = Movie.where(:rating=>@checked_values).order(session[:title_header])
     @css_title_header_class = 'hilite'
     end
     if !session[:title_release_date].nil? == true && params[:title_header].nil? == true
     @movies = Movie.where(:rating=>@checked_values).order(session[:title_release_date])
     @css_release_date_header_class = 'hilite'
     end
 end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
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
