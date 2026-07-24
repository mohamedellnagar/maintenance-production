import { useState } from 'react'
import { useStore, activeMonth, totalIncome, totalFixed, available, sum, weekTotal } from '../store.jsx'
import { makeT, MONTH_NAMES, monthLabel } from '../i18n.js'
import { formatMoney } from '../format.js'
import { TopBar, Field, Toast, EmptyState } from '../ui.jsx'

export function CreateMonthForm({ firstTime = false, onCreated }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const now = new Date()
  const [name, setName] = useState('')
  const [month, setMonth] = useState(now.getMonth())
  const [year, setYear] = useState(now.getFullYear())
  const [savings, setSavings] = useState('')
  const [err, setErr] = useState({})

  const submit = () => {
    const e = {}
    if (savings === '' || Number(savings) < 0) e.savings = t('required')
    setErr(e)
    if (Object.keys(e).length) return
    actions.createMonth({ name, month, year, savingsGoal: savings })
    onCreated && onCreated()
  }

  const years = []
  for (let y = now.getFullYear() - 1; y <= now.getFullYear() + 2; y++) years.push(y)

  return (
    <div className={`screen ${firstTime ? '' : 'has-nav'}`}>
      <TopBar title={t('createMonth')} sub={t('tagline')} />
      <Field label={t('monthNameField')}>
        <input className="input" value={name} placeholder={t('monthNamePh')} onChange={(e) => setName(e.target.value)} />
      </Field>
      <div className="grid-2">
        <Field label={t('month')}>
          <select className="input" value={month} onChange={(e) => setMonth(Number(e.target.value))}>
            {MONTH_NAMES[state.settings.lang].map((mn, i) => <option key={i} value={i}>{mn}</option>)}
          </select>
        </Field>
        <Field label={t('year')}>
          <select className="input" value={year} onChange={(e) => setYear(Number(e.target.value))}>
            {years.map((y) => <option key={y} value={y}>{y}</option>)}
          </select>
        </Field>
      </div>
      <Field label={`${t('savingsGoal')} (${state.settings.currency})`} error={err.savings}>
        <input className="input" inputMode="decimal" value={savings} placeholder="0"
          onChange={(e) => setSavings(e.target.value.replace(/[^\d.]/g, ''))} />
      </Field>
      <div className="primary-dock">
        <button className="btn" onClick={submit}>{t('create')}</button>
      </div>
    </div>
  )
}

export function Home({ nav }) {
  const { state } = useStore()
  const t = makeT(state.settings.lang)
  const m = activeMonth(state)

  if (!m) {
    return (
      <div className="screen has-nav">
        <TopBar title={t('appName')} sub={t('tagline')} />
        <EmptyState emoji="🌱" title={t('noOpenMonth')} desc={t('noOpenMonthDesc')} />
        <CreateMonthForm />
      </div>
    )
  }

  const inc = totalIncome(m)
  const fix = totalFixed(m)
  const avail = available(m)
  const openWeek = m.weeks.find((w) => !w.closed)
  const fmt = (n) => formatMoney(n, state.settings.currency, state.settings.lang)

  const primaryLabel = m.weeks.length === 0 ? t('startFirstWeek') : (openWeek ? t('continueWeek') : t('startWeek'))
  const onPrimary = () => {
    if (openWeek) return nav.go('week', { weekId: openWeek.id })
    const id = nav.startWeek()
    nav.go('week', { weekId: id })
  }

  return (
    <div className="screen has-nav">
      <TopBar title={m.name || t('newMonth')} sub={monthLabel(state.settings.lang, m.month, m.year)} />
      <div className="grid-2">
        <button className="card kpi" onClick={() => nav.go('income')}>
          <span className="kpi-icon">💰</span>
          <span className="label">{t('income')}</span>
          <span className="value">{fmt(inc)}</span>
        </button>
        <button className="card kpi" onClick={() => nav.go('fixed')}>
          <span className="kpi-icon">📌</span>
          <span className="label">{t('fixedExpenses')}</span>
          <span className="value">{fmt(fix)}</span>
        </button>
        <button className="card kpi" onClick={() => nav.go('savings')}>
          <span className="kpi-icon">🎯</span>
          <span className="label">{t('savingsGoal')}</span>
          <span className="value">{fmt(m.savingsGoal)}</span>
        </button>
        <div className={`card kpi accent ${avail < 0 ? 'negative' : ''}`}>
          <span className="kpi-icon">🕊️</span>
          <span className="label">{t('availableToSpend')}</span>
          <span className="value">{fmt(avail)}</span>
        </div>
      </div>
      <div className="primary-dock">
        <button className="btn" onClick={onPrimary}>{primaryLabel}</button>
      </div>
    </div>
  )
}

// Shared simple "name + amount" list editor for income & fixed expenses.
function ItemListScreen({ kind, nav }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const m = activeMonth(state)
  const [name, setName] = useState('')
  const [amount, setAmount] = useState('')
  const [err, setErr] = useState({})
  const [toast, setToast] = useState(false)

  if (!m) return null
  const isIncome = kind === 'income'
  const items = isIncome ? m.income : m.fixed
  const fmt = (n) => formatMoney(n, state.settings.currency, state.settings.lang)

  const add = () => {
    const e = {}
    if (!name.trim()) e.name = t('required')
    if (amount === '' || Number(amount) <= 0) e.amount = t('mustBePositive')
    setErr(e)
    if (Object.keys(e).length) return
    if (isIncome) actions.addIncome(m.id, { name, amount }); else actions.addFixed(m.id, { name, amount })
    setName(''); setAmount(''); setToast(true)
  }
  const del = (id) => {
    if (!window.confirm(t('confirmDelete'))) return
    if (isIncome) actions.deleteIncome(m.id, id); else actions.deleteFixed(m.id, id)
  }

  const total = sum(items, (x) => x.amount)

  return (
    <div className="screen has-nav">
      <Toast show={toast} message={t('saved')} onDone={() => setToast(false)} />
      <TopBar title={isIncome ? t('income') : t('fixedExpenses')} sub={`${t('total')}: ${fmt(total)}`} onBack={nav.back} />

      <div className="card">
        <Field label={t('itemName')} error={err.name}>
          <input className="input" value={name} placeholder={isIncome ? t('itemNamePh') : t('fixedNamePh')} onChange={(e) => setName(e.target.value)} />
        </Field>
        <Field label={`${t('amount')} (${state.settings.currency})`} error={err.amount}>
          <input className="input" inputMode="decimal" value={amount} placeholder="0"
            onChange={(e) => setAmount(e.target.value.replace(/[^\d.]/g, ''))} />
        </Field>
        <button className="btn" onClick={add}>{t('add')}</button>
      </div>

      <div className="section-title">{isIncome ? t('income') : t('fixedExpenses')}</div>
      {items.length === 0 ? (
        <EmptyState emoji={isIncome ? '💰' : '📌'} desc={isIncome ? t('incomeEmpty') : t('fixedEmpty')} />
      ) : (
        <ul className="list">
          {items.map((it) => (
            <li key={it.id} className="row">
              <div className="row-main">
                <div className="row-title">{it.name}</div>
              </div>
              <div className="row-amount">{fmt(it.amount)}</div>
              <button className="del" onClick={() => del(it.id)} aria-label="delete">🗑</button>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

export const IncomeScreen = (props) => <ItemListScreen kind="income" {...props} />
export const FixedScreen = (props) => <ItemListScreen kind="fixed" {...props} />

export function SavingsScreen({ nav }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const m = activeMonth(state)
  const [val, setVal] = useState(m ? String(m.savingsGoal || '') : '')
  const [toast, setToast] = useState(false)
  if (!m) return null

  const save = () => {
    actions.setSavingsGoal(m.id, val === '' ? 0 : Number(val))
    setToast(true)
    setTimeout(() => nav.back(), 700)
  }

  return (
    <div className="screen has-nav">
      <Toast show={toast} message={t('saved')} />
      <TopBar title={t('editSavings')} onBack={nav.back} />
      <div className="card">
        <Field label={`${t('savingsGoal')} (${state.settings.currency})`}>
          <input className="input" inputMode="decimal" value={val} placeholder="0" autoFocus
            onChange={(e) => setVal(e.target.value.replace(/[^\d.]/g, ''))} />
        </Field>
        <button className="btn" onClick={save}>{t('save')}</button>
      </div>
      <p className="hint">{formatMoney(available({ ...m, savingsGoal: Number(val) || 0 }), state.settings.currency, state.settings.lang)} · {t('availableToSpend')}</p>
    </div>
  )
}

export function MonthEnd({ nav }) {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const m = activeMonth(state)
  const spentAll = m ? sum(m.weeks, (w) => weekTotal(w)) : 0
  const [had, setHad] = useState(m ? String(totalIncome(m)) : '')
  const [wanted, setWanted] = useState(m ? String(m.savingsGoal || '') : '')
  const [spent, setSpent] = useState(String(spentAll))
  const [improve, setImprove] = useState('')
  const [toast, setToast] = useState(false)
  if (!m) return null

  const close = () => {
    actions.closeMonth(m.id, {
      had: Number(had) || 0,
      wantedToSave: Number(wanted) || 0,
      actuallySpent: Number(spent) || 0,
      improveNext: improve.trim(),
    })
    setToast(true)
    setTimeout(() => nav.tab('home'), 1100)
  }

  const num = (v, set, label) => (
    <Field label={label}>
      <input className="input" inputMode="decimal" value={v} onChange={(e) => set(e.target.value.replace(/[^\d.]/g, ''))} />
    </Field>
  )

  return (
    <div className="screen has-nav">
      <Toast show={toast} message={t('monthClosed')} duration={1100} />
      <TopBar title={t('endMonth')} sub={t('reflection')} onBack={nav.back} />
      <div className="card">
        {num(had, setHad, t('qHad'))}
        {num(wanted, setWanted, t('qWanted'))}
        {num(spent, setSpent, t('qSpent'))}
        <Field label={t('qImprove')}>
          <textarea className="input" value={improve} placeholder={t('qImprovePh')} onChange={(e) => setImprove(e.target.value)} />
        </Field>
      </div>
      <div className="primary-dock">
        <button className="btn" onClick={close}>{t('closeMonth')}</button>
      </div>
    </div>
  )
}
