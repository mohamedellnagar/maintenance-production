import { useEffect, useMemo, useState } from 'react'
import { Capacitor } from '@capacitor/core'
import { App as CapApp } from '@capacitor/app'
import { useStore } from './store.jsx'
import { makeT } from './i18n.js'
import { BottomNav } from './ui.jsx'
import { Splash, Onboarding } from './screens/Onboarding.jsx'
import { Home, IncomeScreen, FixedScreen, SavingsScreen, MonthEnd } from './screens/Month.jsx'
import { WeeksList, WeekScreen, AddExpense, WeekLog, WeekEnd } from './screens/Week.jsx'
import { History, MonthView } from './screens/History.jsx'
import { Settings } from './screens/Settings.jsx'

const TAB_ROOT = { home: Home, weeks: WeeksList, history: History, settings: Settings }
const PUSHED = {
  income: IncomeScreen,
  fixed: FixedScreen,
  savings: SavingsScreen,
  monthEnd: MonthEnd,
  week: WeekScreen,
  addExpense: AddExpense,
  weekLog: WeekLog,
  weekEnd: WeekEnd,
  monthView: MonthView,
}

export default function App() {
  const { state, actions } = useStore()
  const t = makeT(state.settings.lang)
  const [splashDone, setSplashDone] = useState(false)
  const [tab, setTab] = useState('home')
  const [stack, setStack] = useState([]) // screens pushed over the current tab root

  const nav = useMemo(() => ({
    go: (name, params = {}) => setStack((s) => [...s, { name, params }]),
    replace: (name, params = {}) => setStack((s) => [...s.slice(0, -1), { name, params }]),
    back: () => setStack((s) => s.slice(0, -1)),
    tab: (name) => { setTab(name); setStack([]) },
    startWeek: () => actions.addWeek(state.activeMonthId),
  }), [actions, state.activeMonthId])

  const onTab = (name) => { setTab(name); setStack([]) }

  // Android hardware back button: pop the nav stack, then fall back to Home, then exit.
  useEffect(() => {
    if (!Capacitor.isNativePlatform()) return
    let handle
    CapApp.addListener('backButton', () => {
      if (stack.length) setStack((s) => s.slice(0, -1))
      else if (tab !== 'home') onTab('home')
      else CapApp.exitApp()
    }).then((h) => { handle = h })
    return () => { handle && handle.remove() }
  }, [stack, tab])

  if (!splashDone) {
    return <div className="phone"><Splash onDone={() => setSplashDone(true)} /></div>
  }

  if (!state.onboarded) {
    return <div className="phone"><Onboarding /></div>
  }

  const current = stack.length ? stack[stack.length - 1] : { name: tab, params: {} }
  const Screen = TAB_ROOT[current.name] || PUSHED[current.name] || Home

  return (
    <div className="phone">
      <Screen nav={nav} params={current.params || {}} />
      <BottomNav tab={tab} onTab={onTab} t={t} />
    </div>
  )
}
