// Bilingual dictionary. Categories keep their canonical Kakeibo keys internally;
// only the display label changes per language.
export const CATEGORIES = ['Needs', 'Wants', 'Culture', 'Unexpected']

export const CATEGORY_META = {
  Needs: { color: 'var(--needs)', emoji: '🏠' },
  Wants: { color: 'var(--wants)', emoji: '✨' },
  Culture: { color: 'var(--culture)', emoji: '📚' },
  Unexpected: { color: 'var(--unexpected)', emoji: '🌂' },
}

export const MONTH_NAMES = {
  ar: ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو', 'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر'],
  en: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
}

const DICT = {
  ar: {
    appName: 'Kakeibo Journal',
    tagline: 'فكّر قبل أن تصرف',

    // language / onboarding
    chooseLanguage: 'اختر اللغة',
    arabic: 'العربية',
    english: 'الإنجليزية',
    ob1Title: 'ما هو كاكيبو؟',
    ob1Body: 'دفتر ياباني بسيط يساعدك على الوعي بمصروفاتك، لتفكّر قبل أن تصرف — لا محاسبة معقّدة، فقط عادة هادئة.',
    ob2Title: 'كيف يعمل؟',
    ob2Body: 'في بداية كل شهر تكتب دخلك ومصاريفك الثابتة وهدف ادخارك، ثم تخطّط كل أسبوع وتسجّل مصروفاتك اليومية.',
    ob3Title: 'ابدأ أول شهر',
    ob3Body: 'كل شهر رحلة تبدأ وتنتهي. جاهز لبدء شهرك الأول؟',
    skip: 'تخطّي',
    next: 'التالي',
    start: 'ابدأ',
    getStarted: 'ابدأ أول شهر',

    // create month
    createMonth: 'إنشاء شهر',
    newMonth: 'شهر جديد',
    monthNameField: 'اسم الشهر (اختياري)',
    monthNamePh: 'مثال: شهر التوفير',
    month: 'الشهر',
    year: 'السنة',
    savingsGoal: 'هدف الادخار',
    create: 'إنشاء الشهر',

    // home
    income: 'الدخل',
    fixedExpenses: 'المصاريف الثابتة',
    availableToSpend: 'المتاح للإنفاق',
    startFirstWeek: 'ابدأ الأسبوع الأول',
    continueWeek: 'أكمل الأسبوع',
    noOpenMonth: 'لا يوجد شهر مفتوح',
    noOpenMonthDesc: 'أنشئ شهراً جديداً لتبدأ رحلتك.',

    // income / fixed
    addIncome: 'إضافة دخل',
    addFixed: 'إضافة مصروف ثابت',
    itemName: 'الاسم',
    itemNamePh: 'مثال: الراتب',
    fixedNamePh: 'مثال: الإيجار',
    amount: 'المبلغ',
    add: 'إضافة',
    total: 'الإجمالي',
    incomeEmpty: 'ابدأ بإضافة أول دخل.',
    fixedEmpty: 'ابدأ بإضافة أول مصروف ثابت.',
    editSavings: 'هدف الادخار',
    save: 'حفظ',

    // weeks
    weeks: 'الأسابيع',
    week: 'أسبوع',
    weekN: (n) => `الأسبوع ${n}`,
    planned: 'المخطط',
    actual: 'الفعلي',
    difference: 'الفرق',
    addExpense: 'إضافة مصروف',
    setBudgets: 'تحديد ميزانية الأسابيع',
    weekBudgetHint: 'حدّد ميزانية كل فئة لهذا الأسبوع.',
    noWeeks: 'لم تبدأ أي أسبوع بعد.',
    startWeek: 'ابدأ الأسبوع',
    weekLog: 'سجل الأسبوع',
    viewLog: 'عرض السجل',
    endWeek: 'إنهاء الأسبوع',
    expensesEmpty: 'ابدأ بإضافة أول مصروف.',

    // add expense
    date: 'التاريخ',
    item: 'البند',
    itemPh: 'مثال: مشتريات منزل',
    category: 'الفئة',
    saved: 'تم الحفظ',

    // week end
    weekTotal: 'إجمالي الأسبوع',
    proudQuestion: 'ما الشيء الذي تفتخر به هذا الأسبوع؟',
    proudPh: 'اكتب شيئاً صغيراً تفخر به…',
    nextWeek: 'الأسبوع التالي',

    // month end
    endMonth: 'نهاية الشهر',
    reflection: 'التأمل',
    qHad: 'كم كان لديّ من المال؟',
    qWanted: 'كم أردت أن أدخر؟',
    qSpent: 'كم أنفقت بالفعل؟',
    qImprove: 'ما الذي سأحسّنه الشهر القادم؟',
    qImprovePh: 'اكتب ما ستحسّنه…',
    closeMonth: 'إغلاق الشهر',
    startNewMonth: 'بدء شهر جديد',
    monthClosed: 'تم إغلاق الشهر',

    // history / settings
    history: 'الأشهر',
    home: 'الرئيسية',
    settings: 'الإعدادات',
    historyEmpty: 'لا توجد أشهر بعد.',
    readOnly: 'هذا الشهر مغلق — للقراءة فقط.',
    open: 'مفتوح',
    closed: 'مغلق',
    language: 'اللغة',
    currency: 'العملة',
    about: 'عن التطبيق',
    aboutText: 'دفتر كاكيبو رقمي بسيط. كل بياناتك محفوظة على جهازك فقط.',
    resetAll: 'حذف كل البيانات',
    resetConfirm: 'سيتم حذف كل الأشهر والمصروفات نهائياً. متابعة؟',

    // misc
    back: 'رجوع',
    cancel: 'إلغاء',
    delete: 'حذف',
    required: 'هذا الحقل مطلوب',
    mustBePositive: 'أدخل مبلغاً أكبر من صفر',
    confirmDelete: 'حذف هذا العنصر؟',
    of: 'من',
    remaining: 'المتبقي',
    overspent: 'تجاوز',
  },

  en: {
    appName: 'Kakeibo Journal',
    tagline: 'Think before you spend',

    chooseLanguage: 'Choose language',
    arabic: 'Arabic',
    english: 'English',
    ob1Title: 'What is Kakeibo?',
    ob1Body: 'A simple Japanese journal that builds awareness of your spending — no complex accounting, just a calm habit.',
    ob2Title: 'How does it work?',
    ob2Body: 'At the start of each month you note your income, fixed costs and savings goal, then plan each week and log daily spending.',
    ob3Title: 'Start your first month',
    ob3Body: 'Every month is a journey that begins and ends. Ready to start your first one?',
    skip: 'Skip',
    next: 'Next',
    start: 'Start',
    getStarted: 'Start first month',

    createMonth: 'Create month',
    newMonth: 'New month',
    monthNameField: 'Month name (optional)',
    monthNamePh: 'e.g. Saving month',
    month: 'Month',
    year: 'Year',
    savingsGoal: 'Savings goal',
    create: 'Create month',

    income: 'Income',
    fixedExpenses: 'Fixed expenses',
    availableToSpend: 'Available to spend',
    startFirstWeek: 'Start first week',
    continueWeek: 'Continue week',
    noOpenMonth: 'No open month',
    noOpenMonthDesc: 'Create a new month to begin your journey.',

    addIncome: 'Add income',
    addFixed: 'Add fixed expense',
    itemName: 'Name',
    itemNamePh: 'e.g. Salary',
    fixedNamePh: 'e.g. Rent',
    amount: 'Amount',
    add: 'Add',
    total: 'Total',
    incomeEmpty: 'Add your first income to begin.',
    fixedEmpty: 'Add your first fixed expense.',
    editSavings: 'Savings goal',
    save: 'Save',

    weeks: 'Weeks',
    week: 'Week',
    weekN: (n) => `Week ${n}`,
    planned: 'Planned',
    actual: 'Actual',
    difference: 'Difference',
    addExpense: 'Add expense',
    setBudgets: 'Set week budgets',
    weekBudgetHint: 'Set a budget for each category this week.',
    noWeeks: 'No week started yet.',
    startWeek: 'Start week',
    weekLog: 'Week log',
    viewLog: 'View log',
    endWeek: 'End week',
    expensesEmpty: 'Add your first expense.',

    date: 'Date',
    item: 'Item',
    itemPh: 'e.g. Household shopping',
    category: 'Category',
    saved: 'Saved',

    weekTotal: 'Week total',
    proudQuestion: 'What are you proud of this week?',
    proudPh: 'Write one small thing you are proud of…',
    nextWeek: 'Next week',

    endMonth: 'End of month',
    reflection: 'Reflection',
    qHad: 'How much money did I have?',
    qWanted: 'How much did I want to save?',
    qSpent: 'How much did I actually spend?',
    qImprove: 'What will I improve next month?',
    qImprovePh: 'Write what you will improve…',
    closeMonth: 'Close month',
    startNewMonth: 'Start new month',
    monthClosed: 'Month closed',

    history: 'History',
    home: 'Home',
    settings: 'Settings',
    historyEmpty: 'No months yet.',
    readOnly: 'This month is closed — read only.',
    open: 'Open',
    closed: 'Closed',
    language: 'Language',
    currency: 'Currency',
    about: 'About',
    aboutText: 'A simple digital Kakeibo journal. All your data stays on your device only.',
    resetAll: 'Delete all data',
    resetConfirm: 'This permanently deletes all months and expenses. Continue?',

    back: 'Back',
    cancel: 'Cancel',
    delete: 'Delete',
    required: 'This field is required',
    mustBePositive: 'Enter an amount greater than zero',
    confirmDelete: 'Delete this item?',
    of: 'of',
    remaining: 'Remaining',
    overspent: 'Over',
  },
}

export function makeT(lang) {
  const d = DICT[lang] || DICT.ar
  return (key, ...args) => {
    const v = d[key]
    return typeof v === 'function' ? v(...args) : (v ?? key)
  }
}

export function monthLabel(lang, monthIndex, year) {
  const names = MONTH_NAMES[lang] || MONTH_NAMES.ar
  return `${names[monthIndex] ?? ''} ${year}`
}

export function categoryLabel(lang, key) {
  if (lang === 'en') return key
  const map = { Needs: 'ضروريات', Wants: 'رغبات', Culture: 'ثقافة', Unexpected: 'غير متوقع' }
  return map[key] || key
}
