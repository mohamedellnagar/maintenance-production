import { useEffect } from 'react'

export function TopBar({ title, sub, onBack, right }) {
  return (
    <div className="topbar">
      {onBack && (
        <button className="iconbtn" onClick={onBack} aria-label="back">
          <span style={{ display: 'inline-block' }}>‹</span>
        </button>
      )}
      <div>
        <h1>{title}</h1>
        {sub && <div className="sub">{sub}</div>}
      </div>
      <div className="spacer" />
      {right}
    </div>
  )
}

export function EmptyState({ emoji = '📝', title, desc }) {
  return (
    <div className="empty">
      <div className="emoji">{emoji}</div>
      {title && <div className="t">{title}</div>}
      {desc && <div className="d">{desc}</div>}
    </div>
  )
}

// Small celebratory save confirmation (UX rule: every save shows a tiny animation).
export function Toast({ show, message, onDone, duration = 1000 }) {
  useEffect(() => {
    if (!show) return
    const t = setTimeout(() => onDone && onDone(), duration)
    return () => clearTimeout(t)
  }, [show, duration, onDone])
  if (!show) return null
  return (
    <div className="toast-wrap">
      <div className="toast">
        <div className="check">✓</div>
        <div className="msg">{message}</div>
      </div>
    </div>
  )
}

export function Field({ label, error, children }) {
  return (
    <div className="field">
      {label && <label>{label}</label>}
      {children}
      {error && <span className="err">{error}</span>}
    </div>
  )
}

export const BottomNav = ({ tab, onTab, t }) => {
  const items = [
    { key: 'home', ico: '⌂', label: t('home') },
    { key: 'weeks', ico: '▦', label: t('weeks') },
    { key: 'history', ico: '☷', label: t('history') },
    { key: 'settings', ico: '⚙', label: t('settings') },
  ]
  return (
    <nav className="bottomnav">
      {items.map((it) => (
        <button key={it.key} className={`navbtn ${tab === it.key ? 'active' : ''}`} onClick={() => onTab(it.key)}>
          <span className="ico">{it.ico}</span>
          <span>{it.label}</span>
        </button>
      ))}
    </nav>
  )
}
