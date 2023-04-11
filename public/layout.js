const header = document.getElementById('header-nav')
const toggle = document.createElement('div')
const parent = header.parentNode
hide(header)

toggle.classList.add('hoverable')

toggle.style.marginBottom = '10px'

header.addEventListener('mouseover', () => {
  show(header)
})

toggle.addEventListener('mouseover', () => {
  toggle.style.animation = 'rotate 1.5s linear infinite'
  show(header)
})

parent.addEventListener('mouseleave', () => {
  toggle.style.animation = ''
  hide(header)
})

toggle.addEventListener('touchend', () => {
  toggleVisible(header)
})

parent.style.position = 'relative'
parent.insertBefore(toggle, header)

function toggleVisible(el) {
  if (el.style.visibility === 'visible') {
    return hide(el)
  }

  return show(el)
}

function hide(el) {
  el.style.visibility = 'hidden'
  el.style.height = '0px'
}

function show(el) {
  el.style.visibility = 'visible'
  el.style.height = 'auto'
}
