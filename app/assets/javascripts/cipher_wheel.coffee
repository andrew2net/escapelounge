$( ->
  drag       = false
  initialX   = initialY = null
  $outerWheel = $ '#cipher-outer-wheel'
  # nAngle Integer number of sectors wheel is rotated.
  nAngle = 0
  # Float delta agle in deg.
  dAngle = 0
  # Float sector in deg.
  sAngle = 13.85
  $answer = $ '#answer'

  position = $('#cipher-wheel').position()
  if position
    position.centerX = position.left + 250
    position.centerY = position.top + 250

  $outerWheel.on 'mousedown touchstart', (e) ->
    e.preventDefault()
    if e.touches && e.touches.length == 1
      initialX = e.touches[0].pageX
      initialY = e.touches[0].pageY
      drag = true
    else if e.which == 1
      initialX = e.pageX
      initialY = e.pageY
      drag = true

  $(document).on 'mousemove touchmove', (e) ->
    return unless drag

    if e.touches && e.touches.length == 1
      pageX = e.touches[0].pageX
      pageY = e.touches[0].pageY
    else
      pageX = e.pageX
      pageY = e.pageY

    dx = pageX - initialX
    dXabs = Math.abs dx
    dy = pageY - initialY
    dYabs = Math.abs dy

    if dXabs > dYabs
      if dXabs > 6
        initialX = pageX
        initialY = pageY
        if dx > 0 and pageY < position.centerY or dx < 0 and pageY > position.centerY
          dAngle += 3
        else
          dAngle -= 3
        $outerWheel.css 'transform', "rotateZ(#{nAngle * sAngle + dAngle}deg)"
    else
      if dYabs > 6
        initialX = pageX
        initialY = pageY
        if dy > 0 and pageX > position.centerX or dy < 0 and pageX < position.centerX
          dAngle += 2
        else
          dAngle -= 2
        $outerWheel.css 'transform', "rotateZ(#{nAngle * sAngle + dAngle}deg)"

  $(document).on 'mouseup touchend', (e) ->
    if drag
      drag = false
      if Math.abs(dAngle) > 5
        nAngle  += Math.round dAngle / sAngle

      dAngle = 0
      $outerWheel.css 'transform', "rotateZ(#{nAngle * 13.85}deg)"

  $('g#cipher-inner-wheel text').click (e) ->
    num = parseInt @parentNode.dataset.num
    # dNum = nAngle % 26
    num = (num - nAngle) % 26
    num += 26 if num < 0
    char = String.fromCharCode num + 65
    $answer.val $answer.val() + char
)