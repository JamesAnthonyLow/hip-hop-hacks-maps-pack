class MapsController < ApplicationController
  include LocationsParser
  include Songable
  GEOCODE_URI = "https://maps.googleapis.com/maps/api/geocode/json"

  def index
    @api_key = API_KEY
  end

  def create_query
    query = params[:"song-query"]
    @query_results = list_query_results(query)
    render 'index'
  end

  def create ##change this and the link that posts to it in /app/views/songs/index.html.erb
    lyrics = get_lyrics_from_link(params[:url])
    @locations = get_locations_from_lyrics(lyrics)
    # @locations = "New York"
    ##if request.xhr?
    ##  response = HTTParty.get(GEOCODE_URI, {query: {address: params[:query], key: ENV["GOOGLE_MAPS_API_KEY"]}})
    ##  marker_positions = get_array_of_positions_from_response response
    ##  render json: {
    ##    marker_positions: marker_positions
    ##  }
    ##end
    render json: {
      marker_positions: @locations 
    }
  end

  private

  def get_array_of_positions_from_response response
    response["results"].map do |result|
      result["geometry"]["location"]
    end
  end
end
