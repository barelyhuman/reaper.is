const header = document.getElementById('header-nav')
const toggle = createToggle()
addMenuHoverListeners(header, toggle)

hide(header, true)

/**
 *
 * @returns {HTMLDivElement}
 */
function createToggle() {
  const toggle = document.createElement('div')
  toggle.classList.add('hoverable')
  toggle.style.marginBottom = '10px'
  return toggle
}

/**
 * @param {HTMLElement} header
 * @param {HTMLElement} toggle
 */
function addMenuHoverListeners(header, toggle) {
  const parent = header.parentNode

  header.addEventListener('mouseover', () => {
    show(header)
  })

  toggle.addEventListener('mouseover', () => {
    toggle.style.animation = ''
    toggle.style.animation = 'rotate 1.5s linear infinite'
    show(header)
  })

  parent.addEventListener('mouseleave', () => {
    stopAnimationsAfterCompletion(toggle)
    hide(header)
  })

  toggle.addEventListener('touchend', () => {
    toggleVisible(header)
  })

  parent.style.position = 'relative'
  parent.insertBefore(toggle, header)
}

function toggleVisible(el) {
  if (el.style.visibility === 'visible') {
    return hide(el)
  }

  return show(el)
}

function hide(el, quick) {
  clearAniFrames()
  const elemTransition = el.style.transition
  el.style.transition = ''
  if (quick) {
    el.style.height = 0
    el.style.minHeight = 0
    el.style.overflow = 'hidden'
    el.style.transition = elemTransition
    return
  }
  let id
  el.style.overflow = 'hidden'
  if (
    !el.style.height ||
    el.style.height === 'auto' ||
    isNaN(el.style.height)
  ) {
    el.style.height = '50px'
  }

  function onAnim() {
    const currHeight = Math.min(el.scrollHeight, parseInt(el.style.height, 10))
    if (currHeight - 10 <= -1) {
      cancelAnimationFrame(id)
      return false
    }
    el.style.height = currHeight - 10 + 'px'
    el.style.minHeight = currHeight - 10 + 'px'
    id = requestAnimationFrame(onAnim)
  }

  id = requestAnimationFrame(onAnim)
}

function show(el) {
  clearAniFrames()

  const maxHeight = 50

  const onAnim = () => {
    let currHeight = Math.max(0, parseInt(el.style.height, 10))
    const nextHeight = currHeight + 5
    if (nextHeight >= maxHeight / 3) {
      el.style.overflow = 'visible'
    }

    if (nextHeight > maxHeight) {
      el.style.height = 'auto'
      cancelAnimationFrame(id)
      return false
    }

    el.style.height = nextHeight + 'px'
    el.style.minHeight = nextHeight + 'px'
    id = requestAnimationFrame(onAnim)
  }

  id = requestAnimationFrame(onAnim)
}

function stopAnimationsAfterCompletion(el) {
  const animations = el.getAnimations()

  animations.forEach(async anim => {
    anim.effect.updateTiming({
      iterations: anim.effect.getComputedTiming().currentIteration + 1,
    })
    await anim.finished
    el.style.animation = ''
  })
}

function clearAniFrames() {
  var id = requestAnimationFrame(function () {})

  for (;;) {
    if (id-- < 0) {
      break
    }
    cancelAnimationFrame(id)
  }
}
