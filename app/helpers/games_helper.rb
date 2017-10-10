module GamesHelper
  def display_timer
    # This need for finishing expired game.
    current_user && current_user.user_games.running.map { |e| e }
    # True if there is running game.
    @running = current_user && current_user.user_games.running.any?
    # If the game running or paused read UserGame.
    user_game = current_user && current_user.user_games.find_by(game_id: @game.id, finished_at: nil)
    show_timer = !user_game.nil?
    if show_timer
      # Time when the game should stop.
      stop_at = (user_game.started_at + user_game.game.time_length.minutes).httpdate
      @paused_at = user_game.paused_at
    end

    content_tag :div, id: 'container-timer', style: "#{show_timer ? '' : 'display:none'}" do
      html = content_tag :h2, '', id: 'display-timer', class: 'text-danger',
        data: {stop_at: "#{stop_at}", paused_at: "#{@paused_at}"}

      if @display_pause_buttons
        html += link_to 'Pause game', game_pause_url(@game), id: 'pause-game-btn',
          class: 'btn btn-primary', style: "#{@paused_at ? 'display:none' : ''}"

        html += link_to 'Resume game', game_resume_url(@game), id: 'resume-game-btn',
          class: "btn btn-primary #{@running ? 'disabled' : ''}",
          style: "#{@paused_at ? '' : 'display:none'}"
      end
      html
    end
  end
end
