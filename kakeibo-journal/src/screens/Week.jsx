import { useState } from 'react'
import { useStore, activeMonth, weekTotal, actualByCategory } from '../store.jsx'
import { makeT, CATEGORIES, CATEGORY_META, categoryLabel } from '../i18n.js'
import { formatMoney, todayISO, formatDate } from '../format.js'
import { TopBar, Field, Toast, EmptyState } from '../ui.jsx'

const findWeek = (m, id) => (m ? m.weeks.find((w) => w.id === id) : null)

export function WeeksList({ nav }) {
  const { state } = useStore()
  const t = makeT(state.settings.lang)
  const m = activeMonth(state)
  const fmt = (n) => formatMoney(n, state.settings.currency, state.settings.lang)

  if (!m) {
    return (
      <div className="screen has-nav">
        <TopBar title={t('weeks')} />
        <EmptyState emoji="🌱" title={t('noOpenMonth')} desc={t('noOpenMonthDesc')} />
      </div>
    )
  }

  const openWeek = m.weeks.find((w) => !w.closed)
  const primaryLabel = m.weeks.length === 0 ? t('startFirstWeek') : (openWeek ? `${t('continueWeek')} ${openWeek.index}` : t('startWeek'))
  const onPrimary = () => {
    if (openWeek) return nav.go('week', { weekId: openWeek.id })
    nav.go('week', { weekId: nav.startWeek() })
  }

  return (
    <div className="screen has-nav">
      <TopBar title={t('weeks')} sub={m.name || undefined} />
      {m.weeks.length === 0 ? (
        <EmptyState emoji="▦" desc={t('noWeeks')} />
      ) : (
        <ul className="list">
          {m.weeks.map((w) => (
            <li key={w.id} className="row" onClick={() => nav.go('week', { weekId: w.id })} style={{ cursor: 'pointer' }}>
              <div className="row-main">
                <div className="row-title">{t('weekN', w.index)}</div>
                <div className="row-sub">{w.expenses.length} · {w.closed ? t('closed') : t('open')}</div>
              </div>
              <div className="row-amount">{fmt(weekTotal(w))}</div>
              <span style={{ color: 'var(--muted)', fontSize: 20 }}>›</span>
            </li>
          ))}
        </ul>
      )}
      <div className="primary-dock">
        <button className="btn" onClick={onPrimary}>{primaryLabel}</button>
        {m.weeks.length > 0 && (
          <button className="btn ghost" onClick={() => nav.go('monthEnd')} style={{ marginTop: 4 }}>{t('endMonth')} →</button>
        )}
      </div>
    </div>
  )
}

export function WeekScreen({ nav, params }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const lang = state.settings.lang
  const m = activeMonth(state)
  const w = findWeek(m, params.weekId)
  const fmt = (n) => formatMoney(n, state.settings.currency, lang)
  if (!m || !w) { return <div className="screen has-nav"><TopBar title={t('week')} onBack={nav.back} /></div> }

  const onBudget = (cat, v) => actions.setWeekBudget(m.id, w.id, cat, v === '' ? 0 : Number(v))

  return (
    <div className="screen has-nav">
      <TopBar title={t('weekN', w.index)} sub={`${t('weekTotal')}: ${fmt(weekTotal(w))}`} onBack={nav.back} />
      <p className="hint">{t('weekBudgetHint')}</p>

      {CATEGORIES.map((cat) => {
        const meta = CATEGORY_META[cat]
        const planned = w.budgets[cat] || 0
        const actual = actualByCategory(w, cat)
        const diff = planned - actual
        const pct = planned > 0 ? Math.min(100, (actual / planned) * 100) : (actual > 0 ? 100 : 0)
        return (
          <div className="cat" key={cat}>
            <div className="cat-head">
              <span className="cat-dot" style={{ background: meta.color }} />
              <span className="cat-name">{meta.emoji} {categoryLabel(lang, cat)}</span>
              <span className={`cat-diff ${diff < 0 ? 'neg' : 'pos'}`}>
                {diff < 0 ? t('overspent') : t('remaining')} {fmt(Math.abs(diff))}
              </span>
            </div>
            <div className="cat-nums">
              <div className="n">
                <span className="k">{t('planned')}</span>
                {w.closed ? <span className="v">{fmt(planned)}</span> : (
                  <input className="input" style={{ padding: '8px 10px', width: 110 }} inputMode="decimal"
                    value={planned || ''} placeholder="0"
                    onChange={(e) => onBudget(cat, e.target.value.replace(/[^\d.]/g, ''))} />
                )}
              </div>
              <div className="n">
                <span className="k">{t('actual')}</span>
                <span className="v">{fmt(actual)}</span>
              </div>
            </div>
            <div className="bar"><span style={{ width: `${pct}%`, background: diff < 0 ? 'var(--danger)' : meta.color }} /></div>
          </div>
        )
      })}

      <div className="primary-dock">
        {!w.closed && <button className="btn" onClick={() => nav.go('addExpense', { weekId: w.id })}>{t('addExpense')}</button>}
        <div className="btn-row" style={{ marginTop: 12 }}>
          <button className="btn secondary" onClick={() => nav.go('weekLog', { weekId: w.id })}>{t('viewLog')}</button>
          {!w.closed && <button className="btn secondary" onClick={() => nav.go('weekEnd', { weekId: w.id })}>{t('endWeek')}</button>}
        </div>
      </div>
    </div>
  )
}

export function AddExpense({ nav, params }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const lang = state.settings.lang
  const m = activeMonth(state)
  const w = findWeek(m, params.weekId)
  const [date, setDate] = useState(todayISO())
  const [item, setItem] = useState('')
  const [category, setCategory] = useState('Needs')
  const [amount, setAmount] = useState('')
  const [err, setErr] = useState({})
  const [toast, setToast] = useState(false)
  if (!m || !w) return null

  const save = () => {
    const e = {}
    if (!item.trim()) e.item = t('required')
    if (amount === '' || Number(amount) <= 0) e.amount = t('mustBePositive')
    setErr(e)
    if (Object.keys(e).length) return
    actions.addExpense(m.id, w.id, { date, item, category, amount })
    setToast(true)
    setTimeout(() => nav.back(), 850)
  }

  return (
    <div className="screen has-nav">
      <Toast show={toast} message={t('saved')} />
      <TopBar title={t('addExpense')} sub={t('weekN', w.index)} onBack={nav.back} />
      <div className="card">
        <Field label={t('date')}>
          <input className="input" type="date" value={date} onChange={(e) => setDate(e.target.value)} />
        </Field>
        <Field label={t('item')} error={err.item}>
          <input className="input" value={item} placeholder={t('itemPh')} onChange={(e) => setItem(e.target.value)} autoFocus />
        </Field>
        <Field label={t('category')}>
          <div className="chips">
            {CATEGORIES.map((c) => (
              <button key={c} type="button" className={`chip ${category === c ? 'on' : ''}`} onClick={() => setCategory(c)}>
                <span className="cat-dot" style={{ background: CATEGORY_META[c].color }} />
                {CATEGORY_META[c].emoji} {categoryLabel(lang, c)}
              </button>
            ))}
          </div>
        </Field>
        <Field label={`${t('amount')} (${state.settings.currency})`} error={err.amount}>
          <input className="input" inputMode="decimal" value={amount} placeholder="0"
            onChange={(e) => setAmount(e.target.value.replace(/[^\d.]/g, ''))} />
        </Field>
      </div>
      <div className="primary-dock">
        <button className="btn" onClick={save}>{t('save')}</button>
      </div>
    </div>
  )
}

export function WeekLog({ nav, params }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const lang = state.settings.lang
  const m = activeMonth(state)
  const w = findWeek(m, params.weekId)
  const fmt = (n) => formatMoney(n, state.settings.currency, lang)
  if (!m || !w) return null

  const items = [...w.expenses].sort((a, b) => (a.date < b.date ? 1 : -1))
  const del = (id) => { if (window.confirm(t('confirmDelete'))) actions.deleteExpense(m.id, w.id, id) }

  return (
    <div className="screen has-nav">
      <TopBar title={t('weekLog')} sub={`${t('weekTotal')}: ${fmt(weekTotal(w))}`} onBack={nav.back} />
      {items.length === 0 ? (
        <EmptyState emoji="🧾" desc={t('expensesEmpty')} />
      ) : (
        <ul className="list">
          {items.map((e) => {
            const meta = CATEGORY_META[e.category]
            return (
              <li key={e.id} className="logcard">
                <span className="cat-dot" style={{ background: meta.color }} />
                <div className="lc-main">
                  <div className="lc-title">{e.item}</div>
                  <div className="lc-sub"><span>{formatDate(e.date, lang)}</span>·<span>{meta.emoji} {categoryLabel(lang, e.category)}</span></div>
                </div>
                <div className="lc-amount">{fmt(e.amount)}</div>
                {!w.closed && <button className="del" onClick={() => del(e.id)} aria-label="delete">🗑</button>}
              </li>
            )
          })}
        </ul>
      )}
    </div>
  )
}

export function WeekEnd({ nav, params }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const m = activeMonth(state)
  const w = findWeek(m, params.weekId)
  const [proud, setProud] = useState(w?.reflection?.proudOf || '')
  const [toast, setToast] = useState(false)
  if (!m || !w) return null
  const fmt = (n) => formatMoney(n, state.settings.currency, state.settings.lang)

  const nextWeek = () => {
    actions.closeWeek(m.id, w.id, proud)
    const newId = nav.startWeek()
    setToast(true)
    setTimeout(() => nav.replace('week', { weekId: newId }), 900)
  }

  return (
    <div className="screen has-nav">
      <Toast show={toast} message={t('saved')} />
      <TopBar title={t('endWeek')} sub={t('weekN', w.index)} onBack={nav.back} />
      <div className="reflect-total">
        <div className="k">{t('weekTotal')}</div>
        <div className="v">{fmt(weekTotal(w))}</div>
      </div>
      <div className="card" style={{ marginTop: 16 }}>
        <Field label={t('proudQuestion')}>
          <textarea className="input" value={proud} placeholder={t('proudPh')} onChange={(e) => setProud(e.target.value)} />
        </Field>
      </div>
      <div className="primary-dock">
        <button className="btn" onClick={nextWeek}>{t('nextWeek')} →</button>
      </div>
    </div>
  )
}
