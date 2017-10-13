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
