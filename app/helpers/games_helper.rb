# frozen_string_literal: true

# User game helper
module GamesHelper
  # Render timer. If inline is true then render timer in inline format.
  def display_timer(bar: false)
    # This need for finishing expired game.
    current_user && current_user.user_games.running.map { |e| e }
    # True if there is running game.
    @running = current_user && current_user.user_games.running.any?
    # If the game running or paused read UserGame.
    user_game = current_user&.user_games&.find_by(game_id: @game.id,
                                                  finished_at: nil)
    show_timer = !user_game.nil?
    if show_timer
      # Time when the game should stop.
      stop_at = (user_game.started_at + user_game.game.time_length.minutes).httpdate
      @paused_at = user_game.paused_at
    end

    # elem_class = 'col-md-12' # inline ? "col-md-2" : "col-md-12"

    content_tag(:span, id: 'container-timer',
                       style: show_timer ? '' : 'display:none') do
      html = content_tag(
        :span, '', id: 'display-timer', style: bar ? '' : 'display:none',
                   data: { stop_at: stop_at, paused_at: @paused_at }
      )

      return html if bar

      if @display_pause_buttons
        html += link_to 'Pause game', game_pause_url(@game), id: 'pause-game-btn',
          class: 'btn btn-primary btn-sm ml-1', style: "#{@paused_at ? 'display:none' : ''}"

        html += link_to 'Resume game', game_resume_url(@game), id: 'resume-game-btn',
            class: "btn btn-primary btn-sm ml-1 #{@running ? 'disabled' : ''}",
            style: "#{@paused_at ? '' : 'display:none'}"
      else
        html += link_to "Game description", game_path(@game)
      end

      if user_game
        html += link_to 'End game', user_game_end_url(user_game), id: 'end-game-button',
          class: "btn btn-primary btn-sm ml-1", style: "#{@running || @paused_at ? '' : 'display:none'}"
      end
      html.html_safe
    end
  end
end
