$ ->
  $startGameBtn  = $ 'a[data-start-game]'
  $pauseGameBtn  = $ '#pause-game-btn'
  $resumeGameBtn = $ '#resume-game-btn'
  $endGameBtn    = $ '#end-game-button'
  $linkToSteps   = $ '#link-to-steps'

  # Game timer
  window.timer = {
    interval: null
    display: $('#display-timer')
    container: $('#container-timer')
    secondsRemain: 0
    redirectTo: $('#timeout-redirect-url').html()
    paused: false

    # Return remaning time in format MM:ss
    minSec: ->
      minutes = Math.floor(this.secondsRemain / 60)
      seconds = Math.round((this.secondsRemain % 60) / 1)
      "#{minutes.toString().padStart(2, '0')}:#{seconds.toString().padStart(2, '0')}"

    # Hide and stop timer.
    stop: ->
      this.container.hide()
      $startGameBtn.show()
      clearInterval this.interval

    show: ->
      $startGameBtn.hide()
      this.container.show()
      this.display.html this.minSec()

    # Show and start timer.
    start: (timeLength) ->
      @paused = false
      this.secondsRemain = timeLength if timeLength
      if this.secondsRemain > 0
        $resumeGameBtn.hide()
        $pauseGameBtn.show()
        this.show()
        _self = this
        this.interval = setInterval ->
          if _self.secondsRemain > 0
            _self.secondsRemain--
            _self.display.html _self.minSec()
          else
            _self.stop()
            $('#timeout-modal').modal 'show'
            setTimeout ->
              window.location = _self.redirectTo if _self.redirectTo
            , 3000
        , 1000

    pause: (pauseAt) ->
      @paused = true
      this.secondsRemain = pauseAt if pauseAt
      $pauseGameBtn.hide()
      $resumeGameBtn.show()
      $linkToSteps.hide()
      this.show()
      clearInterval this.interval
  }

  seconds = (stopAt) -> Math.ceil (new Date(stopAt) - new Date) / 1000

  # When timer started before the page loaded then continue conutdowning.
  if stopAt = timer.display.attr('data-stop-at')
    if pauseAt = timer.display.attr('data-paused-at')
      timer.pause(pauseAt)
    else
      timer.start seconds(stopAt)

  formMetadata = ->
    csrfToken = $('meta[name=csrf-token]').attr('content')
    csrfParam = $('meta[name=csrf-param]').attr('content')
    metadataInput = ''
    if csrfParam != undefined && csrfToken != undefined
      metadataInput += """<input name="#{csrfParam}" value="#{csrfToken}" type="hidden" />"""
    metadataInput

  startResume = (url) ->
    $linkToSteps.show()
    startAt = new Date
    metadataInput = """<input name="start_at" value="#{startAt}" type="hidden" />"""
    metadataInput += formMetadata()
    form = $ """<form method="post" action="#{url}"></form>"""
    form.hide().append(metadataInput).appendTo 'body'
    form.submit()

  # Starting game.
  $startGameBtn.click (event) ->
    event.preventDefault()
    startResume event.target.href

  # Pause game
  $pauseGameBtn.click (event) ->
    event.preventDefault()
    $resumeGameBtn.removeClass 'disabled'
    timer.pause()
    $.post event.target.href, { seconds_remain: timer.secondsRemain }

  # Resume game.
  $resumeGameBtn.click (event) ->
    event.preventDefault()
    startResume event.target.href

  # End the game
  $endGameBtn.click (event) ->
    event.preventDefault()
    # timer.stop()
    # $.post event.target.href
    $('#end-game-modal').modal()

  $('button[data-end-game]').click ->
    form = $ """<form method="post" action="#{@dataset.endGame}"></form>"""
    form.hide().append(formMetadata()).appendTo 'body'
    form.submit()
