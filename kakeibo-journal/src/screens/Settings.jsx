import { useStore } from '../store.jsx'
import { makeT } from '../i18n.js'
import { TopBar } from '../ui.jsx'

const CURRENCIES = ['AED', 'SAR', 'EGP', 'USD', 'EUR', 'KWD', 'QAR', 'BHD', 'OMR']

export function Settings() {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)

  const reset = () => {
    if (window.confirm(t('resetConfirm'))) actions.resetAll()
  }

  return (
    <div className="screen has-nav">
      <TopBar title={t('settings')} />

      <div className="section-title">{t('language')}</div>
      <div className="btn-row">
        <button className={`btn ${state.settings.lang === 'ar' ? '' : 'secondary'}`} onClick={() => actions.setLang('ar')}>العربية</button>
        <button className={`btn ${state.settings.lang === 'en' ? '' : 'secondary'}`} onClick={() => actions.setLang('en')}>English</button>
      </div>

      <div className="section-title">{t('currency')}</div>
      <select className="input" value={state.settings.currency} onChange={(e) => actions.setCurrency(e.target.value)}>
        {CURRENCIES.map((c) => <option key={c} value={c}>{c}</option>)}
      </select>

      <div className="section-title">{t('about')}</div>
      <div className="card">
        <p className="hint" style={{ margin: 0 }}>{t('aboutText')}</p>
      </div>

      <div className="primary-dock">
        <button className="btn danger" onClick={reset}>{t('resetAll')}</button>
      </div>
    </div>
  )
}
