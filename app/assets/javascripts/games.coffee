$ ->
  table = $('table.table tbody')
  difficultyParam = $('#difficulty_filter')
  ageParam = $('#age_filter')

  # Get filtered table of games.
  getTable = ->
    table.load '/games/table', { filter: {
        difficulty: difficultyParam[0].value
        age_range: ageParam[0].value
      }}

  difficultyParam.change getTable

  ageParam.change getTable

  startGameBtn = $('#start-game-btn')
  timer = $('#timer')

  # Return remaning time in format MM:ss
  minSec = (stopAt)->
    timeDiff = Math.ceil (stopAt - new Date) / 1000
    minutes = Math.floor(timeDiff / 60)
    seconds = Math.round((timeDiff % 60) / 1)
    "#{minutes.toString().padStart(2, '0')}:#{seconds.toString().padStart(2, '0')}"

  timerInterval = null
  stopTimer = ->
    timer.hide()
    startGameBtn.show()
    clearInterval timerInterval

  # Show timer.
  startTimer = (stopAt)->
    stopAt = new Date stopAt
    startGameBtn.hide()
    timer.show()
    timer.html minSec stopAt
    timerInterval = setInterval ->
      if new Date > stopAt
        stopTimer()
      else
        timer.html minSec stopAt
    , 1000

  if stopAt = timer.attr('data-stop-at')
    startTimer stopAt

  # Starting game.
  startGameBtn.click (event)->
    event.preventDefault()
    startAt = new Date
    timeZoneOffset = startAt.getTimezoneOffset()
    $.post "#{window.location}/start", {
      start_at: startAt
      timezone_offset: timeZoneOffset
    }, (response)->
      if response.stop_at
        startTimer response.stop_at
