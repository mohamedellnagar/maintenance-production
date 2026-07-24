import { useEffect, useState } from 'react'
import { useStore } from '../store.jsx'
import { makeT } from '../i18n.js'
import { CreateMonthForm } from './Month.jsx'

export function Splash({ onDone }) {
  const { state } = useStore()
  const t = makeT(state.settings.lang)
  useEffect(() => {
    const timer = setTimeout(onDone, 1500)
    return () => clearTimeout(timer)
  }, [onDone])
  return (
    <div className="splash">
      <div className="logo">✒</div>
      <h1>{t('appName')}</h1>
      <p>{t('tagline')}</p>
    </div>
  )
}

// One controlled flow: language → 3 pages → create first month.
export function Onboarding() {
  const { state, actions } = useStore()
  const [step, setStep] = useState(0) // 0 = language, 1..3 = pages, 4 = create month
  const t = makeT(state.settings.lang)

  if (step === 0) {
    return (
      <div className="onboard">
        <div className="art"><div className="big">✒️</div></div>
        <h2>{t('chooseLanguage')}</h2>
        <div className="lang-choice">
          <button className="lang-btn" onClick={() => { actions.setLang('ar'); setStep(1) }}>
            <span className="flag">🇸🇦</span> {t('arabic')}
          </button>
          <button className="lang-btn" onClick={() => { actions.setLang('en'); setStep(1) }}>
            <span className="flag">🇬🇧</span> {t('english')}
          </button>
        </div>
      </div>
    )
  }

  if (step >= 1 && step <= 3) {
    const pages = [
      { emoji: '📔', title: t('ob1Title'), body: t('ob1Body') },
      { emoji: '🗓️', title: t('ob2Title'), body: t('ob2Body') },
      { emoji: '🌱', title: t('ob3Title'), body: t('ob3Body') },
    ]
    const p = pages[step - 1]
    const last = step === 3
    return (
      <div className="onboard">
        <div className="art"><div className="big">{p.emoji}</div></div>
        <h2>{p.title}</h2>
        <p>{p.body}</p>
        <div className="dots">
          {pages.map((_, i) => <span key={i} className={i === step - 1 ? 'on' : ''} />)}
        </div>
        <div className="btn-row">
          {!last && <button className="btn secondary" onClick={() => setStep(4)}>{t('skip')}</button>}
          <button className="btn" onClick={() => (last ? setStep(4) : setStep(step + 1))}>
            {last ? t('getStarted') : t('next')}
          </button>
        </div>
      </div>
    )
  }

  // step 4: create first month (also flips onboarded → true via createMonth)
  return <CreateMonthForm firstTime />
}
