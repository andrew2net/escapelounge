$ ->
  gameSteps = $ '#game_steps'

  setPositions = ->
    $('#sortable > .nested-fields').each (i, step) ->
      $(step).children('input[hidden]').val i + 1
    $('.sortable-solutions').each (i, solutions) ->
      $(solutions).children('.nested-fields').each (n, solution) ->
        $(solution).children('input[hidden]').val n + 1


  setPositions()

  # Set id for new step
  gameSteps.on('cocoon:before-insert', (e, item) ->
    newStep = $(item).find('.collapse')
    if newStep
      # find previous steps and increment id if found, if not set id to 1
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
  gameSteps.on('cocoon:after-insert', (e, item) ->
    setPositions()
    newStep = $(item).find('.collapse')
    if newStep.length
      $('.collapse').collapse("hide")
      newStep.collapse('show')
  )

  # Change caret class.
  gameSteps.on('hidden.bs.collapse', '.collapse', (e) ->
    $(this).parent().find('.fa-caret-up').removeClass('fa-caret-up').addClass('fa-caret-down')
  )

  # Resolve issue with Bootstrap 4 accordeon collapse and change caret class.
  gameSteps.on('show.bs.collapse', '.collapse', (e) ->
    $('.collapse').collapse("hide")
    $(this).parent().find('.fa-caret-down').removeClass('fa-caret-down').addClass('fa-caret-up')
  )

  $('#sortable').sortable({
    handle: '.sortable-handle'
    start: (e, ui) ->
      instance = CKEDITOR.instances[ui.item.find('.ckeditor').attr('id')]
      CKEDITOR.remove instance if instance
    stop: (e, ui) ->
      CKEDITOR.replace ui.item.find('.ckeditor').attr('id')
      setPositions()
  })
  gameSteps.on('click', '.sortable-handle', (e) -> e.preventDefault())
  # gameSteps.on('mouseenter', '.sortable-handle', (e)-> $('.collapse').collapse('hide'))

  $('.sortable-solutions').sortable {
    handle: '.sortable-handle'
    stop: (e, ui) -> setPositions()
  }

  # Show/hide solutions/image options depend on answer input type.
  showHideSolutions = ($select) ->
    $parent = $select.closest('.card-body')
    if $select.val() == 'image_options'
      $parent.find('.solutions').hide()
      $parent.find('.image-options').show()
    else
      $parent.find('.solutions').show()
      $parent.find('.image-options').hide()
    
      if $select.val() == 'multi_questions'
        $parent.find('div[data-question]').show().find('input').attr('required', true)
      else
        $parent.find('div[data-question]').hide().find('input').attr('required', false)

  $(document).on 'cocoon:after-insert', '.solutions', ->
    showHideSolutions $(@).closest('div[data-game-step]').find 'select[data-input-type]'

  # Change answer input type.
  $(document).on 'change', 'select[data-input-type]', -> showHideSolutions $(@)

  $('select[data-input-type]').each (idx, elm) -> showHideSolutions $(elm)

  $('.image-options .links a')
  .data('association-insertion-node', (elm) -> $(elm).closest('fieldset').children('.row'))
  .data('association-insertion-method', 'append')

  # Before new image option insert.
  $('.image-options').on 'cocoon:before-insert', (event, elem) ->
    $elem = $ elem
    $file = $elem.find('input[type="file"]')
    $radio = $elem.find('input[type="radio"]')
    name = $file.attr 'name'
    value = /image_response_options_attributes\]\[(\d+)\]/.exec(name)[1]
    $radio.attr 'value', value
    $radio.attr 'id', $radio.attr('id') + value
    $elem.find('input[data-image-solution-id]').val value

  # Set selected image option id as solution.
  setImageOptionSolution = ($imageOption) ->
    $stepFields = $imageOption.closest('.nested-fields[data-game-step]')
    value = $stepFields.find("input[name='#{$imageOption.attr('name')}']:checked").val()

    # Set solution value
    $solution = $stepFields.find('.solutions .nested-fields .form-group')
      .next('input[type="hidden"][value="false"]').prev().find('textarea')
    if $solution.length > 0
      # Remove all solution except first
      $solution.filter(':not(:first)').closest('.nested-fields')
        .find('a.remove_fields').trigger 'click'
      $solution.val value
    else
      $stepFields.find('.solutions').on 'cocoon:after-insert', (event, elem) ->
        $elem = $ elem
        $elem.find('textarea').val value
        $elem.closest('.solutions').off 'cocoon:after-insert'
      $stepFields.find('.solutions .links a').trigger 'click'

    $imageOption.closest('.nested-fields').find('input[data-image-solution-id]').val value

  $(document).on 'change', '.image-options input[type="radio"]', ->
    setImageOptionSolution $(@)