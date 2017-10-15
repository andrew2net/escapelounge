$ ->
  startGameBtn = $('#start-game-btn')
  pauseGameBtn = $('#pause-game-btn')
  resumeGameBtn = $('#resume-game-btn')

  window.timer =
    interval: null
    display: $('#display-timer')
    container: $('#container-timer')
    secondsRemain: 0
    redirectTo: $('#timeout-redirect-url').html()

    # Return remaning time in format MM:ss
    minSec: ->
      minutes = Math.floor(this.secondsRemain / 60)
      seconds = Math.round((this.secondsRemain % 60) / 1)
      "#{minutes.toString().padStart(2, '0')}:#{seconds.toString().padStart(2, '0')}"

    # Hide and stop timer.
    stop: ->
      this.container.hide()
      startGameBtn.show()
      clearInterval this.interval
      window.location = this.redirectTo if this.redirectTo

    show: ->
      startGameBtn.hide()
      this.container.show()
      this.display.html this.minSec()

    # Show and start timer.
    start: (timeLength)->
      this.secondsRemain = timeLength if timeLength
      if this.secondsRemain > 0
        resumeGameBtn.hide()
        pauseGameBtn.show()
        this.show()
        _self = this
        this.interval = setInterval ->
          if _self.secondsRemain > 0
            _self.secondsRemain--
            _self.display.html _self.minSec()
          else
            _self.stop()
        , 1000

    pause: (pauseAt)->
      this.secondsRemain = pauseAt if pauseAt
      pauseGameBtn.hide()
      resumeGameBtn.show()
      this.show()
      clearInterval this.interval

  seconds = (stopAt)-> Math.ceil (new Date(stopAt) - new Date) / 1000

  # When timer started before the page loaded then continue conutdowning.
  if stopAt = timer.display.attr('data-stop-at')
    if pauseAt = timer.display.attr('data-paused-at')
      timer.pause(pauseAt)
    else
      timer.start seconds(stopAt)

  # Starting game.
  startGameBtn.click (event)->
    # event.preventDefault()
    startAt = encodeURIComponent new Date
    event.target.href += "?start_at=#{startAt}"
    # timeZoneOffset = startAt.getTimezoneOffset()
    # $.post event.target.href, {
      # start_at: startAt
      # timezone_offset: timeZoneOffset
    # }, (response)->
    #   if response.stop_at
    #     timer.start seconds(response.stop_at)

  # Pause game
  pauseGameBtn.click (event)->
    event.preventDefault()
    resumeGameBtn.removeClass 'disabled'
    timer.pause()
    $.post event.target.href, { seconds_remain: timer.secondsRemain }

  # Resume game.
  resumeGameBtn.click (event)->
    event.preventDefault()
    timer.start()
    $.post event.target.href, { start_at: new Date }