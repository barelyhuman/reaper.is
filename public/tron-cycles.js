// Grid-based Tron Light Cycle background
const canvas = document.getElementById('tron-lines')
const ctx = canvas.getContext('2d')

let width, height, isDark
let animationId
let cols, rows, gridSize
let occupied = new Set()
let cycles = []

function resize() {
  const dpr = window.devicePixelRatio || 1
  width = window.innerWidth
  height = window.innerHeight
  canvas.width = width * dpr
  canvas.height = height * dpr
  canvas.style.width = width + 'px'
  canvas.style.height = height + 'px'
  ctx.setTransform(dpr, 0, 0, dpr, 0, 0)

  gridSize = Math.max(
    30,
    Math.min(50, Math.floor(Math.min(width, height) / 24))
  )
  cols = Math.floor(width / gridSize)
  rows = Math.floor(height / gridSize)

  occupied.clear()
  cycles = []
  for (let i = 0; i < 4; i++) {
    cycles.push(new LightCycle(i))
  }
}
window.addEventListener('resize', resize)

function detectTheme() {
  const dataTheme = document.body.getAttribute('data-theme')
  if (dataTheme) {
    isDark = ['dark', 'hacker', 'plastic', 'rose-pine'].includes(dataTheme)
    return
  }
  isDark = window.matchMedia('(prefers-color-scheme: dark)').matches
}

const themeObserver = new MutationObserver(detectTheme)
themeObserver.observe(document.body, {
  attributes: true,
  attributeFilter: ['data-theme'],
})
window
  .matchMedia('(prefers-color-scheme: dark)')
  .addEventListener('change', detectTheme)
detectTheme()

class LightCycle {
  constructor(sideIndex) {
    this.sideIndex = sideIndex
    this.reset()
  }

  spawnOnSide() {
    const side = this.sideIndex % 4
    let x, y, dir
    switch (side) {
      case 0: // left edge, moving right
        x = 0
        y = Math.floor(Math.random() * rows)
        dir = 0
        break
      case 1: // top edge, moving down
        x = Math.floor(Math.random() * cols)
        y = 0
        dir = 1
        break
      case 2: // right edge, moving left
        x = cols - 1
        y = Math.floor(Math.random() * rows)
        dir = 2
        break
      default: // bottom edge, moving up
        x = Math.floor(Math.random() * cols)
        y = rows - 1
        dir = 3
        break
    }
    return { x, y, dir }
  }

  reset() {
    this.clearTrail()

    let start = this.spawnOnSide()
    let attempts = 0
    while (occupied.has(`${start.x},${start.y}`) && attempts < 200) {
      start = this.spawnOnSide()
      attempts++
    }

    this.x = start.x
    this.y = start.y
    this.lastX = start.x
    this.lastY = start.y
    this.dir = start.dir
    this.trail = []
    this.maxLen = 30 + Math.floor(Math.random() * 25)
    this.moveInterval = 380 + Math.floor(Math.random() * 260)
    this.moveStart = performance.now() - this.moveInterval
    this.moveEnd = performance.now()
    this.turnChance = 0.025
  }

  clearTrail() {
    if (!this.trail) {
      this.trail = []
      return
    }
    for (const seg of this.trail) {
      occupied.delete(`${seg.x},${seg.y}`)
    }
    this.trail = []
  }

  canMove(dir) {
    const dx = dir === 0 ? 1 : dir === 2 ? -1 : 0
    const dy = dir === 1 ? 1 : dir === 3 ? -1 : 0
    const nx = this.x + dx
    const ny = this.y + dy
    if (nx < 0 || nx >= cols || ny < 0 || ny >= rows) return false
    return !occupied.has(`${nx},${ny}`)
  }

  step(now) {
    const left = (this.dir + 3) % 4
    const right = (this.dir + 1) % 4
    const canStraight = this.canMove(this.dir)
    const canLeft = this.canMove(left)
    const canRight = this.canMove(right)

    let nextDir = this.dir
    if (!canStraight) {
      if (canLeft && canRight) nextDir = Math.random() < 0.5 ? left : right
      else if (canLeft) nextDir = left
      else if (canRight) nextDir = right
      else {
        this.reset()
        return
      }
    } else if (Math.random() < this.turnChance) {
      if (canLeft && canRight) nextDir = Math.random() < 0.5 ? left : right
      else if (canLeft) nextDir = left
      else if (canRight) nextDir = right
    }

    this.dir = nextDir

    this.trail.push({ x: this.x, y: this.y, birth: now })
    occupied.add(`${this.x},${this.y}`)

    while (this.trail.length > this.maxLen) {
      const old = this.trail.shift()
      occupied.delete(`${old.x},${old.y}`)
    }

    this.lastX = this.x
    this.lastY = this.y

    const dx = this.dir === 0 ? 1 : this.dir === 2 ? -1 : 0
    const dy = this.dir === 1 ? 1 : this.dir === 3 ? -1 : 0
    this.x += dx
    this.y += dy

    this.moveStart = now
    this.moveEnd = now + this.moveInterval
  }

  update(now) {
    if (now >= this.moveEnd) {
      this.step(now)
    }
  }

  draw(ctx, dark, now) {
    if (this.trail.length < 1) return

    const maxAge = this.maxLen * this.moveInterval

    let t = 0
    if (this.moveEnd > this.moveStart) {
      t = (now - this.moveStart) / (this.moveEnd - this.moveStart)
    }
    if (t < 0) t = 0
    if (t > 1) t = 1

    const visualX = this.lastX + (this.x - this.lastX) * t
    const visualY = this.lastY + (this.y - this.lastY) * t

    // Draw trail segments between stored points
    for (let i = 0; i < this.trail.length - 1; i++) {
      const a = this.trail[i]
      const b = this.trail[i + 1]
      const age = now - a.birth
      let alpha = 1 - age / maxAge
      if (alpha < 0) alpha = 0
      if (!dark) alpha *= 0.35

      const ax = a.x * gridSize + gridSize / 2
      const ay = a.y * gridSize + gridSize / 2
      const bx = b.x * gridSize + gridSize / 2
      const by = b.y * gridSize + gridSize / 2

      ctx.beginPath()
      ctx.moveTo(ax, ay)
      ctx.lineTo(bx, by)

      if (dark) {
        ctx.strokeStyle = `rgba(255, 255, 255, ${alpha * 0.45})`
        ctx.lineWidth = 1.2
        ctx.shadowBlur = 3
        ctx.shadowColor = `rgba(255, 255, 255, ${alpha * 0.25})`
      } else {
        ctx.strokeStyle = `rgba(24, 24, 25, ${alpha * 0.35})`
        ctx.lineWidth = 1.0
        ctx.shadowBlur = 0
      }
      ctx.stroke()
      ctx.shadowBlur = 0
    }

    // Draw line from last trail point to interpolated head
    const last = this.trail[this.trail.length - 1]
    const lx = last.x * gridSize + gridSize / 2
    const ly = last.y * gridSize + gridSize / 2
    const hx = visualX * gridSize + gridSize / 2
    const hy = visualY * gridSize + gridSize / 2

    if (lx !== hx || ly !== hy) {
      const age = now - last.birth
      let alpha = 1 - age / maxAge
      if (alpha < 0) alpha = 0
      if (!dark) alpha *= 0.35

      ctx.beginPath()
      ctx.moveTo(lx, ly)
      ctx.lineTo(hx, hy)

      if (dark) {
        ctx.strokeStyle = `rgba(255, 255, 255, ${alpha * 0.45})`
        ctx.lineWidth = 1.2
        ctx.shadowBlur = 3
        ctx.shadowColor = `rgba(255, 255, 255, ${alpha * 0.25})`
      } else {
        ctx.strokeStyle = `rgba(24, 24, 25, ${alpha * 0.35})`
        ctx.lineWidth = 1.0
        ctx.shadowBlur = 0
      }
      ctx.stroke()
      ctx.shadowBlur = 0
    }

    // Head dot (interpolated)
    ctx.beginPath()
    ctx.arc(hx, hy, dark ? 2.5 : 2.2, 0, Math.PI * 2)
    ctx.fillStyle = dark ? 'rgba(255,255,255,0.85)' : 'rgba(24,24,25,0.55)'
    if (dark) {
      ctx.shadowBlur = 10
      ctx.shadowColor = 'rgba(255,255,255,0.5)'
    }
    ctx.fill()
    ctx.shadowBlur = 0
  }
}

function drawGrid(dark) {
  if (!cols || !rows || !gridSize) return
  ctx.beginPath()
  for (let c = 0; c <= cols; c++) {
    const x = c * gridSize
    ctx.moveTo(x, 0)
    ctx.lineTo(x, rows * gridSize)
  }
  for (let r = 0; r <= rows; r++) {
    const y = r * gridSize
    ctx.moveTo(0, y)
    ctx.lineTo(cols * gridSize, y)
  }
  if (dark) {
    ctx.strokeStyle = 'rgba(255, 255, 255, 0.04)'
  } else {
    ctx.strokeStyle = 'rgba(0, 0, 0, 0.04)'
  }
  ctx.lineWidth = 1
  ctx.shadowBlur = 0
  ctx.stroke()
}

const LOGIC_STEP = 1000 / 30 // 33.33 ms
let logicAccum = 0
let lastTime = performance.now()

function animate(now) {
  logicAccum += now - lastTime
  lastTime = now

  while (logicAccum >= LOGIC_STEP) {
    logicAccum -= LOGIC_STEP
    for (const cycle of cycles) {
      cycle.update(now - logicAccum)
    }
  }

  ctx.clearRect(0, 0, width, height)
  drawGrid(isDark)

  for (const cycle of cycles) {
    cycle.draw(ctx, isDark, now)
  }

  animationId = requestAnimationFrame(animate)
}

resize()
animate(performance.now())

document.addEventListener('visibilitychange', () => {
  if (document.hidden) {
    cancelAnimationFrame(animationId)
  } else {
    lastTime = performance.now()
    animationId = requestAnimationFrame(animate)
  }
})
