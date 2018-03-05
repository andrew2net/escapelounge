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

  position = $outerWheel.position()
  if position
    position.centerX = position.left + 250
    position.centerY = position.top + 250

  $outerWheel.mousedown (e) ->
    e.preventDefault()
    if e.which == 1
      initialX = e.pageX
      initialY = e.pageY
      drag = true

  $(document).mousemove (e) ->
    # e.preventDefault()
    return unless drag
    dx = e.pageX - initialX
    dXabs = Math.abs dx
    dy = e.pageY - initialY
    dYabs = Math.abs dy

    if dXabs > dYabs
      if dXabs > 3
        initialX = e.pageX
        initialY = e.pageY
        if dx > 0 and e.pageY < position.centerY or dx < 0 and e.pageY > position.centerY
          dAngle++
        else
          dAngle--
        $outerWheel.css 'transform', "rotateZ(#{nAngle * sAngle + dAngle}deg)"
    else
      if dYabs > 3
        initialX = e.pageX
        initialY = e.pageY
        if dy > 0 and e.pageX > position.centerX or dy < 0 and e.pageX < position.centerX
          dAngle++
        else
          dAngle--
        $outerWheel.css 'transform', "rotateZ(#{nAngle * sAngle + dAngle}deg)"

  $(document).mouseup (e) ->
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