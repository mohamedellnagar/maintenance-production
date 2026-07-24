import { createContext, useContext, useEffect, useMemo, useRef, useState } from 'react'
import { CATEGORIES } from './i18n.js'

const STORAGE_KEY = 'kakeibo.journal.v1'

const DEFAULT_STATE = {
  onboarded: false,
  settings: { lang: 'ar', currency: 'AED' },
  months: [],
  activeMonthId: null,
}

function uid(prefix) {
  return `${prefix}_${Date.now().toString(36)}_${Math.random().toString(36).slice(2, 8)}`
}

function emptyBudgets() {
  return CATEGORIES.reduce((acc, c) => ((acc[c] = 0), acc), {})
}

function load() {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    if (!raw) return DEFAULT_STATE
    const parsed = JSON.parse(raw)
    return { ...DEFAULT_STATE, ...parsed, settings: { ...DEFAULT_STATE.settings, ...parsed.settings } }
  } catch {
    return DEFAULT_STATE
  }
}

// ---- Pure selectors (also used by history views) ----
export const sum = (arr, pick) => arr.reduce((t, x) => t + (Number(pick ? pick(x) : x) || 0), 0)
export const totalIncome = (m) => sum(m?.income || [], (x) => x.amount)
export const totalFixed = (m) => sum(m?.fixed || [], (x) => x.amount)
export const available = (m) => totalIncome(m) - totalFixed(m) - (Number(m?.savingsGoal) || 0)
export const weekTotal = (w) => sum(w?.expenses || [], (x) => x.amount)
export const actualByCategory = (w, cat) => sum((w?.expenses || []).filter((e) => e.category === cat), (x) => x.amount)
export const activeMonth = (s) => s.months.find((m) => m.id === s.activeMonthId) || null

const StoreCtx = createContext(null)

export function StoreProvider({ children }) {
  const [state, setState] = useState(load)
  const first = useRef(true)

  useEffect(() => {
    // Persist on every change (skip nothing — first write keeps defaults safe too).
    if (first.current) { first.current = false }
    try { localStorage.setItem(STORAGE_KEY, JSON.stringify(state)) } catch { /* storage full / disabled */ }
  }, [state])

  // Keep <html> lang/dir in sync with the chosen language.
  useEffect(() => {
    const lang = state.settings.lang
    document.documentElement.lang = lang
    document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr'
  }, [state.settings.lang])

  const actions = useMemo(() => {
    const patchMonth = (monthId, fn) =>
      setState((s) => ({
        ...s,
        months: s.months.map((m) => (m.id === monthId ? fn(m) : m)),
      }))

    const patchWeek = (monthId, weekId, fn) =>
      patchMonth(monthId, (m) => ({
        ...m,
        weeks: m.weeks.map((w) => (w.id === weekId ? fn(w) : w)),
      }))

    return {
      setLang: (lang) => setState((s) => ({ ...s, settings: { ...s.settings, lang } })),
      setCurrency: (currency) => setState((s) => ({ ...s, settings: { ...s.settings, currency } })),

      completeOnboarding: () => setState((s) => ({ ...s, onboarded: true })),

      createMonth: ({ name, month, year, savingsGoal }) => {
        const id = uid('m')
        setState((s) => ({
          ...s,
          onboarded: true,
          activeMonthId: id,
          months: [
            {
              id,
              name: (name || '').trim(),
              month: Number(month),
              year: Number(year),
              savingsGoal: Number(savingsGoal) || 0,
              status: 'open',
              income: [],
              fixed: [],
              weeks: [],
              reflection: null,
              createdAt: Date.now(),
            },
            ...s.months,
          ],
        }))
        return id
      },

      setSavingsGoal: (monthId, savingsGoal) =>
        patchMonth(monthId, (m) => ({ ...m, savingsGoal: Number(savingsGoal) || 0 })),

      addIncome: (monthId, item) =>
        patchMonth(monthId, (m) => ({ ...m, income: [...m.income, { id: uid('i'), name: item.name.trim(), amount: Number(item.amount) }] })),
      deleteIncome: (monthId, itemId) =>
        patchMonth(monthId, (m) => ({ ...m, income: m.income.filter((x) => x.id !== itemId) })),

      addFixed: (monthId, item) =>
        patchMonth(monthId, (m) => ({ ...m, fixed: [...m.fixed, { id: uid('f'), name: item.name.trim(), amount: Number(item.amount) }] })),
      deleteFixed: (monthId, itemId) =>
        patchMonth(monthId, (m) => ({ ...m, fixed: m.fixed.filter((x) => x.id !== itemId) })),

      addWeek: (monthId) => {
        let newId = null
        patchMonth(monthId, (m) => {
          newId = uid('w')
          return { ...m, weeks: [...m.weeks, { id: newId, index: m.weeks.length + 1, budgets: emptyBudgets(), expenses: [], reflection: null, closed: false }] }
        })
        return newId
      },
      setWeekBudget: (monthId, weekId, category, value) =>
        patchWeek(monthId, weekId, (w) => ({ ...w, budgets: { ...w.budgets, [category]: Number(value) || 0 } })),

      addExpense: (monthId, weekId, exp) =>
        patchWeek(monthId, weekId, (w) => ({
          ...w,
          expenses: [...w.expenses, { id: uid('e'), date: exp.date, item: exp.item.trim(), category: exp.category, amount: Number(exp.amount) }],
        })),
      deleteExpense: (monthId, weekId, expId) =>
        patchWeek(monthId, weekId, (w) => ({ ...w, expenses: w.expenses.filter((e) => e.id !== expId) })),

      closeWeek: (monthId, weekId, proudOf) =>
        patchWeek(monthId, weekId, (w) => ({ ...w, closed: true, reflection: { proudOf: (proudOf || '').trim() } })),

      closeMonth: (monthId, reflection) =>
        setState((s) => ({
          ...s,
          activeMonthId: s.activeMonthId === monthId ? null : s.activeMonthId,
          months: s.months.map((m) => (m.id === monthId ? { ...m, status: 'closed', reflection } : m)),
        })),

      resetAll: () => setState({ ...DEFAULT_STATE }),
    }
  }, [])

  const value = useMemo(() => ({ state, actions }), [state])
  return <StoreCtx.Provider value={value}>{children}</StoreCtx.Provider>
}

export function useStore() {
  const ctx = useContext(StoreCtx)
  if (!ctx) throw new Error('useStore must be used within StoreProvider')
  return ctx
}
