$( ->
  drag       = false
  initialX   = initialY = null
  outerWheel = $('#cipher-outer-wheel')
  nAngle = dAngle = 0
  sAngle = 13.85

  position = outerWheel.position()
  position.centerX = position.left + 250
  position.centerY = position.top + 250

  outerWheel.mousedown (e) ->
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
        outerWheel.css 'transform', "rotateZ(#{nAngle * sAngle + dAngle}deg)"
    else
      if dYabs > 3
        initialX = e.pageX
        initialY = e.pageY
        if dy > 0 and e.pageX > position.centerX or dy < 0 and e.pageX < position.centerX
          dAngle++
        else
          dAngle--
        outerWheel.css 'transform', "rotateZ(#{nAngle * sAngle + dAngle}deg)"

  $(document).mouseup (e) ->
    if drag
      drag = false
      if Math.abs(dAngle) > 5
        nAngle  += Math.round dAngle / sAngle
      # else if dAngle < -5
        # nAngle -=
      dAngle = 0

      outerWheel.css 'transform', "rotateZ(#{nAngle * 13.85}deg)"
)