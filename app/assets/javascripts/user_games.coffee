$ ->
  hintsContainer = $ '#hints-container'
  answerBtn      = $ '#answer-btn'
  form           = $ '#step-form'
  modal          = $ '#result-modal'
  modalMessage   = modal.find 'h2'

  # Show hint and reduce remaning time on click the button.
  hintsContainer.on 'click', '#show-hint-btn', (event)->
    hint_id = event.target.getAttribute 'data-hint-id'
    value = parseInt(event.target.getAttribute('data-value'))
    window.timer.secondsRemain -= value
    url = event.target.getAttribute 'data-url'
    hintsContainer.load url, { hint_id: hint_id }

  answerBtn.click (event)->
    event.preventDefault()
    $.post event.target.href, form.serialize(), (resp)->
      switch resp.result
        when 'success'
          modalMessage.html 'Success!'
          modalMessage.removeClass 'text-danger'
          modalMessage.removeClass 'text-info'
          modalMessage.addClass 'text-success'
          modal.modal 'show'
          setTimeout ->
            window.location = resp.redirect
          , 2000
        when 'fail'
          modalMessage.html 'Wrong answer!'
          modalMessage.removeClass 'text-success'
          modalMessage.removeClass 'text-info'
          modalMessage.addClass 'text-danger'
          modal.modal 'show'
          setTimeout ->
            modal.modal 'hide'
          , 2000
        when 'finish'
          modalMessage.html 'Game is ended!'
          modalMessage.removeClass 'text-danger'
          modalMessage.removeClass 'text-success'
          modalMessage.addClass 'text-info'
          modal.modal 'show'
          setTimeout ->
            window.location = resp.redirect
          , 2000
