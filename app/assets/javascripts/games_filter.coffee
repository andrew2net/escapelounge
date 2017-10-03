$ ->
  table = $('table.table tbody')
  difficulty_param = $('#difficulty_filter')
  age_param = $('#age_filter')

  get_table = ->
    table.load '/games/table', { filter: {
        difficulty: difficulty_param[0].value
        age_range: age_param[0].value
      }}
    return

  difficulty_param.change get_table

  age_param.change get_table
