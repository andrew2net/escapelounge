$ ->
  $list            = $ '#games-user-list'
  $difficultyParam = $ '#difficulty_filter'
  $ageParam        = $ '#age_filter'
  $allowedFilter   = $ '#allowed_filter'

  # Get filtered table of games.
  getTable = ->
    $list.load '/games/games', {
      filter: {
        difficulty: $difficultyParam.val()
        grade_id: $ageParam.val()
      }
      allowed_filter: $allowedFilter.prop 'checked'
    }

  # On change difficulty filter.
  $difficultyParam.change getTable

  # On change age filter.
  $ageParam.change getTable

  # On change allowed filter
  $allowedFilter.change getTable

  $('#reset-filter').click (e) ->
    e.preventDefault()
    $difficultyParam.val null
    $ageParam.val null
    getTable()

  $('#not_show_popup').change ->
    $.post '/games/set_popup_not_show', { value: @value }