$ ->
  list = $('#games-user-list')
  difficultyParam = $('#difficulty_filter')
  ageParam = $('#age_filter')

  # Get filtered table of games.
  getTable = ->
    list.load '/games/games', { filter: {
        difficulty: difficultyParam[0].value
        age_range: ageParam[0].value
      }}

  # On change difficulty filter.
  difficultyParam.change getTable

  # On change age filter.
  ageParam.change getTable
