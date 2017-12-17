$ ->
  $hintsContainer = $ '#hints-carousel'
  $answerBtn      = $ '#answer-btn'
  $form           = $ '#step-form'
  $modal          = $ '#result-modal'
  $modalMessage   = $modal.find 'h2'
  $hintLink       = $ '#hint-link > a'
  $hintPop        = $ '#hint-pop'
  $eyeInKeyhole   = $ '#eye-in-keyhole'
  $keyInKeyhole   = $ '#key-in-keyhole'

  loadHint = ($showHintBtn)->
    hint_id = $showHintBtn.data 'hint-id'
    value = parseInt $showHintBtn.data 'value'
    window.timer.secondsRemain -= value
    url = $showHintBtn.data 'url'
    $hintsContainer.load url, { hint_id: hint_id }, ->
      $items = $hintsContainer.find '.carousel-item'
      # Display slide with last hint
      n = if $items.last().find('#show-hint-btn').length
        $items.length - 2
      else
        $items.length - 1
      $hintsContainer.carousel n

  $('#eyelid').click ->
    $keyInKeyhole.addClass 'translate-up-40'
    $('#hint-open-animation').addClass 'hint-open'
    $('#hint-open-bubble').addClass 'hide-hint-bubble'
    $('#flashlight').addClass 'flashlight-animate'
    loadHint $(@)

  # Show hint and reduce remaning time on click the button.
  $hintsContainer.on 'click', '#show-hint-btn', (event)->
    event.preventDefault()
    loadHint $(@)

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

  # Toggle hints window
  $hintLink.click (e)->
    e.preventDefault()
    $hintPop.fadeToggle() # 'd-none'

  # Submit form
  $answerBtn.click submit
  $form.submit submit
