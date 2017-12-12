$ ->
  $hintsContainer = $ '#hints-container'
  $answerBtn      = $ '#answer-btn'
  $form           = $ '#step-form'
  $modal          = $ '#result-modal'
  $modalMessage   = $modal.find 'h2'
  $hintLink       = $ '#hint-link a'
  $hintPop        = $ '#hint-pop'

  # Show hint and reduce remaning time on click the button.
  $hintsContainer.on 'click', '#show-hint-btn', (event)->
    hint_id = event.target.getAttribute 'data-hint-id'
    value = parseInt(event.target.getAttribute('data-value'))
    window.timer.secondsRemain -= value
    url = event.target.getAttribute 'data-url'
    $hintsContainer.load url, { hint_id: hint_id }

  modalTimeOut = null

  # Submit answer
  submit = (event)->
    event.preventDefault()
    return if modalTimeOut
    $.post event.target.href, $form.serialize(), (resp)->
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

  # new Popper $hintLink, $hintPop

  $answerBtn.click submit
  $form.submit submit
