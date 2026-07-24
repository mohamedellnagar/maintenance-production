import sharp from 'sharp'
import { mkdirSync } from 'node:fs'

const NAVY = '#1F3A5F'
const GOLD = '#C9A227'
const RES = new URL('../resources/', import.meta.url)
mkdirSync(RES, { recursive: true })

// Fountain-pen nib drawn in a 0..100 box, then scaled/positioned per asset.
const nib = (stroke = NAVY) => `
  <path d="M30 25 L70 25 L50 82 Z" fill="${GOLD}" stroke="${GOLD}" stroke-width="3" stroke-linejoin="round"/>
  <circle cx="50" cy="43" r="6" fill="${stroke}"/>
  <line x1="50" y1="49" x2="50" y2="74" stroke="${stroke}" stroke-width="3.4" stroke-linecap="round"/>
`

const svg = (size, { bg, tx, ty, s, holeColor }) => `
<svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
  ${bg ? `<rect width="${size}" height="${size}" fill="${bg}"/>` : ''}
  <g transform="translate(${tx} ${ty}) scale(${s})">${nib(holeColor)}</g>
</svg>`

const render = (name, markup, size) =>
  sharp(Buffer.from(markup)).resize(size, size).png().toFile(new URL(name, RES).pathname)

// Adaptive icon: separate background + foreground (foreground kept in the safe zone).
const fgScale = 8.4, fgTx = 512 - 50 * fgScale, fgTy = 512 - 52.5 * fgScale
await render('icon-background.png', svg(1024, { bg: NAVY, tx: 0, ty: 0, s: 0 }), 1024)
await render('icon-foreground.png', svg(1024, { bg: null, tx: fgTx, ty: fgTy, s: fgScale, holeColor: NAVY }), 1024)

// Legacy / round / store icon: full-bleed navy with a larger nib.
const soScale = 10.2, soTx = 512 - 50 * soScale, soTy = 512 - 52.5 * soScale
await render('icon-only.png', svg(1024, { bg: NAVY, tx: soTx, ty: soTy, s: soScale, holeColor: NAVY }), 1024)
await render('logo.png', svg(1024, { bg: NAVY, tx: soTx, ty: soTy, s: soScale, holeColor: NAVY }), 1024)

// Splash: centered nib on navy.
const spScale = 12.6, spTx = 1366 - 50 * spScale, spTy = 1366 - 52.5 * spScale
const splash = svg(2732, { bg: NAVY, tx: spTx, ty: spTy, s: spScale, holeColor: NAVY })
await render('splash.png', splash, 2732)
await render('splash-dark.png', splash, 2732)

console.log('icons + splash written to resources/')
