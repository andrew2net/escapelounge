$ ->
  gameSteps = $ '#game_steps'

  setPositions = ->
    $('#sortable > .nested-fields').each (i, step)->
      $(step).find('input[hidden]').val i + 1

  setPositions()

  # Set id for new step
  gameSteps.on('cocoon:before-insert', (e, item)->
    newStep = $(item).find('.collapse')
    if newStep
      # find previous steps and aincrement id if found, if not set id to 1
      steps = gameSteps.find('.collapse')
      id = if steps.length
        parseInt(steps.last().attr('id').match(/\d+$/)[0]) + 1
      else
        1
      stepId = 'collapse-' + id
      newStep.attr('id', stepId)
      newStep.parent().find('a[data-toggle="collapse"]').attr('href', '#' + stepId)
      header = newStep.prev().attr('id', 'header-' + id)
  )

  # Expand new game step.
  gameSteps.on('cocoon:after-insert', (e, item)->
    newStep = $(item).find('.collapse')
    if newStep.length
      $('.collapse').collapse("hide")
      newStep.collapse('show')
  )

  # Change caret class.
  gameSteps.on('hidden.bs.collapse', '.collapse', (e)->
    $(this).parent().find('.fa-caret-up').removeClass('fa-caret-up').addClass('fa-caret-down')
  )

  # Resolve issue with Bootstrap 4 accordeon collapse and change caret class.
  gameSteps.on('show.bs.collapse', '.collapse', (e)->
    $('.collapse').collapse("hide")
    $(this).parent().find('.fa-caret-down').removeClass('fa-caret-down').addClass('fa-caret-up')
  )

  $('#sortable').sortable({
    handle: '.sortable-handle'
    stop: (e, ui)-> setPositions()
  })
  gameSteps.on('click', '.sortable-handle', (e)-> e.preventDefault())
  # gameSteps.on('mouseenter', '.sortable-handle', (e)-> $('.collapse').collapse('hide'))
