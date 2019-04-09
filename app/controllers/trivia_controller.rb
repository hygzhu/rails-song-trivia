class TriviaController < ApplicationController
    autocomplete :song, :source_name, :full => true do |items|
        ActiveSupport::JSON.encode( items.uniq{ |i| i["value"] } )
    end
    
    def index
    end

    def new_simple_game
        @songs = Song.order(Arel.sql('random()')).limit(1)
        @current_song = @songs.first
    end

    def simple_submit
        @params = params
        @song = Song.find(params[:song_id])
    end
    

    def playlist_select
        #Get auto generated playlists
        @premade_playlists = User.find(1).playlists.paginate(page: params[:playlist_page], per_page: 6)

        #Get user created playlists
        @playlists = Playlist.where.not(user_id: 1).paginate(page: params[:playlist_page], per_page: 6)
    end

    def new_playlist_game

        if !params[:start].nil?
            #New game setup
            @playlist = Playlist.find(params[:playlist])

            if !@playlist.songs.any?
                flash[:danger] = "That playlist has no songs"
                redirect_to trivia_path
                return
            end

            @song_ids = @playlist.songs.shuffle.map(&:id)
            @song_id = @song_ids.pop
            @song_completed_ids = []
            @song_completed_ids << @song_id
            @song = Song.find(@song_id)
        else
            #Grab params from post and set them for new render
            @playlist = Playlist.find(params[:playlist_id])
            @song_ids = params[:song_ids].split(" ").map(&:to_i)
            @song_completed_ids = params[:song_completed_ids].split(" ").map(&:to_i)
            @song_id = @song_ids.pop
            @song_completed_ids << @song_id
            @song = Song.find(@song_id)
        end

    end

    def playlist_submit
        #Grab params from the post and set them for new render
        @playlist = Playlist.find(params[:playlist_id])
        @song_ids = params[:song_ids].split(" ").map(&:to_i)
        @song_completed_ids = params[:song_completed_ids].split(" ").map(&:to_i)
        @song_id = params[:song_id].to_i
        @song = Song.find(@song_id)
        @params = params
    end

private


end
