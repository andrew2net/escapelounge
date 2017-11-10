$ ->
  gameSteps = $ '#game_steps'

  # Expand new game step.
  gameSteps.on('cocoon:after-insert', (e, item)->
    new_step = $(item).find('.collapse')
    if new_step.length
      $('.collapse').collapse("hide")
      new_step.collapse('show')
  )

  gameSteps.on('hidden.bs.collapse', '.collapse', (e, item)->
    $("a[href='##{e.target.id}']").find('.fa-caret-up').removeClass('fa-caret-up').addClass('fa-caret-down')
  )

  # Resolve issue with Bootstrap 4 accordeon collapse.
  gameSteps.on('show.bs.collapse', '.collapse', (e)->
    $('.collapse').collapse("hide")
    $("a[href='##{e.target.id}']").find('.fa-caret-down').removeClass('fa-caret-down').addClass('fa-caret-up')
  )
