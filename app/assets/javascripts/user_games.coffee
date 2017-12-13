$ ->
  $hintsContainer = $ '#hints-carousel'
  $answerBtn      = $ '#answer-btn'
  $form           = $ '#step-form'
  $modal          = $ '#result-modal'
  $modalMessage   = $modal.find 'h2'
  $hintLink       = $ '#hint-link > a'
  $hintPop        = $ '#hint-pop'

  # Show hint and reduce remaning time on click the button.
  $hintsContainer.on 'click', '#show-hint-btn', (event)->
    event.preventDefault()
    hint_id = @.getAttribute 'data-hint-id'
    value = parseInt(@.getAttribute('data-value'))
    window.timer.secondsRemain -= value
    url = @.getAttribute 'data-url'
    $hintsContainer.load url, { hint_id: hint_id }, ->
      $items = $hintsContainer.find '.carousel-item'
      n = if $items.last().find('#show-hint-btn').length
        $items.length - 2
      else
        $items.length - 1
      $hintsContainer.carousel n

  $hintsContainer.on 'slide.bs.carousel', (e)->
    $hintsContainer.find('.carousel-indicators li').removeClass 'active'
    $hintsContainer.find(".carousel-indicators li[data-slide-to='#{e.to}']").addClass 'active'

  modalTimeOut = null

  # Submit answer
  submit = (event)->
    event.preventDefault()
    return if modalTimeOut
    $.post @href, $form.serialize(), (resp)->
      switch resp.result
        when 'success'
          $modalMessage.html 'Success!'
          $modalMessage.removeClass 'text-danger'
          $modalMessage.removeClass 'text-info'
          $modalMessage.addClass 'text-success'
          $modal.modal 'show'
          modalTimeOut = setTimeout ->
            window.location = resp.redirect
            modalTimeOut = null
          , 2000
        when 'fail'
          $modalMessage.html 'Wrong answer!'
          $modalMessage.removeClass 'text-success'
          $modalMessage.removeClass 'text-info'
          $modalMessage.addClass 'text-danger'
          $modal.modal 'show'
          modalTimeOut = setTimeout ->
            $modal.modal 'hide'
            modalTimeOut = null
          , 2000
        when 'finish'
          $modalMessage.html 'Game is ended!'
          $modalMessage.removeClass 'text-danger'
          $modalMessage.removeClass 'text-success'
          $modalMessage.addClass 'text-info'
          $modal.modal 'show'
          modalTimeOut = setTimeout ->
            window.location = resp.redirect
            modalTimeOut = null
          , 2000

  $hintLink.click (e)->
    e.preventDefault()
    $hintPop.fadeToggle() # 'd-none'

  $answerBtn.click submit
  $form.submit submit
