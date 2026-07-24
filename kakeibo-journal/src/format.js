// Money formatting: number grouped + currency code appended (e.g. "1,200 AED").
export function formatMoney(amount, currency, lang) {
  const n = Number(amount) || 0
  // Latin digits in both languages to match the paper journal ("120 AED") and stay readable.
  const locale = lang === 'ar' ? 'ar-EG-u-nu-latn' : 'en-US'
  const num = new Intl.NumberFormat(locale, { maximumFractionDigits: 2 }).format(n)
  return `${num} ${currency}`
}

export function todayISO() {
  const d = new Date()
  const off = d.getTimezoneOffset()
  return new Date(d.getTime() - off * 60000).toISOString().slice(0, 10)
}

export function formatDate(iso, lang) {
  if (!iso) return ''
  const d = new Date(iso + 'T00:00:00')
  if (Number.isNaN(d.getTime())) return iso
  return new Intl.DateTimeFormat(lang === 'ar' ? 'ar-EG-u-nu-latn' : 'en-GB', { day: 'numeric', month: 'short' }).format(d)
}
