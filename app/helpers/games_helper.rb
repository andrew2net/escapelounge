module GamesHelper

  # Render timer. If inline is true then render timer in inline format.
  def display_timer(inline: false)
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

    elem_class = inline ? "col-md-2" : "col-md-12"

    content_tag :div, id: "container-timer", style: "#{show_timer ? "" : "display:none"}" do
      content_tag :div, class: "row" do
        html = content_tag :div, class: elem_class do
          content_tag :h2, '', id: "display-timer", class: "text-danger",
            data: { stop_at: "#{stop_at}", paused_at: "#{@paused_at}" }
        end

        if @display_pause_buttons
          html += content_tag :div, class: elem_class do
            link_to 'Pause game', game_pause_url(@game), id: 'pause-game-btn',
              class: 'btn btn-primary mb-1', style: "#{@paused_at ? 'display:none' : ''}"
          end

          html += content_tag :div, class: elem_class do
            link_to 'Resume game', game_resume_url(@game), id: 'resume-game-btn',
              class: "btn btn-primary mb-1 #{@running ? 'disabled' : ''}",
              style: "#{@paused_at ? '' : 'display:none'}"
          end
        else
          html += content_tag :div, class: elem_class do
            link_to "Game description", game_path(@game)
          end
        end

        if user_game
          html += content_tag :div, class: elem_class do
            link_to 'End game', user_game_end_url(user_game), id: 'end-game-button',
              class: "btn btn-primary", style: "#{@running || @paused_at ? '' : 'display:none'}"
          end
        end
        html
      end
    end
  end
end
