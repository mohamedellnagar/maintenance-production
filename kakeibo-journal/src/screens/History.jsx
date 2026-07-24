import { useStore, totalIncome, totalFixed, available, weekTotal, actualByCategory, sum } from '../store.jsx'
import { makeT, monthLabel, CATEGORIES, CATEGORY_META, categoryLabel } from '../i18n.js'
import { formatMoney, formatDate } from '../format.js'
import { TopBar, EmptyState } from '../ui.jsx'

export function History({ nav }) {
  const { state } = useStore()
  const t = makeT(state.settings.lang)
  const lang = state.settings.lang
  const fmt = (n) => formatMoney(n, state.settings.currency, lang)

  return (
    <div className="screen has-nav">
      <TopBar title={t('history')} />
      {state.months.length === 0 ? (
        <EmptyState emoji="☷" desc={t('historyEmpty')} />
      ) : (
        <ul className="list">
          {state.months.map((m) => (
            <li key={m.id} className="row" onClick={() => nav.go('monthView', { monthId: m.id })} style={{ cursor: 'pointer' }}>
              <div className="row-main">
                <div className="row-title">{m.name || monthLabel(lang, m.month, m.year)}</div>
                <div className="row-sub">{monthLabel(lang, m.month, m.year)} · <span className={`badge ${m.status}`}>{m.status === 'open' ? t('open') : t('closed')}</span></div>
              </div>
              <div className="row-amount">{fmt(available(m))}</div>
              <span style={{ color: 'var(--muted)', fontSize: 20 }}>›</span>
            </li>
          ))}
        </ul>
      )}
    </div>
  )
}

export function MonthView({ nav, params }) {
  const { state } = useStore()
  const t = makeT(state.settings.lang)
  const lang = state.settings.lang
  const m = state.months.find((x) => x.id === params.monthId)
  const fmt = (n) => formatMoney(n, state.settings.currency, lang)
  if (!m) return null

  return (
    <div className="screen has-nav">
      <TopBar title={m.name || monthLabel(lang, m.month, m.year)} sub={monthLabel(lang, m.month, m.year)} onBack={nav.back} />
      {m.status === 'closed' && <div className="readonly-banner">🔒 {t('readOnly')}</div>}

      <div className="grid-2">
        <div className="card kpi"><span className="label">{t('income')}</span><span className="value">{fmt(totalIncome(m))}</span></div>
        <div className="card kpi"><span className="label">{t('fixedExpenses')}</span><span className="value">{fmt(totalFixed(m))}</span></div>
        <div className="card kpi"><span className="label">{t('savingsGoal')}</span><span className="value">{fmt(m.savingsGoal)}</span></div>
        <div className="card kpi accent"><span className="label">{t('availableToSpend')}</span><span className="value">{fmt(available(m))}</span></div>
      </div>

      <div className="section-title">{t('weeks')}</div>
      {m.weeks.length === 0 ? (
        <p className="hint">{t('noWeeks')}</p>
      ) : m.weeks.map((w) => (
        <div className="cat" key={w.id}>
          <div className="cat-head">
            <span className="cat-name">{t('weekN', w.index)}</span>
            <span className="cat-diff pos">{fmt(weekTotal(w))}</span>
          </div>
          <div className="cat-nums" style={{ flexWrap: 'wrap', gap: 12 }}>
            {CATEGORIES.map((c) => (
              <div className="n" key={c}>
                <span className="k">{CATEGORY_META[c].emoji} {categoryLabel(lang, c)}</span>
                <span className="v" style={{ fontSize: 14 }}>{fmt(actualByCategory(w, c))}</span>
              </div>
            ))}
          </div>
          {w.reflection?.proudOf && <p className="hint" style={{ marginBottom: 0, marginTop: 10 }}>“{w.reflection.proudOf}”</p>}
        </div>
      ))}

      {m.reflection && (
        <>
          <div className="section-title">{t('reflection')}</div>
          <div className="card">
            <Line k={t('qHad')} v={fmt(m.reflection.had)} />
            <Line k={t('qWanted')} v={fmt(m.reflection.wantedToSave)} />
            <Line k={t('qSpent')} v={fmt(m.reflection.actuallySpent)} />
            {m.reflection.improveNext && <p className="hint" style={{ margin: '10px 0 0' }}>“{m.reflection.improveNext}”</p>}
          </div>
        </>
      )}
    </div>
  )
}

function Line({ k, v }) {
  return (
    <div style={{ display: 'flex', justifyContent: 'space-between', padding: '7px 0', borderBottom: '1px solid var(--line)' }}>
      <span style={{ color: 'var(--muted)', fontWeight: 700, fontSize: 13.5 }}>{k}</span>
      <span style={{ fontWeight: 800 }}>{v}</span>
    </div>
  )
}
