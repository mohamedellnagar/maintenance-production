import React,{useEffect,useMemo,useState,useCallback,useRef}from'react';import{createRoot}from'react-dom/client';import{Home,Users,Wrench,Building2,LayoutDashboard,FileText,Plus,Trash2,Edit,LogOut,Download,X,Mail,Lock,Eye,EyeOff,Loader2,ShieldCheck,Filter,RotateCcw,ClipboardList,Wallet,TrendingUp,Coins,Check,Settings as SettingsIcon,UserCheck,Banknote,ChevronRight,Calendar,DollarSign,ListChecks,AlertCircle,CheckCircle2,Clock,ChevronDown,RefreshCw,Activity,KeyRound,BarChart2,BedDouble,DoorOpen,ArrowUpRight,ArrowDownRight,Zap,Upload,FileSpreadsheet,CheckSquare,Printer,MapPin,Phone,CreditCard,ArrowRight,Shield,Droplet}from'lucide-react';import{BarChart,Bar,XAxis,YAxis,Tooltip,ResponsiveContainer,CartesianGrid,LabelList,AreaChart,Area}from'recharts';import'./style.css';
const API=import.meta.env.VITE_API_URL||(location.hostname==='localhost'?'http://localhost:4000/api':'/api');
const AR_MONTHS=['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];

let toastListeners=[];
function showToast(msg,type='success'){toastListeners.forEach(l=>l(msg,type))}
function useToastFeed(){const[toasts,setToasts]=useState([]);useEffect(()=>{const l=(msg,type)=>{const id=Date.now()+Math.random();setToasts(t=>[...t,{id,msg,type}]);setTimeout(()=>setToasts(t=>t.filter(x=>x.id!==id)),3500)};toastListeners.push(l);return()=>{toastListeners=toastListeners.filter(x=>x!==l)}},[]);return toasts}
function Toaster(){const toasts=useToastFeed();return <div className="toasts">{toasts.map(t=><div key={t.id} className={'toast '+t.type}>{t.msg}</div>)}</div>}

function useApi(){const token=localStorage.token;return async(path,opts={})=>{const r=await fetch(API+path,{...opts,headers:{'Content-Type':'application/json',Authorization:'Bearer '+token,...opts.headers}});if(r.status===401){localStorage.clear();location.reload();return new Promise(()=>{})}const j=await r.json().catch(()=>({}));if(!r.ok)throw new Error(j.message||'حدث خطأ غير متوقع');return j.data}}

async function runAction(fn,successMsg){try{await fn();if(successMsg)showToast(successMsg,'success')}catch(e){showToast(e.message||'فشلت العملية','error')}}

const IS_DEV=location.hostname==='localhost';
const LOGIN_FEATURES=[[Building2,'إدارة الفلل والشقق بشكل مركزي'],[Wrench,'تتبع كشوف الصيانة والفنيين'],[LayoutDashboard,'لوحة تحكم ومؤشرات أداء لحظية']];
function Login({onOk}){const[form,setForm]=useState(IS_DEV?{email:'admin@maintenance.local',password:'Admin@12345'}:{email:'',password:''});const[err,setErr]=useState('');const[busy,setBusy]=useState(false);const[showPwd,setShowPwd]=useState(false);async function login(e){e.preventDefault();setErr('');setBusy(true);try{const r=await fetch(API+'/auth/login',{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify(form)});const j=await r.json();if(!r.ok)throw new Error(j.message);localStorage.token=j.data.token;localStorage.user=JSON.stringify(j.data.user);onOk(j.data.user)}catch(e){setErr('بيانات الدخول غير صحيحة')}finally{setBusy(false)}}
return <div className="login">
  <div className="loginShell">
    <div className="loginBrandPanel">
      <div className="loginBrandTop"><div className="logo logoLight"><Building2 size={22}/>Maintenance<span>Pro</span></div></div>
      <div className="loginBrandMid">
        <h1>نظام متكامل لإدارة<br/>أعمال الصيانة اليومية</h1>
        <p>تابع كشوف الصيانة، الفنيين، والفلل والشقق من مكان واحد، بأداء سريع وواجهة عربية كاملة.</p>
        <ul className="loginFeatures">{LOGIN_FEATURES.map(([Icon,label],i)=><li key={i}><span className="loginFeatureIcon"><Icon size={16}/></span>{label}</li>)}</ul>
      </div>
      <div className="loginBrandBottom"><ShieldCheck size={15}/> بياناتك محمية ومشفّرة</div>
    </div>
    <div className="loginFormPanel">
      <form onSubmit={login} className="loginCard">
        <h2>تسجيل الدخول</h2>
        <small className="loginSub">أدخل بياناتك للوصول إلى لوحة التحكم</small>
        <Field label="البريد الإلكتروني" required>
          <div className="inputIcon"><Mail size={16}/><input required type="email" placeholder="name@company.com" value={form.email} onChange={e=>setForm({...form,email:e.target.value})}/></div>
        </Field>
        <Field label="كلمة المرور" required>
          <div className="inputIcon"><Lock size={16}/><input required type={showPwd?'text':'password'} placeholder="••••••••" value={form.password} onChange={e=>setForm({...form,password:e.target.value})}/><button type="button" className="pwdToggle" onClick={()=>setShowPwd(s=>!s)} aria-label="إظهار كلمة المرور">{showPwd?<EyeOff size={16}/>:<Eye size={16}/>}</button></div>
        </Field>
        {err&&<p className="err">{err}</p>}
        <button disabled={busy}>{busy?<><Loader2 size={16} className="spin"/>جارٍ الدخول...</>:'دخول النظام'}</button>
        {IS_DEV&&<div className="demoHint">Demo: admin@maintenance.local / Admin@12345</div>}
      </form>
    </div>
  </div>
</div>}

const ALL_PAGES=[['dashboard','لوحة التحكم',LayoutDashboard],['records','كشف الصيانة',FileText],['villas','الفلل',Building2],['apartments','الشقق',Home],['technicians','الفنيين',Wrench],['tenants_mgmt','المستأجرين',UserCheck],['leases','الإيجارات',Banknote],['payments_tracker','الدفعات',ListChecks]];
function PermissionsSettings(){const api=useApi();const[perms,setPerms]=useState(null);const[saving,setSaving]=useState(false);useEffect(()=>{api('/permissions').then(setPerms)},[]);
function toggle(pageId){if(pageId==='dashboard')return;setPerms({...perms,SUPERVISOR:perms.SUPERVISOR.includes(pageId)?perms.SUPERVISOR.filter(p=>p!==pageId):[...perms.SUPERVISOR,pageId]})}
async function save(){setSaving(true);await runAction(async()=>{await api('/permissions/SUPERVISOR',{method:'PUT',body:JSON.stringify({allowed_pages:perms.SUPERVISOR})})},'تم حفظ الصلاحيات');setSaving(false)}
if(!perms)return <Loader/>;
return <Panel title="صلاحيات الأدوار"><p className="permsHint">حدد الصفحات التي يمكن لدور <b>مشرف (SUPERVISOR)</b> الوصول إليها. دور الأدمن دائمًا له صلاحية كاملة.</p>
<div className="permsList">{ALL_PAGES.map(([id,label,Icon])=>{const checked=id==='dashboard'||perms.SUPERVISOR.includes(id);return <label key={id} className={'permsRow'+(id==='dashboard'?' permsRowLocked':'')}><input type="checkbox" checked={checked} disabled={id==='dashboard'} onChange={()=>toggle(id)}/><Icon size={16}/><span>{label}</span>{id==='dashboard'&&<small>(دائمًا متاحة)</small>}</label>})}</div>
<button onClick={save} disabled={saving}>{saving?'جارٍ الحفظ...':'حفظ الصلاحيات'}</button>
</Panel>}
function ImportData(){
  const api=useApi();
  const fileRef=useRef();
  const[file,setFile]=useState(null);
  const[preview,setPreview]=useState(null);
  const[loading,setLoading]=useState(false);
  const[result,setResult]=useState(null);
  const TABS=[['الفلل','villas'],['الشقق','apartments'],['المستأجرين','tenants'],['العقود','leases'],['الدفعات','installments']];
  const[tab,setTab]=useState('villas');

  async function loadPreview(f){
    setLoading(true);setPreview(null);setResult(null);
    try{
      const fd=new FormData();fd.append('file',f);
      const token=localStorage.token;
      const r=await fetch((import.meta.env.VITE_API_URL||(location.hostname==='localhost'?'http://localhost:4000/api':'/api'))+'/import/preview',{method:'POST',headers:{Authorization:'Bearer '+token},body:fd});
      const j=await r.json();
      if(!r.ok)throw new Error(j.message||'خطأ');
      setPreview(j.data);
    }catch(e){showToast(e.message,'error');}
    setLoading(false);
  }

  function onFile(e){const f=e.target.files[0];if(!f)return;setFile(f);loadPreview(f);}

  async function confirm(){
    if(!file)return;
    setLoading(true);
    try{
      const fd=new FormData();fd.append('file',file);
      const token=localStorage.token;
      const r=await fetch((import.meta.env.VITE_API_URL||(location.hostname==='localhost'?'http://localhost:4000/api':'/api'))+'/import/confirm',{method:'POST',headers:{Authorization:'Bearer '+token},body:fd});
      const j=await r.json();
      if(!r.ok)throw new Error(j.message||'خطأ');
      setResult(j.data);setPreview(null);setFile(null);
      showToast('تم الاستيراد بنجاح','success');
    }catch(e){showToast(e.message,'error');}
    setLoading(false);
  }

  const PREVIEW_COLS={
    villas:['اسم الفيلا *','المنطقة','ملاحظات'],
    apartments:['اسم الفيلا *','رقم الشقة *','نوع الشقة','عدد الحمامات','بلكونة (نعم/لا)','الدور'],
    tenants:['الاسم *','الهاتف','رقم الهوية','الإيميل'],
    leases:['اسم الفيلا *','رقم الشقة *','اسم المستأجر *','تاريخ البداية *','تاريخ النهاية *','إجمالي الإيجار *'],
    installments:['اسم الفيلا *','رقم الشقة *','اسم المستأجر *','تاريخ الاستحقاق *','المبلغ *','تاريخ الدفع (فارغ = لم يُدفع)'],
  };

  function downloadTemplate(){
    const token=localStorage.token;
    const base=import.meta.env.VITE_API_URL||(location.hostname==='localhost'?'http://localhost:4000/api':'/api');
    fetch(base+'/import/template',{headers:{Authorization:'Bearer '+token}})
      .then(r=>r.blob()).then(blob=>{const a=document.createElement('a');a.href=URL.createObjectURL(blob);a.download='نموذج_الاستيراد.xlsx';a.click();});
  }

  return <Panel title="استيراد البيانات">
    {result?<div className="importResult">
      <div className="importResultIcon"><CheckSquare size={48} color="#10b981"/></div>
      <h3>تم الاستيراد بنجاح</h3>
      <div className="importResultGrid">
        <div className="importResultItem"><span className="importResultNum">{result.villas}</span><span>فيلا</span></div>
        <div className="importResultItem"><span className="importResultNum">{result.apartments}</span><span>شقة</span></div>
        <div className="importResultItem"><span className="importResultNum">{result.tenants}</span><span>مستأجر</span></div>
        <div className="importResultItem"><span className="importResultNum">{result.leases}</span><span>عقد</span></div>
        <div className="importResultItem"><span className="importResultNum">{result.installments}</span><span>قسط/دفعة</span></div>
      </div>
      {result.skipped?.length>0&&<div className="importSkipped"><b>تم تجاهل ({result.skipped.length}):</b><ul>{result.skipped.map((s,i)=><li key={i}>{s}</li>)}</ul></div>}
      <button onClick={()=>setResult(null)}><Upload size={16}/>استيراد ملف آخر</button>
    </div>:
    <div className="importWrap">
      <div className="importTemplateBar">
        <div>
          <p className="importTemplateTitle">قبل الرفع — حمّل النموذج المعتمد</p>
          <small className="importTemplateSub">أدخل بياناتك في النموذج ثم ارفعه هنا. لا تغير أسماء الأعمدة أو الشيتات.</small>
        </div>
        <button className="secondary" onClick={downloadTemplate}><Download size={15}/>تحميل النموذج</button>
      </div>
      <div className="importDropZone" onClick={()=>fileRef.current.click()}>
        <FileSpreadsheet size={40} color="#10b981"/>
        <p>{file?file.name:'اضغط لرفع ملف Excel (.xlsx)'}</p>
        <small>الملف يجب أن يحتوي على الشيتات: الفلل، الشقق، المستأجرين، العقود، الدفعات</small>
        <input ref={fileRef} type="file" accept=".xlsx,.xls" style={{display:'none'}} onChange={onFile}/>
      </div>

      {loading&&<div className="importLoading"><Loader2 size={24} className="spin"/>جارٍ المعالجة...</div>}

      {preview&&<>
        {preview.errors?.length>0&&<div className="importErrors"><AlertCircle size={16}/> {preview.errors.length} أخطاء في الملف — يرجى تصحيحها قبل الاستيراد:<ul>{preview.errors.map((e,i)=><li key={i}>{e}</li>)}</ul></div>}

        <div className="importCounts">
          {TABS.map(([label,key])=><span key={key} className="importCountChip"><b>{preview.counts[key]}</b> {label}</span>)}
        </div>

        <div className="importTabs">
          {TABS.map(([label,key])=><button key={key} className={'importTab'+(tab===key?' active':'')} onClick={()=>setTab(key)}>{label} <span className="importTabCount">{preview[key]?.length||0}</span></button>)}
        </div>

        <div className="importTableWrap">
          {preview[tab]?.length===0?<p className="importEmpty">لا توجد بيانات في هذا الشيت</p>:
          <table className="importTable">
            <thead><tr>{PREVIEW_COLS[tab].map(c=><th key={c}>{c.replace(' *','')}</th>)}</tr></thead>
            <tbody>{preview[tab].map((row,i)=><tr key={i}>{PREVIEW_COLS[tab].map(c=><td key={c}>{String(row[c]??'')}</td>)}</tr>)}</tbody>
          </table>}
        </div>

        {preview.errors?.length===0&&
          <div className="importActions">
            <button onClick={confirm} disabled={loading}><CheckSquare size={16}/>تأكيد الاستيراد</button>
            <button className="secondary" onClick={()=>{setPreview(null);setFile(null);}}><X size={16}/>إلغاء</button>
          </div>}
      </>}
    </div>}
  </Panel>
}

function App(){const[user,setUser]=useState(()=>localStorage.user?JSON.parse(localStorage.user):null);const[page,setPage]=useState('dashboard');const isAdmin=user?.role==='ADMIN';const[perms,setPerms]=useState(null);const api=user?useApi():null;
useEffect(()=>{if(user)api('/permissions').then(setPerms)},[user?.id]);
if(!user)return <><Login onOk={setUser}/><Toaster/></>;
const logout=()=>{localStorage.clear();setUser(null)};
const allowedIds=isAdmin?ALL_PAGES.map(p=>p[0]):(perms?.SUPERVISOR||['dashboard']);
const items=ALL_PAGES.filter(p=>allowedIds.includes(p[0])).concat(isAdmin?[['users','المستخدمين',Users],['import','استيراد البيانات',Upload],['settings','الصلاحيات',SettingsIcon]]:[]);
const activePage=items.some(i=>i[0]===page)?page:'dashboard';
return <div className="app" dir="rtl"><aside><div className="logo">Maintenance<span>Pro</span></div>{items.map(([id,t,I])=><button key={id} className={activePage===id?'active':''} onClick={()=>setPage(id)}><I size={18}/>{t}</button>)}<button onClick={logout}><LogOut size={18}/>خروج</button></aside><main><header><div><h2>{items.find(i=>i[0]===activePage)?.[1]}</h2><p>نظام إدارة كشف الصيانة اليومي للفلل والشقق</p></div><div className="headerRight"><div className="user"><div className="userAvatar">{user.name?.[0]}</div><div className="userMeta"><span className="userName">{user.name}</span><span className={'roleBadge role-'+user.role}>{ROLE_LABELS[user.role]||user.role}</span></div></div><button className="mobileLogout" onClick={logout}><LogOut size={18}/></button></div></header>{activePage==='dashboard'&&<Dashboard/>}{activePage==='records'&&<Records/>}{activePage==='villas'&&<Villas user={user}/>}{activePage==='apartments'&&<Apartments user={user}/>}{activePage==='technicians'&&<Technicians user={user}/>}{activePage==='users'&&<UsersPage user={user}/>}{activePage==='tenants_mgmt'&&<TenantsMgmt user={user}/>}{activePage==='leases'&&<Leases user={user}/>}{activePage==='payments_tracker'&&<PaymentsTracker user={user}/>}{activePage==='settings'&&<PermissionsSettings/>}{activePage==='import'&&<ImportData/>}</main><nav className="mobileTabs">{items.map(([id,t,I])=><button key={id} className={activePage===id?'active':''} onClick={()=>setPage(id)}><I size={20}/><span>{t}</span></button>)}</nav><Toaster/></div>}

function monthStart(){const t=new Date();return new Date(t.getFullYear(),t.getMonth(),1).toISOString().slice(0,10)}
function todayStr(){return new Date().toISOString().slice(0,10)}
const DEFAULT_DASH_FILTERS={from:monthStart(),to:todayStr(),villa_id:'',technician_id:''};
function Dashboard(){
const api=useApi();
const[d,setD]=useState(null);
const[lastUpdated,setLastUpdated]=useState(null);
const[refreshing,setRefreshing]=useState(false);
const[tick,setTick]=useState(0);

const load=useCallback(async(isAuto=false)=>{
  if(!isAuto)setRefreshing(true);
  const data=await api('/dashboard');
  setD(data);setLastUpdated(new Date());
  if(!isAuto)setRefreshing(false);
},[]);

useEffect(()=>{load()},[]);
// auto-refresh every 60s
useEffect(()=>{const id=setInterval(()=>load(true),60000);return()=>clearInterval(id);},[load]);
// countdown tick
useEffect(()=>{const id=setInterval(()=>setTick(t=>(t+1)%60),1000);return()=>clearInterval(id);},[]);

if(!d)return <Loader/>;

const trendData=(d.monthlyTrend||[]).map(r=>{const[y,m]=r.mo.split('-');return{label:AR_MONTHS[parseInt(m,10)-1],cnt:Number(r.cnt),cost:Number(r.cost)};});

const overdueAmt=Number(d.installmentKpi?.overdue_amount||0);
const overdueCount=Number(d.installmentKpi?.overdue_count||0);
const collectedMonth=Number(d.installmentKpi?.collected_this_month||0);
const dueSoonAmt=Number(d.installmentKpi?.due_soon_amount||0);
const totalRented=Number(d.aptKpi?.rented||0);
const totalAvail=Number(d.aptKpi?.available||0);
const totalApts=Number(d.aptKpi?.total||0);
const occupancyPct=totalApts>0?Math.round(totalRented/totalApts*100):0;

const now=lastUpdated;
const timeStr=now?`${String(now.getHours()).padStart(2,'0')}:${String(now.getMinutes()).padStart(2,'0')}:${String(now.getSeconds()).padStart(2,'0')}`:'--:--:--';
const countdown=60-tick;

return <div className="dashRoot">

{/* Header */}
<div className="dashHeader">
  <div className="dashHeaderRight">
    <div className="dashHeaderTitle"><Zap size={20} className="dashHeaderIcon"/>لوحة التحكم</div>
    <span className="dashLiveChip"><span className="dashLiveDot"/>مباشر</span>
  </div>
  <div className="dashHeaderLeft">
    <span className="dashLastUpdated">آخر تحديث: {timeStr} · تحديث بعد {countdown}ث</span>
    <button className={'secondary dashRefreshBtn'+(refreshing?' dashRefreshSpin':'')} onClick={()=>load(false)}><RefreshCw size={14}/>تحديث</button>
  </div>
</div>

{/* KPI Row 1 — Maintenance */}
<div className="dashSectionLabel"><Activity size={13}/>الصيانة</div>
<div className="dashKpiRow">
  <div className="dashKpi dashKpi-teal">
    <div className="dashKpiIcon"><ClipboardList size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{d.today.records}</div>
      <div className="dashKpiLabel">أعمال اليوم</div>
    </div>
    <div className="dashKpiSub">الشهر: {d.month.records}</div>
  </div>
  <div className="dashKpi dashKpi-amber">
    <div className="dashKpiIcon"><Wallet size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{Number(d.today.cost).toLocaleString()}</div>
      <div className="dashKpiLabel">تكلفة اليوم AED</div>
    </div>
    <div className="dashKpiSub">الشهر: {Number(d.month.cost).toLocaleString()}</div>
  </div>
  <div className="dashKpi dashKpi-blue">
    <div className="dashKpiIcon"><Users size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{(d.byTech||[]).filter(t=>t.total>0).length}</div>
      <div className="dashKpiLabel">فنيين نشطون</div>
    </div>
    <div className="dashKpiSub">الإجمالي: {(d.byTech||[]).length}</div>
  </div>
  <div className="dashKpi dashKpi-purple">
    <div className="dashKpiIcon"><Building2 size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{(d.byVilla||[]).filter(v=>v.total>0).length}</div>
      <div className="dashKpiLabel">فلل بها أعمال</div>
    </div>
    <div className="dashKpiSub">الإجمالي: {(d.byVilla||[]).length}</div>
  </div>
</div>

{/* KPI Row 2 — Financial */}
<div className="dashSectionLabel"><DollarSign size={13}/>الإيجارات والمالية</div>
<div className="dashKpiRow">
  <div className={'dashKpi'+(overdueAmt>0?' dashKpi-danger':' dashKpi-green')}>
    <div className="dashKpiIcon"><AlertCircle size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{overdueAmt.toLocaleString()}</div>
      <div className="dashKpiLabel">متأخر AED</div>
    </div>
    <div className="dashKpiSub">{overdueCount} دفعة</div>
    {overdueAmt>0&&<div className="dashKpiAlert"/>}
  </div>
  <div className="dashKpi dashKpi-green">
    <div className="dashKpiIcon"><CheckCircle2 size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{collectedMonth.toLocaleString()}</div>
      <div className="dashKpiLabel">محصّل هذا الشهر AED</div>
    </div>
    <div className="dashKpiSub">الإجمالي: {Number(d.installmentKpi?.collected_total||0).toLocaleString()}</div>
  </div>
  <div className="dashKpi dashKpi-amber">
    <div className="dashKpiIcon"><Clock size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{dueSoonAmt.toLocaleString()}</div>
      <div className="dashKpiLabel">قيد التحصيل AED</div>
    </div>
    <div className="dashKpiSub">خلال 30 يوم</div>
  </div>
  <div className="dashKpi dashKpi-blue">
    <div className="dashKpiIcon"><Banknote size={20}/></div>
    <div className="dashKpiBody">
      <div className="dashKpiVal">{d.leaseKpi?.active_leases||0}</div>
      <div className="dashKpiLabel">عقود نشطة</div>
    </div>
    <div className="dashKpiSub">الإجمالي: {d.leaseKpi?.total_leases||0}</div>
  </div>
</div>

{/* KPI Row 3 — Occupancy */}
<div className="dashSectionLabel"><BedDouble size={13}/>إشغال الوحدات</div>
<div className="dashOccupancy">
  <div className="dashOccCard dashOccRented">
    <div className="dashOccNum">{totalRented}</div>
    <div className="dashOccLabel">مأجورة</div>
  </div>
  <div className="dashOccBarWrap">
    <div className="dashOccBarTrack">
      <div className="dashOccBarFill" style={{width:occupancyPct+'%'}}/>
    </div>
    <div className="dashOccPct">{occupancyPct}% إشغال</div>
  </div>
  <div className="dashOccCard dashOccAvail">
    <div className="dashOccNum">{totalAvail}</div>
    <div className="dashOccLabel">متاحة</div>
  </div>
</div>

{/* Charts Row */}
<div className="dashChartsRow">
  <div className="dashChart">
    <div className="dashChartTitle"><BarChart2 size={14}/>نشاط الصيانة — آخر 6 أشهر</div>
    {trendData.length===0?<EmptyChart/>:<div dir="ltr"><ResponsiveContainer height={200}>
      <AreaChart data={trendData} margin={{top:8,right:8,left:0,bottom:0}}>
        <defs><linearGradient id="tealGrad" x1="0" y1="0" x2="0" y2="1"><stop offset="5%" stopColor="#0f766e" stopOpacity={0.3}/><stop offset="95%" stopColor="#0f766e" stopOpacity={0}/></linearGradient></defs>
        <CartesianGrid strokeDasharray="3 3" vertical={false}/>
        <XAxis dataKey="label" tick={{fontSize:11}}/>
        <YAxis allowDecimals={false} width={28} tick={{fontSize:11}}/>
        <Tooltip formatter={v=>[v+' عمل','الأعمال']}/>
        <Area type="monotone" dataKey="cnt" stroke="#0f766e" strokeWidth={2} fill="url(#tealGrad)" isAnimationActive={false}/>
      </AreaChart>
    </ResponsiveContainer></div>}
  </div>
  <div className="dashChart">
    <div className="dashChartTitle"><Activity size={14}/>الأعمال حسب الفني</div>
    {(d.byTech||[]).every(x=>x.total===0)?<EmptyChart/>:<div dir="ltr"><ResponsiveContainer height={200}>
      <BarChart data={(d.byTech||[]).slice(0,6)} margin={{top:8,right:8,left:0,bottom:40}}>
        <CartesianGrid strokeDasharray="3 3" vertical={false}/>
        <XAxis dataKey="name" tick={{fontSize:10}} interval={0} angle={-30} textAnchor="end" height={50}/>
        <YAxis allowDecimals={false} width={24} tick={{fontSize:11}}/>
        <Tooltip formatter={v=>[v+' عمل','الإجمالي']}/>
        <Bar dataKey="total" fill="#0e7490" radius={[6,6,0,0]} maxBarSize={40} isAnimationActive={false}>
          <LabelList dataKey="total" position="top" style={{fontSize:11,fontWeight:700,fill:'#0e7490'}}/>
        </Bar>
      </BarChart>
    </ResponsiveContainer></div>}
  </div>
</div>

{/* Bottom Row: Recent + Overdue */}
<div className="dashBottomRow">
  <div className="dashPanel">
    <div className="dashPanelTitle"><ClipboardList size={14}/>آخر أعمال الصيانة</div>
    {(d.recent||[]).length===0?<div className="empty">لا توجد أعمال</div>:(d.recent||[]).map(r=>(
    <div key={r.id} className="dashActivityRow">
      <div className="dashActivityDot dashActivityDot-maint"/>
      <div className="dashActivityBody">
        <div className="dashActivityMain">{r.villa_name}{r.apartment_no&&<span className="dashActivityChip">شقة {r.apartment_no}</span>}</div>
        <div className="dashActivitySub">{r.technician_name} · {r.description?.slice(0,40)}{r.description?.length>40?'...':''}</div>
      </div>
      <div className="dashActivityMeta">
        {r.spare_part_cost>0&&<span className="dashActivityCost">{Number(r.spare_part_cost).toLocaleString()} AED</span>}
        <span className="dashActivityDate">{(()=>{const p=String(r.record_date).slice(0,10).split('-');const AR_M=['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];return `${parseInt(p[2])} ${AR_M[parseInt(p[1],10)-1]}`;})()}</span>
      </div>
    </div>))}
  </div>
  <div className="dashPanel">
    <div className="dashPanelTitle"><AlertCircle size={14}/>دفعات متأخرة</div>
    {(d.overdueList||[]).length===0
      ?<div className="dashNoOverdue"><CheckCircle2 size={32} color="#15803d"/><span>لا توجد دفعات متأخرة</span></div>
      :(d.overdueList||[]).map(r=>{
        const remaining=Number(r.amount)-Number(r.collected);
        const days=Math.floor((new Date()-new Date(r.due_date))/(1000*60*60*24));
        return <div key={r.id} className="dashOverdueRow">
          <div className="dashOverdueDays">{days}ي</div>
          <div className="dashActivityBody">
            <div className="dashActivityMain">{r.tenant_name}</div>
            <div className="dashActivitySub">{r.villa_name} · شقة {r.apartment_no}</div>
          </div>
          <div className="dashOverdueAmt">{remaining.toLocaleString()} <span>AED</span></div>
        </div>;})}
  </div>
</div>

</div>;
}


function Card({t,v,icon:Icon,tone='teal'}){return <div className="card"><div className={'cardIcon tone-'+tone}>{Icon&&<Icon size={18}/>}</div><div className="cardBody"><p>{t}</p><h3>{v}</h3></div></div>}
function EmptyChart(){return <div className="emptyChart">لا توجد بيانات كافية لعرض الرسم البياني لهذه الفترة</div>}
function Panel(p){return <section className="panel"><h3>{p.title}</h3>{p.children}</section>}
function Loader(){return <div className="panel">جاري التحميل...</div>}
function Field({label,required,wide,children}){return <label className={'field'+(wide?' wide':'')}><span>{label}{required&&<b className="req">*</b>}</span>{children}</label>}
function Modal({open,onClose,title,children}){useEffect(()=>{if(!open)return;const onKey=e=>{if(e.key==='Escape')onClose()};document.addEventListener('keydown',onKey);return()=>document.removeEventListener('keydown',onKey)},[open,onClose]);if(!open)return null;return <div className="modalOverlay" onClick={onClose}><div className="modalBox" onClick={e=>e.stopPropagation()}><div className="modalHead"><h3>{title}</h3><button type="button" className="iconBtn" onClick={onClose}><X size={18}/></button></div>{children}</div></div>}

function Records(){const api=useApi();const[rows,setRows]=useState([]),[villas,setVillas]=useState([]),[apts,setApts]=useState([]),[techs,setTechs]=useState([]);const empty={record_date:new Date().toISOString().slice(0,10),villa_id:'',apartment_id:'',issue_type:'',description:'',technician_ids:[],reported_time:'',completed_time:'',spare_part:'',spare_part_cost:0,notes:''};const[form,setForm]=useState(empty);const[editing,setEditing]=useState(null);const[modalOpen,setModalOpen]=useState(false);const[viewing,setViewing]=useState(null);const load=()=>{api('/records').then(setRows);api('/villas').then(setVillas);api('/apartments').then(setApts);api('/technicians/active').then(setTechs)};useEffect(()=>{load()},[]);function openAdd(){setEditing(null);setForm(empty);setModalOpen(true)}function closeModal(){setModalOpen(false)}async function save(e){e.preventDefault();if(form.technician_ids.length===0)return showToast('اختر فنيًا واحدًا على الأقل','error');await runAction(async()=>{await api(editing?'/records/'+editing:'/records',{method:editing?'PUT':'POST',body:JSON.stringify(form)});setForm(empty);setEditing(null);setModalOpen(false);load()},editing?'تم حفظ التعديل':'تمت إضافة السجل')}function edit(r){setEditing(r.id);setForm({...r,record_date:String(r.record_date).slice(0,10),reported_time:r.reported_time||'',completed_time:r.completed_time||'',technician_ids:r.technician_ids?String(r.technician_ids).split(',').map(Number):[]});setModalOpen(true)}async function remove(r){if(!confirm('تأكيد حذف سجل الصيانة هذا؟ لا يمكن التراجع.'))return;await runAction(async()=>{await api('/records/'+r.id,{method:'DELETE'});load()},'تم حذف السجل')}function csv(){const BOM='﻿';let c=BOM+'التاريخ,الفيلا,رقم الشقة,نوع المشكلة,الوصف,الفني,وقت الورود,وقت الانتهاء,قطعة الغيار,التكلفة\n'+rows.map(r=>[r.record_date,r.villa_name,r.apartment_no,ISSUE_TYPE_LABELS[r.issue_type]||r.issue_type,r.description,r.technician_name,r.reported_time,r.completed_time,r.spare_part,r.spare_part_cost].map(x=>'"'+(x??'')+'"').join(',')).join('\n');let a=document.createElement('a');a.href=URL.createObjectURL(new Blob([c],{type:'text/csv;charset=utf-8'}));a.download='كشوف-الصيانة.csv';a.click()}return <><Panel title="كشف الصيانة"><div className="panelActions"><button onClick={openAdd}><Plus size={16}/>إضافة سجل صيانة</button><button className="secondary" onClick={csv}><Download size={16}/>تصدير CSV / Excel</button></div><Table rows={rows.map(r=>({...r,status:r.completed_time?'مكتمل':'قيد التنفيذ'}))} cols={['record_date','villa_name','apartment_no','issue_type','technician_name','status','spare_part_cost']} searchable actions={r=><><button className="secondary" onClick={()=>setViewing(r)}><Eye size={15}/></button><button onClick={()=>edit(r)}><Edit size={15}/></button><button className="danger" onClick={()=>remove(r)}><Trash2 size={15}/></button></>}/></Panel>
<Modal open={!!viewing} onClose={()=>setViewing(null)} title="تفاصيل السجل">{viewing&&<div className="viewDetails"><div><b>الوصف</b><p>{viewing.description||'-'}</p></div><div><b>ملاحظات</b><p>{viewing.notes||'-'}</p></div></div>}</Modal>
<Modal open={modalOpen} onClose={closeModal} title={editing?'تعديل سجل صيانة':'إضافة سجل صيانة'}><form className="form" onSubmit={save}>
<div className="formSection wide"><span className="formSectionTitle">بيانات الموقع</span></div>
<Field label="التاريخ" required><input required type="date" value={form.record_date} onChange={e=>setForm({...form,record_date:e.target.value})}/></Field>
<Field label="الفيلا" required><select required value={form.villa_id} onChange={e=>setForm({...form,villa_id:e.target.value,apartment_id:''})}><option value="">اختر الفيلا</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
<Field label="الشقة"><select disabled={!form.villa_id} value={form.apartment_id} onChange={e=>setForm({...form,apartment_id:e.target.value})}><option value="">{form.villa_id?'بدون شقة محددة (الفيلا بالكامل)':'اختر الفيلا أولاً'}</option>{apts.filter(a=>a.villa_id==form.villa_id).map(a=><option key={a.id} value={a.id}>{a.apartment_no}</option>)}</select></Field>
<Field label="نوع المشكلة"><select value={form.issue_type} onChange={e=>setForm({...form,issue_type:e.target.value})}><option value="">اختر النوع</option>{ISSUE_TYPES.map(([v,l])=><option key={v} value={v}>{l}</option>)}</select></Field>
<Field label="الفني (يمكن اختيار أكثر من فني)" required wide><div className="chipPicker">{techs.map(t=>{const sel=form.technician_ids.includes(t.id);return <button type="button" key={t.id} className={'chip'+(sel?' chipSelected':'')} onClick={()=>setForm({...form,technician_ids:sel?form.technician_ids.filter(id=>id!==t.id):[...form.technician_ids,t.id]})}>{sel&&<Check size={13}/>}{t.name}</button>})}</div>{form.technician_ids.length===0&&<small className="chipHint">اختر فنيًا واحدًا على الأقل</small>}</Field>
<div className="formSection wide"><span className="formSectionTitle">تنفيذ العمل</span></div>
<Field label="وقت الورود"><input type="time" value={form.reported_time} onChange={e=>setForm({...form,reported_time:e.target.value})}/></Field>
<Field label="وقت الانتهاء"><input type="time" value={form.completed_time} onChange={e=>setForm({...form,completed_time:e.target.value})}/></Field>
<Field label="قطعة الغيار"><input value={form.spare_part||''} onChange={e=>setForm({...form,spare_part:e.target.value})}/></Field>
<Field label="التكلفة (AED)"><input type="number" min="0" step="0.01" value={form.spare_part_cost} onChange={e=>setForm({...form,spare_part_cost:e.target.value})}/></Field>
<div className="formSection wide"><span className="formSectionTitle">التفاصيل</span></div>
<Field label="الوصف" required wide><textarea required value={form.description} onChange={e=>setForm({...form,description:e.target.value})}/></Field>
<Field label="ملاحظات" wide><textarea value={form.notes||''} onChange={e=>setForm({...form,notes:e.target.value})}/></Field>
<button><Plus size={16}/>{editing?'حفظ التعديل':'إضافة السجل'}</button><button type="button" className="secondary" onClick={closeModal}>إلغاء</button></form></Modal></>}

const VILLA_GRADIENTS=['linear-gradient(135deg,#0f766e,#0e7490)','linear-gradient(135deg,#1d4ed8,#4f46e5)','linear-gradient(135deg,#7c3aed,#a855f7)','linear-gradient(135deg,#be185d,#ec4899)','linear-gradient(135deg,#b45309,#f59e0b)','linear-gradient(135deg,#15803d,#22c55e)','linear-gradient(135deg,#0e7490,#06b6d4)','linear-gradient(135deg,#dc2626,#f97316)'];
function villaGradient(name){let h=0;for(let i=0;i<name.length;i++)h=(h*31+name.charCodeAt(i))%VILLA_GRADIENTS.length;return VILLA_GRADIENTS[h];}
function Villas({user}){
const api=useApi();const isAdmin=user?.role==='ADMIN';
const[villas,setVillas]=useState([]);const[apts,setApts]=useState([]);const[qs,setQs]=useState('');
const emptyVilla={name:'',area:'',notes:'',is_active:1};
const[villa,setVilla]=useState(emptyVilla);const[editingVilla,setEditingVilla]=useState(null);const[modalOpen,setModalOpen]=useState(false);
const load=()=>{api('/villas').then(setVillas);api('/apartments').then(setApts)};
useEffect(()=>{load()},[]);
async function saveVilla(e){e.preventDefault();await runAction(async()=>{await api(editingVilla?'/villas/'+editingVilla:'/villas',{method:editingVilla?'PUT':'POST',body:JSON.stringify(villa)});setVilla(emptyVilla);setEditingVilla(null);setModalOpen(false);load()},editingVilla?'تم تعديل الفيلا':'تمت إضافة الفيلا')}
async function removeVilla(r){if(!confirm(`تأكيد حذف فيلا "${r.name}"؟ سيتم حذف كل الشقق المرتبطة بها.`))return;await runAction(async()=>{await api('/villas/'+r.id,{method:'DELETE'});load()},'تم حذف الفيلا')}
const rows=villas.map(v=>({...v,aptCount:apts.filter(a=>a.villa_id===v.id).length}));
const filtered=rows.filter(r=>!qs||r.name.includes(qs)||(r.area||'').includes(qs));
const activeCount=rows.filter(r=>r.is_active).length;
const maxApts=Math.max(...rows.map(x=>x.aptCount),1);
return <>
<div className="villasPageHeader">
  <div className="villasPageTitle"><Building2 size={20}/><h2>الفلل</h2><span className="tenantListCount">{rows.length}</span></div>
  <div className="villasPageActions">
    <div className="tenantSearch"><input placeholder="بحث بالاسم أو المنطقة..." value={qs} onChange={e=>setQs(e.target.value)}/></div>
    {isAdmin&&<button onClick={()=>{setEditingVilla(null);setVilla(emptyVilla);setModalOpen(true)}}><Plus size={16}/>إضافة فيلا</button>}
  </div>
</div>
<div className="villasSummaryBar">
  <div className="villasSumCard"><span className="villasSumVal">{rows.length}</span><span className="villasSumLbl">إجمالي الفلل</span></div>
  <div className="villasSumCard"><span className="villasSumVal" style={{color:'#15803d'}}>{activeCount}</span><span className="villasSumLbl">فيلا نشطة</span></div>
  <div className="villasSumCard"><span className="villasSumVal">{apts.length}</span><span className="villasSumLbl">إجمالي الشقق</span></div>
  <div className="villasSumCard"><span className="villasSumVal">{rows.length>0?(apts.length/rows.length).toFixed(1):0}</span><span className="villasSumLbl">متوسط الشقق</span></div>
</div>
{filtered.length===0&&<div className="tenantEmpty"><Building2 size={36} style={{opacity:.2}}/><p>{qs?'لا توجد نتائج مطابقة':'لا يوجد فلل بعد'}</p></div>}
<div className="tenantRows">
{filtered.map((r,idx)=>{
  const grad=villaGradient(r.name);
  const core=r.name.replace(/فيلا\s*/,'').replace(/^ال/,'').trim();
  const initials=(core||r.name).slice(0,2);
  return <div key={r.id} className="tenantRow villaRow">
    <span className="tenantRowIdx">{idx+1}</span>
    <div className="tenantRowAvatar" style={{background:grad}}>{initials}</div>
    <div className="tenantRowMain">
      <span className="tenantRowName">{r.name}</span>
      <div className="tenantRowMeta">
        {r.area&&<span className="tenantRowMetaItem"><MapPin size={12}/>{r.area}</span>}
        <span className="tenantRowMetaItem"><Home size={12}/>{r.aptCount} شقة</span>
        {r.notes&&<span className="tenantRowMetaItem villaRowNotes">{r.notes}</span>}
      </div>
    </div>
    <span className={'villaRowStatus'+(r.is_active?' vc2Active':' vc2Inactive')}>{r.is_active?'نشطة':'متوقفة'}</span>
    {isAdmin&&<div className="tenantRowActions">
      <button className="iconBtn secondary" onClick={()=>{setEditingVilla(r.id);setVilla({name:r.name,area:r.area||'',notes:r.notes||'',is_active:r.is_active});setModalOpen(true)}}><Edit size={13}/></button>
      <button className="iconBtn danger" onClick={()=>removeVilla(r)}><Trash2 size={13}/></button>
    </div>}
  </div>;
})}
</div>
<Modal open={modalOpen} onClose={()=>setModalOpen(false)} title={editingVilla?'تعديل فيلا':'إضافة فيلا'}><form className="form compact" onSubmit={saveVilla}>
  <Field label="اسم الفيلا" required><input required placeholder="فيلا الياسمين" value={villa.name} onChange={e=>setVilla({...villa,name:e.target.value})}/></Field>
  <Field label="المنطقة"><input placeholder="دبي" value={villa.area} onChange={e=>setVilla({...villa,area:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><input value={villa.notes||''} onChange={e=>setVilla({...villa,notes:e.target.value})}/></Field>
  {editingVilla&&<Field label="الحالة"><select value={villa.is_active} onChange={e=>setVilla({...villa,is_active:Number(e.target.value)})}><option value={1}>فعّال</option><option value={0}>متوقف</option></select></Field>}
  <button>{editingVilla?'حفظ التعديل':'إضافة'}</button><button type="button" className="secondary" onClick={()=>setModalOpen(false)}>إلغاء</button>
</form></Modal>
</>;}


function TenantSearch({tenants,value,onChange}){
  const[q,setQ]=useState('');
  const[open,setOpen]=useState(false);
  const selected=tenants.find(t=>t.id==value);
  const filtered=q?tenants.filter(t=>t.name.includes(q)||(t.phone||'').includes(q)):tenants;
  return <div className="tenantSearch" style={{position:'relative'}}>
    <div className="tenantSearchInput" onClick={()=>setOpen(o=>!o)}>
      {selected?<span>{selected.name}{selected.phone&&<small> — {selected.phone}</small>}</span>:<span className="tenantSearchPlaceholder">ابحث عن مستأجر...</span>}
      <ChevronDown size={14}/>
    </div>
    {open&&<div className="tenantSearchDropdown">
      <input autoFocus className="tenantSearchBox" placeholder="اكتب الاسم أو الهاتف..." value={q} onChange={e=>setQ(e.target.value)} onClick={e=>e.stopPropagation()}/>
      <div className="tenantSearchList">
        {filtered.length===0&&<div className="tenantSearchEmpty">لا توجد نتائج</div>}
        {filtered.map(t=><div key={t.id} className={'tenantSearchItem'+(t.id==value?' selected':'')} onMouseDown={()=>{onChange(t.id);setOpen(false);setQ('');}}>
          <span className="tenantSearchName">{t.name}</span>
          {t.phone&&<span className="tenantSearchPhone">{t.phone}</span>}
        </div>)}
      </div>
    </div>}
  </div>
}

const DEPOSIT_TYPES=[['cash','كاش'],['check','شيك']];
const emptyLeaseForm={tenant_id:'',start_date:'',end_date:'',total_amount:'',fees_amount:'',deposit_amount:'',deposit_type:'',deposit_notes:'',notes:''};

function LeaseFormFields({form,setForm,tenants}){return <>
  <Field label="المستأجر" required><TenantSearch tenants={tenants} value={form.tenant_id} onChange={v=>setForm({...form,tenant_id:v})}/></Field>
  <Field label="تاريخ البداية" required><input required type="date" value={form.start_date} onChange={e=>setForm({...form,start_date:e.target.value})}/></Field>
  <Field label="تاريخ النهاية" required><input required type="date" value={form.end_date} onChange={e=>setForm({...form,end_date:e.target.value})}/></Field>
  <Field label="إجمالي الإيجار (AED)" required><input required type="number" min="0.01" step="0.01" value={form.total_amount} onChange={e=>setForm({...form,total_amount:e.target.value})}/></Field>
  <Field label="الرسوم (AED)"><input type="number" min="0" step="0.01" value={form.fees_amount} onChange={e=>setForm({...form,fees_amount:e.target.value})}/></Field>
  <Field label="مبلغ التأمين (AED)"><input type="number" min="0" step="0.01" value={form.deposit_amount} onChange={e=>setForm({...form,deposit_amount:e.target.value})}/></Field>
  <Field label="نوع سداد التأمين"><select value={form.deposit_type} onChange={e=>setForm({...form,deposit_type:e.target.value})}><option value="">—</option>{DEPOSIT_TYPES.map(([v,l])=><option key={v} value={v}>{l}</option>)}</select></Field>
  <Field label="ملاحظات التأمين"><input value={form.deposit_notes} onChange={e=>setForm({...form,deposit_notes:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={form.notes} onChange={e=>setForm({...form,notes:e.target.value})}/></Field>
</>}

function AptLeasesView({apt,api,isAdmin,onBack}){
const[leasesDetail,setLeasesDetail]=useState(null);
const[tenants,setTenants]=useState([]);
const[leaseForm,setLeaseForm]=useState(emptyLeaseForm);
const[leaseOpen,setLeaseOpen]=useState(false);
const[instForm,setInstForm]=useState({due_date:'',amount:'',notes:''});const[instOpen,setInstOpen]=useState(false);const[editingInst,setEditingInst]=useState(null);const[targetLeaseId,setTargetLeaseId]=useState(null);
const[paymentsInst,setPaymentsInst]=useState(null);const[payments,setPayments]=useState([]);
const[payForm,setPayForm]=useState({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});const[payOpen,setPayOpen]=useState(false);

async function reload(){
  const leases=await api('/leases?apartment_id='+apt.id);
  const details=await Promise.all((leases||[]).map(l=>api('/leases/'+l.id)));
  setLeasesDetail(details.sort((a,b)=>new Date(b.lease.start_date)-new Date(a.lease.start_date)));
}
useEffect(()=>{reload();api('/tenants').then(setTenants)},[apt.id]);

async function saveLease(e){e.preventDefault();if(!leaseForm.tenant_id)return showToast('اختر المستأجر','error');await runAction(async()=>{await api('/leases',{method:'POST',body:JSON.stringify({...leaseForm,apartment_id:apt.id})});setLeaseForm(emptyLeaseForm);setLeaseOpen(false);reload()},'تمت إضافة العقد')}
async function saveInst(e){e.preventDefault();await runAction(async()=>{if(editingInst){await api('/installments/'+editingInst,{method:'PUT',body:JSON.stringify(instForm)})}else{await api('/leases/'+targetLeaseId+'/installments',{method:'POST',body:JSON.stringify(instForm)})}setInstForm({due_date:'',amount:'',notes:''});setEditingInst(null);setInstOpen(false);reload()},editingInst?'تم تعديل الدفعة':'تمت إضافة الدفعة')}
async function removeInst(id){if(!confirm('تأكيد حذف الدفعة؟'))return;await runAction(async()=>{await api('/installments/'+id,{method:'DELETE'});reload()},'تم الحذف')}
async function openPayments(inst){setPaymentsInst(inst);const p=await api('/installments/'+inst.id+'/payments');setPayments(p||[]);setPayOpen(true)}
async function addPayment(e){e.preventDefault();await runAction(async()=>{await api('/installments/'+paymentsInst.id+'/payments',{method:'POST',body:JSON.stringify(payForm)});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);setPayForm({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});reload()},'تم تسجيل الدفعة')}
async function removePayment(id){if(!confirm('تأكيد حذف هذا الدفع؟'))return;await runAction(async()=>{await api('/payments/'+id,{method:'DELETE'});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);reload()},'تم الحذف')}

if(!leasesDetail)return <div className="panel">جاري التحميل...</div>;
return <>
<div className="tenantDetailHeader">
  <button type="button" className="pageBackBtn" onClick={onBack}><ArrowRight size={16}/>رجوع</button>
  <div className="tenantDetailInfo">
    <div className="tenantDetailAvatar" style={{borderRadius:14,background:'linear-gradient(135deg,#0e7490,#0f766e)'}}><Home size={22}/></div>
    <div><h3 className="tenantDetailName">{apt.villa_name} — شقة {apt.apartment_no}</h3><div className="tenantDetailMeta">{apt.floor&&<span>الدور: {apt.floor}</span>}</div></div>
  </div>
  <div className="tenantDetailActions"><button onClick={()=>setLeaseOpen(true)}><Plus size={15}/>عقد جديد</button></div>
</div>
{leasesDetail.length===0&&<div className="panel"><div className="empty" style={{padding:32,textAlign:'center',color:'var(--muted)'}}>لا يوجد عقد لهذه الشقة بعد — اضغط "عقد جديد" لإنشاء أول عقد</div></div>}
{leasesDetail.map(({lease,installments},idx)=>{
  const st=leaseStatus(lease);
  const collected=installments.reduce((s,i)=>s+Number(i.collected_amount),0);
  const remaining=Number(lease.total_amount)-collected;
  const pct=Number(lease.total_amount)>0?Math.min(100,collected/Number(lease.total_amount)*100):0;
  return <div key={lease.id} className={'leaseBlock'+(st==='expired'?' leaseBlockExpired':'')}>
    <div className="leaseBlockStrip">
      <div className="leaseBlockMeta">
        {idx===0&&st==='active'?<span className="leaseBlockBadge leaseBlockBadgeActive">الحالي</span>:<span className="leaseBlockBadge leaseBlockBadgeExpired">منتهي</span>}
        <span className="leaseBlockLocation"><UserCheck size={13}/>{lease.tenant_name}{lease.tenant_phone&&<span className="leaseBlockPhone"> · {lease.tenant_phone}</span>}</span>
        <span className="leaseBlockDates"><Calendar size={12}/>{new Date(lease.start_date).toLocaleDateString('ar-AE')} — {new Date(lease.end_date).toLocaleDateString('ar-AE')}</span>
      </div>
      <div className="leaseBlockFin">
        <span className="leaseBlockFinItem"><span className="leaseBlockFinVal">{Number(lease.total_amount).toFixed(0)}</span><span className="leaseBlockFinLbl">AED إجمالي</span></span>
        <span className="leaseBlockSep"/>
        <span className="leaseBlockFinItem"><span className="leaseBlockFinVal leaseBlockFinGreen">{collected.toFixed(0)}</span><span className="leaseBlockFinLbl">محصّل</span></span>
        <span className="leaseBlockSep"/>
        <span className="leaseBlockFinItem"><span className={'leaseBlockFinVal'+(remaining>0?' leaseBlockFinRed':'')}>{remaining.toFixed(0)}</span><span className="leaseBlockFinLbl">متبقي</span></span>
      </div>
    </div>
    <div className="leaseBlockBar"><div className="leaseBlockBarFill" style={{width:pct+'%'}}/></div>
    <InstTable installments={installments} isAdmin={isAdmin} leaseId={lease.id}
      onAdd={id=>{setTargetLeaseId(id);setEditingInst(null);setInstForm({due_date:'',amount:'',notes:''});setInstOpen(true)}}
      onEdit={(i,lid)=>{setTargetLeaseId(lid);setEditingInst(i.id);setInstForm({due_date:String(i.due_date).slice(0,10),amount:i.amount,notes:i.notes||''});setInstOpen(true)}}
      onDelete={removeInst} onPayments={openPayments}/>
  </div>;
})}
<Modal open={leaseOpen} onClose={()=>setLeaseOpen(false)} title="إضافة عقد إيجار جديد"><form className="form" onSubmit={saveLease}>
  <LeaseFormFields form={leaseForm} setForm={setLeaseForm} tenants={tenants}/>
  <button><Plus size={16}/>إضافة العقد</button><button type="button" className="secondary" onClick={()=>setLeaseOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
  <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
  <Field label="المبلغ (AED)" required><input required type="number" min="0.01" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
  <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات دفعة: ${Number(paymentsInst?.amount||0).toFixed(2)} AED`}>
  {paymentsInst&&<div className="paymentsModal">
    <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toFixed(2)} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
    <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
      <Field label="المبلغ المدفوع (AED)" required><input required type="number" min="0.01" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
      <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
      <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
      <button><Plus size={14}/>تسجيل دفع</button>
    </form>
  </div>}
</Modal>
</>;
}

function Apartments({user}){
const api=useApi();const isAdmin=user?.role==='ADMIN';
const[villas,setVillas]=useState([]),[apts,setApts]=useState([]);
const[selectedApt,setSelectedApt]=useState(null);
const[q,setQ]=useState('');
const[expanded,setExpanded]=useState(()=>new Set());
const toggleVilla=id=>setExpanded(prev=>{const n=new Set(prev);n.has(id)?n.delete(id):n.add(id);return n});
const emptyApt={villa_id:'',apartment_no:'',apt_type:'',bathrooms:1,has_balcony:false,rental_status:'available',floor:'',notes:''};const[apt,setApt]=useState(emptyApt);const[editingApt,setEditingApt]=useState(null);const[modalOpen,setModalOpen]=useState(false);
const load=()=>{api('/villas').then(setVillas);api('/apartments').then(setApts)};
useEffect(()=>{load()},[]);

function openAdd(villaId=''){setEditingApt(null);setApt({...emptyApt,villa_id:villaId});setModalOpen(true)}
async function saveApt(e){e.preventDefault();await runAction(async()=>{await api(editingApt?'/apartments/'+editingApt:'/apartments',{method:editingApt?'PUT':'POST',body:JSON.stringify(apt)});setApt(emptyApt);setEditingApt(null);setModalOpen(false);load()},editingApt?'تم تعديل الشقة':'تمت إضافة الشقة')}
async function removeApt(r){if(!confirm(`تأكيد حذف الشقة "${r.apartment_no}"؟`))return;await runAction(async()=>{await api('/apartments/'+r.id,{method:'DELETE'});load()},'تم حذف الشقة')}

if(selectedApt)return <AptLeasesView apt={selectedApt} api={api} isAdmin={isAdmin} onBack={()=>setSelectedApt(null)}/>;

const qs=q.trim().toLowerCase();
const filteredApts=qs?apts.filter(a=>a.apartment_no.toLowerCase().includes(qs)||a.villa_name?.toLowerCase().includes(qs)||String(a.floor||'').toLowerCase().includes(qs)):apts;
const grouped=villas.map(v=>({villa:v,apts:filteredApts.filter(a=>a.villa_id===v.id)})).filter(g=>g.apts.length>0||!qs);

return <>
<div className="aptPageHeader">
  <input className="tableSearch aptSearch" placeholder="بحث في الشقق..." value={q} onChange={e=>setQ(e.target.value)}/>
  {isAdmin&&<button onClick={()=>openAdd()}><Plus size={15}/>إضافة شقة</button>}
</div>
{grouped.length===0&&<div className="panel"><div className="empty" style={{padding:32,textAlign:'center'}}>لا توجد شقق</div></div>}
{grouped.map(({villa,apts:vapts})=>{
  const rented=vapts.filter(a=>a.rental_status==='rented').length;
  const avail=vapts.length-rented;
  const isOpen=expanded.has(villa.id)||!!qs;   // auto-open while searching
  return (
<div key={villa.id} className={'villaSection'+(isOpen?' villaSectionOpen':'')}>
  <div className="villaSectionHeader villaSectionHeaderClickable" onClick={()=>toggleVilla(villa.id)}>
    <div className="villaSectionTitle">
      <ChevronDown size={16} className={'villaChevron'+(isOpen?' villaChevronOpen':'')}/>
      <Building2 size={16}/>{villa.name}{villa.area&&<span className="villaSectionArea">{villa.area}</span>}
    </div>
    <div className="villaSectionRight" onClick={e=>e.stopPropagation()}>
      <span className="aptCountChip">{vapts.length} شقة</span>
      <span className="aptCountChip aptCountRented">{rented} مأجورة</span>
      <span className="aptCountChip aptCountAvail">{avail} متاحة</span>
      {isAdmin&&<button className="secondary villaSectionAdd" onClick={()=>openAdd(String(villa.id))}><Plus size={13}/>إضافة</button>}
    </div>
  </div>
  {isOpen&&<div className="aptRows">
    {vapts.map(r=>{const rented=r.rental_status==='rented';return(
    <div key={r.id} className="aptRow" onClick={()=>setSelectedApt(r)}>
      <span className={'aptRowDot'+(rented?' aptRowDotRented':' aptRowDotAvail')}/>
      <span className="aptRowNo">{r.apartment_no}</span>
      <span className={'aptRowStatus'+(rented?' aptRowStatusRented':' aptRowStatusAvail')}>{rented?'مأجورة':'متاحة'}</span>
      <div className="aptRowMeta">
        {r.apt_type&&<span className="aptRowType">{r.apt_type}</span>}
        {r.floor&&<span className="aptRowMetaItem"><Home size={11}/>{r.floor}</span>}
        <span className="aptRowMetaItem"><Droplet size={11}/>{r.bathrooms??1}</span>
        {r.has_balcony?<span className="aptRowMetaItem">بلكونة</span>:null}
      </div>
      <div className="aptRowActions" onClick={e=>e.stopPropagation()}>
        <button className="secondary aptRowBtn" onClick={()=>setSelectedApt(r)}><Banknote size={13}/>العقود</button>
        {isAdmin&&<>
          <button className="secondary iconBtn" onClick={()=>{setEditingApt(r.id);setApt({villa_id:r.villa_id,apartment_no:r.apartment_no,apt_type:r.apt_type||'',bathrooms:r.bathrooms??1,has_balcony:!!r.has_balcony,rental_status:r.rental_status||'available',floor:r.floor||'',notes:r.notes||''});setModalOpen(true)}}><Edit size={13}/></button>
          <button className="danger iconBtn" onClick={()=>removeApt(r)}><Trash2 size={13}/></button>
        </>}
      </div>
    </div>);})}
  </div>}
</div>);})}
<Modal open={modalOpen} onClose={()=>setModalOpen(false)} title={editingApt?'تعديل شقة':'إضافة شقة'}>
<form className="form compact" onSubmit={saveApt}>
  <Field label="الفيلا" required><select required value={apt.villa_id} onChange={e=>setApt({...apt,villa_id:e.target.value})}><option value="">اختر الفيلا</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
  <Field label="رقم الشقة" required><input required value={apt.apartment_no} onChange={e=>setApt({...apt,apartment_no:e.target.value})}/></Field>
  <Field label="نوع الشقة"><select value={apt.apt_type||''} onChange={e=>setApt({...apt,apt_type:e.target.value})}>
    <option value="">— اختر النوع —</option>
    <option value="استديو">استديو</option>
    <option value="غرفة وصالة">غرفة وصالة</option>
    <option value="غرفتان وصالة">غرفتان وصالة</option>
    <option value="3 غرف وصالة">3 غرف وصالة</option>
    <option value="4 غرف وصالة">4 غرف وصالة</option>
    <option value="5 غرف وصالة">5 غرف وصالة</option>
    <option value="دوبلكس">دوبلكس</option>
    <option value="بنتهاوس">بنتهاوس</option>
  </select></Field>
  <Field label="عدد الحمامات"><select value={apt.bathrooms??1} onChange={e=>setApt({...apt,bathrooms:Number(e.target.value)})}>
    {[1,2,3,4,5].map(n=><option key={n} value={n}>{n} حمام{n===1?'':n===2?'ان':'ات'}</option>)}
  </select></Field>
  {/* rental_status is auto-computed from active leases — not shown in form */}
  <Field label="بلكونة"><label style={{display:'flex',alignItems:'center',gap:8,cursor:'pointer'}}><input type="checkbox" checked={!!apt.has_balcony} onChange={e=>setApt({...apt,has_balcony:e.target.checked})} style={{width:18,height:18}}/> يوجد بلكونة</label></Field>
  <Field label="الدور"><input value={apt.floor||''} onChange={e=>setApt({...apt,floor:e.target.value})}/></Field>
  <Field label="ملاحظات"><input value={apt.notes||''} onChange={e=>setApt({...apt,notes:e.target.value})}/></Field>
  <button>{editingApt?'حفظ التعديل':'إضافة'}</button>
  <button type="button" className="secondary" onClick={()=>setModalOpen(false)}>إلغاء</button>
</form></Modal>
</>;
}

const emptyTech={name:'',specialty:'',phone:'',notes:''};
function Technicians({user}){const api=useApi();const isAdmin=user?.role==='ADMIN';const[rows,setRows]=useState([]);const[items,setItems]=useState([{...emptyTech}]);const[editing,setEditing]=useState(null);const[modalOpen,setModalOpen]=useState(false);const load=()=>api('/technicians').then(setRows);useEffect(()=>{load()},[]);
function openAdd(){setEditing(null);setItems([{...emptyTech}]);setModalOpen(true)}
function closeModal(){setModalOpen(false)}
function updateItem(i,f,v){setItems(items.map((it,idx)=>idx===i?{...it,[f]:v}:it))}
function addRow(){setItems([...items,{...emptyTech}])}
function removeRow(i){setItems(items.filter((_,idx)=>idx!==i))}
async function save(e){e.preventDefault();await runAction(async()=>{if(editing){await api('/technicians/'+editing,{method:'PUT',body:JSON.stringify(items[0])})}else{for(const it of items){await api('/technicians',{method:'POST',body:JSON.stringify(it)})}}setItems([{...emptyTech}]);setEditing(null);setModalOpen(false);load()},editing?'تم حفظ التعديل':items.length>1?`تمت إضافة ${items.length} فنيين`:'تمت إضافة الفني')}
function startEdit(r){setEditing(r.id);setItems([{name:r.name,specialty:r.specialty||'',phone:r.phone||'',notes:r.notes||''}]);setModalOpen(true)}
async function remove(r){if(!confirm('تأكيد الحذف؟'))return;await runAction(async()=>{await api('/technicians/'+r.id,{method:'DELETE'});load()},'تم الحذف')}
return <><Panel title="الفنيين"><div className="panelActions"><button onClick={openAdd}><Plus size={16}/>إضافة فني</button></div><Table rows={rows} cols={['name','specialty','phone','notes']} searchable actions={isAdmin?r=><><button onClick={()=>startEdit(r)}><Edit size={15}/></button><button className="danger" onClick={()=>remove(r)}><Trash2 size={15}/></button></>:null}/></Panel>
<Modal open={modalOpen} onClose={closeModal} title={editing?'تعديل فني':'إضافة فنيين'}><form className="form compact" onSubmit={save}>
{items.map((it,i)=><div key={i} className="techRow">
{!editing&&items.length>1&&<div className="techRowHead"><span>فني {i+1}</span><button type="button" className="iconBtn" onClick={()=>removeRow(i)}><X size={14}/></button></div>}
<Field label="الاسم" required><input required value={it.name} onChange={e=>updateItem(i,'name',e.target.value)}/></Field>
<Field label="التخصص"><input value={it.specialty} onChange={e=>updateItem(i,'specialty',e.target.value)}/></Field>
<Field label="الهاتف"><input value={it.phone} onChange={e=>updateItem(i,'phone',e.target.value)}/></Field>
<Field label="ملاحظات"><input value={it.notes} onChange={e=>updateItem(i,'notes',e.target.value)}/></Field>
</div>)}
{!editing&&<button type="button" className="secondary" onClick={addRow}><Plus size={14}/>إضافة فني آخر</button>}
<button>{editing?'حفظ التعديل':items.length>1?`إضافة ${items.length} فنيين`:'إضافة'}</button><button type="button" className="secondary" onClick={closeModal}>إلغاء</button>
</form></Modal></>}
function UsersPage({user}){return <Simple title="المستخدمين" path="/users" fields={['name','email','password','role']} labels={['الاسم','الإيميل','كلمة المرور','الدور']} required={['name','email']} selectOptions={{role:[['SUPERVISOR','مشرف (SUPERVISOR)'],['ADMIN','أدمن (ADMIN)']]}} user={user} currentUserId={user?.id}/>}
function Simple({title,path,fields,labels,required=[],selectOptions={},user,currentUserId}){const api=useApi();const isAdmin=user?.role==='ADMIN';const[rows,setRows]=useState([]);const init=Object.fromEntries(fields.map(f=>[f,selectOptions[f]?selectOptions[f][0][0]:'']));const[form,setForm]=useState(init);const[editing,setEditing]=useState(null);const[modalOpen,setModalOpen]=useState(false);const load=()=>api(path).then(setRows);useEffect(()=>{load()},[path]);function openAdd(){setEditing(null);setForm(init);setModalOpen(true)}function closeModal(){setModalOpen(false)}async function save(e){e.preventDefault();await runAction(async()=>{await api(editing?path+'/'+editing:path,{method:editing?'PUT':'POST',body:JSON.stringify(form)});setForm(init);setEditing(null);setModalOpen(false);load()},editing?'تم حفظ التعديل':'تمت الإضافة')}function startEdit(r){setEditing(r.id);setForm({...init,...r,password:''});setModalOpen(true)}async function remove(r){if(!confirm(`تأكيد الحذف؟`))return;await runAction(async()=>{await api(path+'/'+r.id,{method:'DELETE'});load()},'تم الحذف')}return <><Panel title={title}><div className="panelActions"><button onClick={openAdd}><Plus size={16}/>إضافة</button></div><Table rows={rows} cols={fields.filter(f=>f!=='password')} searchable actions={isAdmin?r=><>{r.id!==currentUserId&&<><button onClick={()=>startEdit(r)}><Edit size={15}/></button><button className="danger" onClick={()=>remove(r)}><Trash2 size={15}/></button></>}</>:null}/></Panel><Modal open={modalOpen} onClose={closeModal} title={editing?'تعديل':title}><form className="form compact" onSubmit={save}>{fields.map((f,i)=><Field key={f} label={labels[i]+(editing&&f==='password'?' (اتركها فارغة لعدم التغيير)':'')} required={required.includes(f)}>{selectOptions[f]?<select value={form[f]} onChange={e=>setForm({...form,[f]:e.target.value})}>{selectOptions[f].map(([v,l])=><option key={v} value={v}>{l}</option>)}</select>:<input required={required.includes(f)} type={f==='password'?'password':'text'} value={form[f]} onChange={e=>setForm({...form,[f]:e.target.value})}/>}</Field>)}<button>{editing?'حفظ التعديل':'إضافة'}</button><button type="button" className="secondary" onClick={closeModal}>إلغاء</button></form></Modal></>}

const FIELD_LABELS={record_date:'التاريخ',villa_name:'الفيلا',apartment_no:'رقم الشقة',description:'الوصف',technician_name:'الفني',reported_time:'وقت الورود',completed_time:'وقت الانتهاء',spare_part:'قطعة الغيار',spare_part_cost:'التكلفة',name:'الاسم',area:'المنطقة',notes:'ملاحظات',floor:'الدور',specialty:'التخصص',phone:'الهاتف',email:'الإيميل',role:'الدور',created_by_name:'أضيف بواسطة',status:'الحالة',apartments_count:'عدد الشقق',is_active:'الحالة',issue_type:'نوع المشكلة',national_id:'رقم الهوية',tenant_name:'المستأجر',start_date:'بداية العقد',end_date:'نهاية العقد',total_amount:'إجمالي الإيجار',installments_count:'عدد الدفعات',collected_amount:'المحصّل',due_date:'تاريخ الاستحقاق',amount:'المبلغ',payment_date:'تاريخ الدفع',tenant_phone:'هاتف المستأجر'};
const ROLE_LABELS={ADMIN:'أدمن',SUPERVISOR:'مشرف'};
const ISSUE_TYPES=[['electricity','كهرباء'],['plumbing','سباكة'],['ac','تكييف'],['general','عام']];
const ISSUE_TYPE_LABELS=Object.fromEntries(ISSUE_TYPES);
const INST_STATUS_LABELS={collected:'تم التحصيل',overdue:'متأخرة',partial:'جزئي',due_soon:'قيد التحصيل',upcoming:'قادمة',cancelled:'مُلغاة',settled:'مُسوّاة'};
const INST_STATUS_CSS={collected:'status-on',overdue:'status-danger',partial:'status-partial',due_soon:'status-warn',upcoming:'status-off',cancelled:'status-cancelled',settled:'status-settled'};
function formatCell(c,v){if(c==='status'){if(INST_STATUS_LABELS[v])return <span className={'statusBadge '+INST_STATUS_CSS[v]}>{INST_STATUS_LABELS[v]}</span>;return <span className={'statusBadge '+(v==='مكتمل'?'status-on':'status-pending')}>{v}</span>}if(v===null||v===undefined||v==='')return'-';if(c==='record_date'||c==='start_date'||c==='end_date'||c==='due_date'||c==='payment_date'){const d=new Date(v);return`${d.getDate()} ${AR_MONTHS[d.getMonth()]} ${d.getFullYear()}`}if(c.endsWith('_time'))return String(v).slice(0,5);if(c==='spare_part_cost'||c==='total_amount'||c==='collected_amount'||c==='amount')return Number(v).toFixed(2)+' AED';if(c==='role')return <span className={'roleBadge role-'+v}>{ROLE_LABELS[v]||v}</span>;if(c==='is_active')return <span className={'statusBadge '+(v?'status-on':'status-off')}>{v?'فعّال':'موقوف'}</span>;if(c==='issue_type')return ISSUE_TYPE_LABELS[v]||v;return String(v)}
const PAGE_SIZE=10;
function Table({rows,cols,actions,searchable}){const[q,setQ]=useState('');const[page,setPage]=useState(0);const filtered=useMemo(()=>{if(!q)return rows;const s=q.trim().toLowerCase();return rows.filter(r=>cols.some(c=>String(r[c]??'').toLowerCase().includes(s)))},[rows,q,cols]);const pageCount=Math.max(1,Math.ceil(filtered.length/PAGE_SIZE));const pageRows=filtered.slice(page*PAGE_SIZE,page*PAGE_SIZE+PAGE_SIZE);useEffect(()=>{setPage(0)},[q,rows.length]);return <div>{searchable&&<input className="tableSearch" placeholder="بحث..." value={q} onChange={e=>setQ(e.target.value)}/>}<div className="table"><table><thead><tr>{cols.map(c=><th key={c}>{FIELD_LABELS[c]||c}</th>)}{actions&&<th></th>}</tr></thead><tbody>{pageRows.length===0&&<tr><td colSpan={cols.length+(actions?1:0)} className="empty">لا توجد بيانات</td></tr>}{pageRows.map(r=><tr key={r.id}>{cols.map(c=><td key={c} data-label={FIELD_LABELS[c]||c}>{formatCell(c,r[c])}</td>)}{actions&&<td data-label="" className="actionsCell">{actions(r)}</td>}</tr>)}</tbody></table></div>{pageCount>1&&<div className="pagination"><button type="button" disabled={page===0} onClick={()=>setPage(p=>p-1)}>السابق</button><span>{page+1} / {pageCount}</span><button type="button" disabled={page>=pageCount-1} onClick={()=>setPage(p=>p+1)}>التالي</button></div>}</div>}

function leaseStatus(l){const today=new Date().toISOString().slice(0,10);if(!l.is_active||l.end_date<today)return 'expired';return 'active';}
function InstTable({installments,isAdmin,leaseId,onAdd,onEdit,onDelete,onPayments}){return(
<div className="instTable">
  <div className="instTableHead"><span className="instTableTitle">الدفعات ({installments.length})</span><button className="secondary instTableAdd" onClick={()=>onAdd(leaseId)}><Plus size={12}/>إضافة</button></div>
  {installments.length===0?<p className="instTableEmpty">لا توجد دفعات</p>:
  <table className="instTbl"><thead><tr><th>التاريخ</th><th>المبلغ</th><th>التقدم</th><th>الحالة</th><th></th></tr></thead>
  <tbody>{installments.map(i=>{const pct=Number(i.amount)>0?Math.min(100,Number(i.collected_amount)/Number(i.amount)*100):0;return(
  <tr key={i.id}>
    <td className="instTblDate">{new Date(i.due_date).toLocaleDateString('ar-AE')}</td>
    <td className="instTblAmt">{Number(i.amount).toFixed(0)} <span className="instTblCur">AED</span></td>
    <td className="instTblBarCell"><div className="instTblBarWrap"><div className="instTblBar"><div className="instTblBarFill" style={{width:pct+'%'}}/></div><span className="instTblPct">{Math.round(pct)}%</span></div></td>
    <td><span className={'statusBadge statusBadgeSm '+INST_STATUS_CSS[i.status]}>{INST_STATUS_LABELS[i.status]}</span></td>
    <td className="instTblActions">
      <div className="instTblActionsWrap">
        <button className="secondary iconBtn" title="المدفوعات" onClick={()=>onPayments(i)}><DollarSign size={13}/></button>
        <button className="secondary iconBtn" onClick={()=>onEdit(i,leaseId)}><Edit size={13}/></button>
        {isAdmin&&<button className="danger iconBtn" onClick={()=>onDelete(i.id)}><Trash2 size={13}/></button>}
      </div>
    </td>
  </tr>);})}</tbody></table>}
</div>);}
const LEASE_STATUS_LABEL={active:'فعّال',expired:'منتهي'};
const LEASE_STATUS_CSS={active:'status-on',expired:'status-off'};

function TenantsMgmt({user}){
const api=useApi();const isAdmin=user?.role==='ADMIN';
const[rows,setRows]=useState([]);const[qs,setQs]=useState('');
const[villas,setVillas]=useState([]);const[apts,setApts]=useState([]);
const[selected,setSelected]=useState(null);
const empty={name:'',phone:'',national_id:'',email:'',notes:''};
const[form,setForm]=useState(empty);const[editing,setEditing]=useState(null);const[tenantOpen,setTenantOpen]=useState(false);
const emptyLease={apartment_id:'',_villa_id:'',start_date:'',end_date:'',total_amount:'',fees_amount:'',deposit_amount:'',deposit_type:'',deposit_notes:'',notes:''};
const[leaseForm,setLeaseForm]=useState(emptyLease);const[leaseOpen,setLeaseOpen]=useState(false);
const[instForm,setInstForm]=useState({due_date:'',amount:'',notes:''});const[instOpen,setInstOpen]=useState(false);const[editingInst,setEditingInst]=useState(null);const[targetLeaseId,setTargetLeaseId]=useState(null);
const[paymentsInst,setPaymentsInst]=useState(null);const[payments,setPayments]=useState([]);
const[payForm,setPayForm]=useState({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});const[payOpen,setPayOpen]=useState(false);

const load=()=>api('/tenants').then(setRows);
useEffect(()=>{load();api('/villas').then(setVillas);api('/apartments').then(setApts)},[]);

async function loadTenantLeases(tenantId){const leases=await api('/leases?tenant_id='+tenantId);const leasesDetail=await Promise.all((leases||[]).map(l=>api('/leases/'+l.id)));return leasesDetail;}
async function openTenant(t){const leasesDetail=await loadTenantLeases(t.id);setSelected({tenant:t,leasesDetail});}
async function reloadSelected(){if(!selected)return;const leasesDetail=await loadTenantLeases(selected.tenant.id);setSelected(s=>({...s,leasesDetail}));}

async function saveTenant(e){e.preventDefault();await runAction(async()=>{await api(editing?'/tenants/'+editing:'/tenants',{method:editing?'PUT':'POST',body:JSON.stringify(form)});setForm(empty);setEditing(null);setTenantOpen(false);load();if(selected&&editing===selected.tenant.id)setSelected(s=>({...s,tenant:{...s.tenant,...form}}))},editing?'تم حفظ التعديل':'تمت إضافة المستأجر')}
async function removeTenant(r){if(!confirm('تأكيد حذف المستأجر؟'))return;await runAction(async()=>{await api('/tenants/'+r.id,{method:'DELETE'});load();if(selected?.tenant.id===r.id)setSelected(null)},'تم الحذف')}
async function saveLease(e){e.preventDefault();await runAction(async()=>{const{_villa_id,...rest}=leaseForm;await api('/leases',{method:'POST',body:JSON.stringify({...rest,tenant_id:selected.tenant.id})});setLeaseForm(emptyLease);setLeaseOpen(false);reloadSelected()},'تمت إضافة العقد الجديد')}
async function saveInst(e){e.preventDefault();await runAction(async()=>{if(editingInst){await api('/installments/'+editingInst,{method:'PUT',body:JSON.stringify(instForm)})}else{await api('/leases/'+targetLeaseId+'/installments',{method:'POST',body:JSON.stringify(instForm)})}setInstForm({due_date:'',amount:'',notes:''});setEditingInst(null);setInstOpen(false);reloadSelected()},editingInst?'تم تعديل الدفعة':'تمت إضافة الدفعة')}
async function removeInst(id){if(!confirm('تأكيد حذف الدفعة؟'))return;await runAction(async()=>{await api('/installments/'+id,{method:'DELETE'});reloadSelected()},'تم الحذف')}
async function openPayments(inst){setPaymentsInst(inst);const p=await api('/installments/'+inst.id+'/payments');setPayments(p||[]);setPayOpen(true)}
async function addPayment(e){e.preventDefault();await runAction(async()=>{await api('/installments/'+paymentsInst.id+'/payments',{method:'POST',body:JSON.stringify(payForm)});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);setPayForm({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});reloadSelected()},'تم تسجيل الدفعة')}
async function removePayment(id){if(!confirm('تأكيد حذف هذا الدفع؟'))return;await runAction(async()=>{await api('/payments/'+id,{method:'DELETE'});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);reloadSelected()},'تم الحذف')}

const AVATAR_COLORS=['#0f766e','#0e7490','#1d4ed8','#7c3aed','#be185d','#b45309','#15803d','#dc2626'];
function avatarColor(name){let h=0;for(let i=0;i<name.length;i++)h=(h*31+name.charCodeAt(i))%AVATAR_COLORS.length;return AVATAR_COLORS[h];}

const filtered=rows.filter(r=>!qs||r.name.includes(qs)||(r.phone||'').includes(qs)||(r.national_id||'').includes(qs));

// ─── Detail view ───────────────────────────────────────────────
if(selected){
  const{tenant,leasesDetail}=selected;
  const sorted=[...leasesDetail].sort((a,b)=>new Date(b.lease.start_date)-new Date(a.lease.start_date));
  const totalCollected=leasesDetail.reduce((s,{installments})=>s+installments.reduce((ss,i)=>ss+Number(i.collected_amount),0),0);
  const totalAmount=leasesDetail.reduce((s,{lease})=>s+Number(lease.total_amount),0);
  const activeLeases=leasesDetail.filter(({lease})=>leaseStatus(lease)==='active').length;
  return <>
  <button type="button" className="pageBackBtn" onClick={()=>setSelected(null)}><ArrowRight size={16}/>رجوع</button>
  {/* Profile hero */}
  <div className="tenantProfile">
    <div className="tenantProfileBg"/>
    <div className="tenantProfileBody">
      <div className="tenantProfileMain">
        <div className="tenantProfileAvatarWrap">
          <div className="tenantProfileAvatar" style={{background:avatarColor(tenant.name)}}>{tenant.name[0]}</div>
          {activeLeases>0&&<span className="tenantProfileActiveDot"/>}
        </div>
        <div className="tenantProfileInfo">
          <h2 className="tenantProfileName">{tenant.name}</h2>
          <div className="tenantProfileContacts">
            {tenant.phone&&<span className="tenantProfileContact"><Phone size={13}/>{tenant.phone}</span>}
            {tenant.national_id&&<span className="tenantProfileContact"><CreditCard size={13}/>{tenant.national_id}</span>}
            {tenant.email&&<span className="tenantProfileContact"><Mail size={13}/>{tenant.email}</span>}
          </div>
        </div>
        <div className="tenantProfileActions">
          <button onClick={()=>setLeaseOpen(true)}><Plus size={15}/>عقد جديد</button>
          <button className="secondary" onClick={()=>{setEditing(tenant.id);setForm({name:tenant.name,phone:tenant.phone||'',national_id:tenant.national_id||'',email:tenant.email||'',notes:tenant.notes||''});setTenantOpen(true)}}><Edit size={15}/>تعديل</button>
          {isAdmin&&<button className="danger secondary iconBtn" onClick={()=>removeTenant(tenant)}><Trash2 size={15}/></button>}
        </div>
      </div>
      <div className="tenantProfileStats">
        <div className="tenantProfileStat"><span className="tenantProfileStatVal">{leasesDetail.length}</span><span className="tenantProfileStatLbl">إجمالي العقود</span></div>
        <div className="tenantProfileStatDiv"/>
        <div className="tenantProfileStat"><span className="tenantProfileStatVal" style={{color:'#15803d'}}>{activeLeases}</span><span className="tenantProfileStatLbl">عقد نشط</span></div>
        <div className="tenantProfileStatDiv"/>
        <div className="tenantProfileStat"><span className="tenantProfileStatVal" style={{color:'#15803d'}}>{totalCollected.toLocaleString()}</span><span className="tenantProfileStatLbl">محصّل (AED)</span></div>
        <div className="tenantProfileStatDiv"/>
        <div className="tenantProfileStat"><span className="tenantProfileStatVal" style={{color:(totalAmount-totalCollected)>0?'#dc2626':'#15803d'}}>{(totalAmount-totalCollected).toLocaleString()}</span><span className="tenantProfileStatLbl">متبقي (AED)</span></div>
      </div>
    </div>
  </div>

  {/* Leases */}
  <div className="tenantLeasesSection">
    {sorted.length===0?<div className="tenantLeasesEmpty"><Banknote size={32} style={{opacity:.3}}/><p>لا يوجد عقد بعد — اضغط "عقد جديد" للبدء</p></div>:
    sorted.map(({lease,installments},idx)=>{
      const st=leaseStatus(lease);
      const collected=installments.reduce((s,i)=>s+Number(i.collected_amount),0);
      const remaining=Number(lease.total_amount)-collected;
      const pct=Number(lease.total_amount)>0?Math.min(100,collected/Number(lease.total_amount)*100):0;
      return <div key={lease.id} className={'leaseBlock'+(st==='expired'?' leaseBlockExpired':'')}>
        <div className="leaseBlockStrip">
          <div className="leaseBlockMeta">
            {st==='active'?<span className="leaseBlockBadge leaseBlockBadgeActive">نشط</span>:<span className="leaseBlockBadge leaseBlockBadgeExpired">منتهي</span>}
            <span className="leaseBlockLocation"><Building2 size={13}/>{lease.villa_name} / {lease.apartment_no}</span>
            <span className="leaseBlockDates"><Calendar size={12}/>{new Date(lease.start_date).toLocaleDateString('ar-AE')} — {new Date(lease.end_date).toLocaleDateString('ar-AE')}</span>
          </div>
          <div className="leaseBlockFin">
            <span className="leaseBlockFinItem"><span className="leaseBlockFinVal">{Number(lease.total_amount).toLocaleString()}</span><span className="leaseBlockFinLbl">إجمالي</span></span>
            <span className="leaseBlockSep"/>
            <span className="leaseBlockFinItem"><span className="leaseBlockFinVal leaseBlockFinGreen">{collected.toLocaleString()}</span><span className="leaseBlockFinLbl">محصّل</span></span>
            <span className="leaseBlockSep"/>
            <span className="leaseBlockFinItem"><span className={'leaseBlockFinVal'+(remaining>0?' leaseBlockFinRed':'')}>{remaining.toLocaleString()}</span><span className="leaseBlockFinLbl">متبقي</span></span>
          </div>
        </div>
        <div className="leaseBlockBar"><div className="leaseBlockBarFill" style={{width:pct+'%'}}/></div>
        <InstTable installments={installments} isAdmin={isAdmin} leaseId={lease.id}
          onAdd={id=>{setTargetLeaseId(id);setEditingInst(null);setInstForm({due_date:'',amount:'',notes:''});setInstOpen(true)}}
          onEdit={(i,lid)=>{setTargetLeaseId(lid);setEditingInst(i.id);setInstForm({due_date:String(i.due_date).slice(0,10),amount:i.amount,notes:i.notes||''});setInstOpen(true)}}
          onDelete={removeInst} onPayments={openPayments}/>
      </div>;
    })}
  </div>

  <Modal open={leaseOpen} onClose={()=>setLeaseOpen(false)} title="إضافة عقد إيجار جديد"><form className="form" onSubmit={saveLease}>
    <Field label="الفيلا" required><select required value={leaseForm._villa_id} onChange={e=>setLeaseForm({...leaseForm,_villa_id:e.target.value,apartment_id:''})}><option value="">اختر الفيلا</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
    <Field label="الشقة" required><select required value={leaseForm.apartment_id} onChange={e=>setLeaseForm({...leaseForm,apartment_id:e.target.value})} disabled={!leaseForm._villa_id}><option value="">اختر الشقة</option>{apts.filter(a=>a.villa_id==leaseForm._villa_id).map(a=><option key={a.id} value={a.id}>{a.apartment_no}</option>)}</select></Field>
    <LeaseFormFields form={leaseForm} setForm={setLeaseForm} tenants={rows}/>
    <button><Plus size={16}/>إضافة العقد</button><button type="button" className="secondary" onClick={()=>setLeaseOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
    <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
    <Field label="المبلغ (AED)" required><input required type="number" min="0.01" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
    <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
    <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات دفعة: ${Number(paymentsInst?.amount||0).toFixed(2)} AED`}>
    {paymentsInst&&<div className="paymentsModal">
      <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toFixed(2)} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
      <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
        <Field label="المبلغ المدفوع (AED)" required><input required type="number" min="0.01" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
        <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
        <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
        <button><Plus size={14}/>تسجيل دفع</button>
      </form>
    </div>}
  </Modal>
  <Modal open={tenantOpen} onClose={()=>setTenantOpen(false)} title={editing?'تعديل مستأجر':'إضافة مستأجر'}><form className="form compact" onSubmit={saveTenant}>
    <Field label="الاسم" required><input required value={form.name} onChange={e=>setForm({...form,name:e.target.value})}/></Field>
    <Field label="الهاتف"><input value={form.phone} onChange={e=>setForm({...form,phone:e.target.value})}/></Field>
    <Field label="رقم الهوية"><input value={form.national_id} onChange={e=>setForm({...form,national_id:e.target.value})}/></Field>
    <Field label="الإيميل"><input type="email" value={form.email} onChange={e=>setForm({...form,email:e.target.value})}/></Field>
    <Field label="ملاحظات" wide><textarea value={form.notes} onChange={e=>setForm({...form,notes:e.target.value})}/></Field>
    <button>{editing?'حفظ التعديل':'إضافة'}</button><button type="button" className="secondary" onClick={()=>setTenantOpen(false)}>إلغاء</button>
  </form></Modal>
  </>
}

// ─── List view ───────────────────────────────────────────────
return <>
<div className="tenantListHeader">
  <div className="tenantListTitle"><UserCheck size={20}/><h2>المستأجرين</h2><span className="tenantListCount">{rows.length}</span></div>
  <div className="tenantListActions">
    <div className="tenantSearch"><input placeholder="بحث بالاسم أو الهاتف..." value={qs} onChange={e=>setQs(e.target.value)}/></div>
    <button onClick={()=>{setEditing(null);setForm(empty);setTenantOpen(true)}}><Plus size={16}/>إضافة مستأجر</button>
  </div>
</div>

{filtered.length===0&&<div className="tenantEmpty"><UserCheck size={36} style={{opacity:.2}}/><p>{qs?'لا توجد نتائج مطابقة':'لا يوجد مستأجرين بعد'}</p></div>}

<div className="tenantRows">
{filtered.map((r,i)=><div key={r.id} className="tenantRow" onClick={()=>openTenant(r)}>
  <span className="tenantRowIdx">{i+1}</span>
  <div className="tenantRowAvatar" style={{background:avatarColor(r.name)}}>{r.name[0]}</div>
  <div className="tenantRowMain">
    <span className="tenantRowName">{r.name}</span>
    <div className="tenantRowMeta">
      {r.phone&&<span className="tenantRowMetaItem"><Phone size={11}/>{r.phone}</span>}
      {r.national_id&&<span className="tenantRowMetaItem"><CreditCard size={11}/>{r.national_id}</span>}
      {r.email&&<span className="tenantRowMetaItem"><Mail size={11}/>{r.email}</span>}
    </div>
  </div>
  <div className="tenantRowActions" onClick={e=>e.stopPropagation()}>
    <button className="tenantRowViewBtn" onClick={e=>{e.stopPropagation();openTenant(r)}}><Eye size={13}/>العقود</button>
    <button className="iconBtn secondary" onClick={e=>{e.stopPropagation();setEditing(r.id);setForm({name:r.name,phone:r.phone||'',national_id:r.national_id||'',email:r.email||'',notes:r.notes||''});setTenantOpen(true)}}><Edit size={13}/></button>
    {isAdmin&&<button className="iconBtn danger" onClick={e=>{e.stopPropagation();removeTenant(r)}}><Trash2 size={13}/></button>}
  </div>
</div>)}
</div>

<Modal open={tenantOpen} onClose={()=>setTenantOpen(false)} title={editing?'تعديل مستأجر':'إضافة مستأجر'}><form className="form compact" onSubmit={saveTenant}>
  <Field label="الاسم" required><input required value={form.name} onChange={e=>setForm({...form,name:e.target.value})}/></Field>
  <Field label="الهاتف"><input value={form.phone} onChange={e=>setForm({...form,phone:e.target.value})}/></Field>
  <Field label="رقم الهوية"><input value={form.national_id} onChange={e=>setForm({...form,national_id:e.target.value})}/></Field>
  <Field label="الإيميل"><input type="email" value={form.email} onChange={e=>setForm({...form,email:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={form.notes} onChange={e=>setForm({...form,notes:e.target.value})}/></Field>
  <button>{editing?'حفظ التعديل':'إضافة'}</button><button type="button" className="secondary" onClick={()=>setTenantOpen(false)}>إلغاء</button>
</form></Modal>
</>
}

function Leases({user}){
const api=useApi();const isAdmin=user?.role==='ADMIN';
const[rows,setRows]=useState([]);const[tenants,setTenants]=useState([]);const[apts,setApts]=useState([]);const[villas,setVillas]=useState([]);
const[selectedLease,setSelectedLease]=useState(null);const[leaseDetail,setLeaseDetail]=useState(null);
const[qs,setQs]=useState('');const[statusFilter,setStatusFilter]=useState('all');
const empty={apartment_id:'',tenant_id:'',start_date:'',end_date:'',total_amount:'',fees_amount:'',deposit_amount:'',deposit_type:'',deposit_notes:'',notes:'',is_active:1,_villa_id:''};
const[form,setForm]=useState(empty);const[editing,setEditing]=useState(null);const[open,setOpen]=useState(false);
const[instForm,setInstForm]=useState({due_date:'',amount:'',notes:''});const[instOpen,setInstOpen]=useState(false);const[editingInst,setEditingInst]=useState(null);
const[paymentsInst,setPaymentsInst]=useState(null);const[payments,setPayments]=useState([]);
const[payForm,setPayForm]=useState({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});const[payOpen,setPayOpen]=useState(false);
const[terminateOpen,setTerminateOpen]=useState(false);const[terminateDate,setTerminateDate]=useState('');
const[extraDeductions,setExtraDeductions]=useState([]);const[extraDesc,setExtraDesc]=useState('');const[extraAmt,setExtraAmt]=useState('');
const[openVilla,setOpenVilla]=useState(null);
const toggleLeaseVilla=id=>setOpenVilla(prev=>prev===id?null:id);

const load=()=>api('/leases').then(setRows);
const loadDetail=(id)=>api('/leases/'+id).then(d=>{setLeaseDetail(d);setSelectedLease(id)});
useEffect(()=>{load();api('/tenants').then(setTenants);api('/apartments').then(setApts);api('/villas').then(setVillas)},[]);

async function saveLease(e){e.preventDefault();await runAction(async()=>{const{_villa_id,...rest}=form;await api(editing?'/leases/'+editing:'/leases',{method:editing?'PUT':'POST',body:JSON.stringify(rest)});setForm(empty);setEditing(null);setOpen(false);load();if(selectedLease)loadDetail(selectedLease)},editing?'تم حفظ التعديل':'تمت إضافة العقد')}
async function removeLease(r){if(!confirm('تأكيد حذف العقد؟'))return;await runAction(async()=>{await api('/leases/'+r.id,{method:'DELETE'});load();if(selectedLease===r.id){setSelectedLease(null);setLeaseDetail(null)}},'تم حذف العقد')}
async function saveInst(e){e.preventDefault();await runAction(async()=>{if(editingInst){await api('/installments/'+editingInst,{method:'PUT',body:JSON.stringify(instForm)})}else{await api('/leases/'+selectedLease+'/installments',{method:'POST',body:JSON.stringify(instForm)})}setInstForm({due_date:'',amount:'',notes:''});setEditingInst(null);setInstOpen(false);loadDetail(selectedLease)},editingInst?'تم تعديل الدفعة':'تمت إضافة الدفعة')}
async function removeInst(id){if(!confirm('تأكيد حذف الدفعة؟'))return;await runAction(async()=>{await api('/installments/'+id,{method:'DELETE'});loadDetail(selectedLease)},'تم الحذف')}
async function openPayments(inst){setPaymentsInst(inst);const p=await api('/installments/'+inst.id+'/payments');setPayments(p||[]);setPayOpen(true)}
async function addPayment(e){e.preventDefault();await runAction(async()=>{await api('/installments/'+paymentsInst.id+'/payments',{method:'POST',body:JSON.stringify(payForm)});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);setPayForm({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});loadDetail(selectedLease)},'تم تسجيل الدفعة')}
async function removePayment(id){if(!confirm('تأكيد حذف هذا الدفع؟'))return;await runAction(async()=>{await api('/payments/'+id,{method:'DELETE'});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);loadDetail(selectedLease)},'تم الحذف')}

const today=new Date().toISOString().slice(0,10);
const filtered=rows.filter(r=>{
  const st=r.is_active&&r.end_date>=today?'active':'expired';
  if(statusFilter==='active'&&st!=='active')return false;
  if(statusFilter==='expired'&&st!=='expired')return false;
  if(qs&&!r.tenant_name?.includes(qs)&&!r.villa_name?.includes(qs)&&!r.apartment_no?.includes(qs))return false;
  return true;
});
const totalAmount=rows.reduce((s,r)=>s+Number(r.total_amount||0),0);
const totalCollected=rows.reduce((s,r)=>s+Number(r.collected_amount||0),0);
const activeCount=rows.filter(r=>r.is_active&&r.end_date>=today).length;

// ─── Detail view ───────────────────────────────────────────────
if(selectedLease&&leaseDetail){
  const{lease,installments}=leaseDetail;
  const st=lease.is_active&&lease.end_date>=today?'active':'expired';
  const collected=installments.reduce((s,i)=>s+Number(i.collected_amount),0);
  const remaining=Number(lease.total_amount)-collected;
  const pct=Number(lease.total_amount)>0?Math.min(100,Math.round(collected/Number(lease.total_amount)*100)):0;
  const overdueCount=installments.filter(i=>i.status==='overdue').length;
  return <>
  <button className="pageBackBtn" onClick={()=>{setSelectedLease(null);setLeaseDetail(null)}}><ArrowRight size={16}/>رجوع</button>
  <div className="leaseDetailPage">
    {/* Hero Card */}
    <div className="ldCard">
      {/* Top row: identity + actions */}
      <div className="ldCardTop">
        <div className="ldCardLeft">
          <div className="ldCardBadges">
            <span className={st==='active'?'leaseBlockBadge leaseBlockBadgeActive':'leaseBlockBadge leaseBlockBadgeExpired'}>{st==='active'?'نشط':'منتهي'}</span>
            {overdueCount>0&&<span className="ldOverdueBadge"><AlertCircle size={11}/>{overdueCount} دفعة متأخرة</span>}
          </div>
          <h2 className="ldCardName">{lease.tenant_name}</h2>
          <div className="ldCardMeta">
            <span><Building2 size={12}/>{lease.villa_name} — شقة {lease.apartment_no}</span>
            <span className="ldCardMetaSep"/>
            <span><Calendar size={12}/>{new Date(lease.start_date).toLocaleDateString('ar-AE')} — {new Date(lease.end_date).toLocaleDateString('ar-AE')}</span>
          </div>
          {Number(lease.deposit_amount)>0&&<div className="ldDepositChip">
            <Shield size={12}/>
            <span>تأمين: {Number(lease.deposit_amount).toLocaleString()} AED</span>
            {lease.deposit_type&&<span className="ldDepositType">{lease.deposit_type==='cash'?'كاش':'شيك'}</span>}
            {lease.deposit_notes&&<span className="ldDepositNotes">— {lease.deposit_notes}</span>}
          </div>}
        </div>
        <div className="ldCardActions">
          <button onClick={()=>{setInstOpen(true);setEditingInst(null);setInstForm({due_date:'',amount:'',notes:''})}}><Plus size={14}/>إضافة دفعة</button>
          <button className="secondary" onClick={()=>{setEditing(lease.id);setForm({apartment_id:lease.apartment_id,tenant_id:lease.tenant_id,start_date:String(lease.start_date).slice(0,10),end_date:String(lease.end_date).slice(0,10),total_amount:lease.total_amount,fees_amount:lease.fees_amount||'',deposit_amount:lease.deposit_amount||'',deposit_type:lease.deposit_type||'',deposit_notes:lease.deposit_notes||'',notes:lease.notes||'',is_active:lease.is_active,_villa_id:''});setOpen(true)}}><Edit size={14}/>تعديل</button>
          {lease.terminated_at
            ? <span className="ldTerminatedBadge"><X size={13}/>عقد منتهٍ في {String(lease.terminated_at).slice(0,10)}</span>
            : isAdmin&&<button className="secondary ldTerminateBtn" onClick={()=>{setTerminateDate('');setTerminateOpen(true)}}><X size={14}/>إنهاء العقد</button>}
          {isAdmin&&<button className="iconBtn danger secondary" onClick={()=>removeLease(lease)}><Trash2 size={14}/></button>}
        </div>
      </div>
      {/* Stats row */}
      <div className="ldCardStats">
        <div className="ldStat"><span className="ldStatLbl">إجمالي الإيجار</span><span className="ldStatVal">{Number(lease.total_amount).toLocaleString()} <em>AED</em></span></div>
        <div className="ldStat ldStatGreen"><span className="ldStatLbl">تم التحصيل</span><span className="ldStatVal">{collected.toLocaleString()} <em>AED</em></span></div>
        <div className={'ldStat'+(remaining>0?' ldStatRed':' ldStatGreen')}><span className="ldStatLbl">المتبقي</span><span className="ldStatVal">{remaining.toLocaleString()} <em>AED</em></span></div>
        <div className="ldStat ldStatBlue"><span className="ldStatLbl">نسبة التحصيل</span><span className="ldStatVal ldStatBig">{pct}%</span></div>
      </div>
      {/* Progress */}
      <div className="ldProgressWrap">
        <div className="ldProgressTrack"><div className="ldProgressFill" style={{width:pct+'%',background:st==='expired'?'#94a3b8':'linear-gradient(90deg,#0f766e,#0e7490)'}}/></div>
        <span className="ldProgressLabel">{pct}% مكتمل</span>
      </div>
    </div>
    {/* Installments */}
    <div className="leaseDetailInstSection">
      <InstTable installments={installments} isAdmin={isAdmin} leaseId={lease.id}
        onAdd={id=>{setEditingInst(null);setInstForm({due_date:'',amount:'',notes:''});setInstOpen(true)}}
        onEdit={(i)=>{setEditingInst(i.id);setInstForm({due_date:String(i.due_date).slice(0,10),amount:i.amount,notes:i.notes||''});setInstOpen(true)}}
        onDelete={removeInst} onPayments={openPayments}/>
    </div>
  </div>

  <Modal open={open} onClose={()=>setOpen(false)} title="تعديل عقد"><form className="form" onSubmit={saveLease}>
    <LeaseFormFields form={form} setForm={setForm} tenants={tenants}/>
    <Field label="الحالة"><select value={form.is_active} onChange={e=>setForm({...form,is_active:Number(e.target.value)})}><option value={1}>فعّال</option><option value={0}>منتهي</option></select></Field>
    <button><Plus size={16}/>حفظ التعديل</button><button type="button" className="secondary" onClick={()=>setOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
    <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
    <Field label="المبلغ (AED)" required><input required type="number" min="0.01" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
    <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
    <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات: ${Number(paymentsInst?.amount||0).toLocaleString()} AED`}>
    {paymentsInst&&<div className="paymentsModal">
      <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toLocaleString()} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
      <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
        <Field label="المبلغ المدفوع (AED)" required><input required type="number" min="0.01" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
        <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
        <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
        <button><Plus size={14}/>تسجيل دفع</button>
      </form>
    </div>}
  </Modal>
  {/* ── Terminate Modal ── */}
  {(()=>{
    if(!terminateOpen||!leaseDetail)return null;
    const{lease,installments}=leaseDetail;
    const tDate=terminateDate?new Date(terminateDate):null;
    const startDate=new Date(String(lease.start_date).slice(0,10));
    const endDate=new Date(String(lease.end_date).slice(0,10));
    const totalDays=Math.round((endDate-startDate)/(1000*60*60*24));
    const usedDays=tDate?Math.max(0,Math.round((tDate-startDate)/(1000*60*60*24))):0;
    const totalAmt=Number(lease.total_amount);
    const amtForUsedDays=totalDays>0?Math.round((usedDays/totalDays)*totalAmt*100)/100:0;
    const activeInsts=installments.filter(i=>i.status!=='cancelled');
    const alreadyCollected=activeInsts.reduce((s,i)=>s+Math.max(0,Number(i.collected_amount)),0);
    const unpaidInsts=activeInsts.filter(i=>i.status!=='collected');
    const depositType=lease.deposit_type;
    // only CASH deposits enter the settlement equation — checks are returned as-is
    const isCashDeposit=depositType==='cash';
    const depositAmt=isCashDeposit?Number(lease.deposit_amount||0):0;
    const rawDepositAmt=Number(lease.deposit_amount||0);
    const balance=alreadyCollected-amtForUsedDays;
    const tenantOwes=balance<0;
    const totalExtra=extraDeductions.reduce((s,d)=>s+Number(d.amt),0);
    // deposit settlement (cash only)
    const depositAfterRentBalance=depositAmt>0?(tenantOwes?depositAmt-Math.abs(balance):depositAmt+Math.abs(balance)):null;
    const depositAfterAll=depositAmt>0?(depositAfterRentBalance-totalExtra):null;
    const depositTypeLabel=depositType==='cash'?'كاش':depositType==='check'?'شيك':'';
    return <Modal open={terminateOpen} onClose={()=>{setTerminateOpen(false);setExtraDeductions([]);setExtraDesc('');setExtraAmt('');}} title="إنهاء العقد مبكراً">
      <div className="terminateModal">
        <Field label="تاريخ الإنهاء" required>
          <input type="date" value={terminateDate}
            min={String(lease.start_date).slice(0,10)}
            max={String(lease.end_date).slice(0,10)}
            onChange={e=>setTerminateDate(e.target.value)}/>
        </Field>
        {tDate&&<>
          {/* Days calc */}
          <div className="terminateCalcBox">
            <div className="terminateCalcRow"><span>مدة العقد الكاملة</span><strong>{totalDays} يوم</strong></div>
            <div className="terminateCalcRow"><span>أيام الإقامة الفعلية</span><strong>{usedDays} يوم</strong></div>
            <div className="terminateCalcRow"><span>الأيام المتبقية</span><strong>{Math.max(0,totalDays-usedDays)} يوم</strong></div>
            <div className="terminateCalcDivider"/>
            <div className="terminateCalcRow"><span>الإجمالي الأصلي</span><strong>{totalAmt.toLocaleString()} AED</strong></div>
            <div className="terminateCalcRow terminateCalcHighlight"><span>المستحق عن {usedDays} يوم</span><strong>{amtForUsedDays.toLocaleString()} AED</strong></div>
            <div className="terminateCalcRow"><span>تم تحصيله فعلاً</span><strong style={{color:'#15803d'}}>{alreadyCollected.toLocaleString()} AED</strong></div>
          </div>
          {/* Unpaid installments */}
          {unpaidInsts.length>0&&<div className="terminateUnpaid">
            <div className="terminateUnpaidTitle">دفعات لم تُحصَّل ({unpaidInsts.length})</div>
            {unpaidInsts.map(i=><div key={i.id} className="terminateUnpaidRow">
              <span>{String(i.due_date).slice(0,10)}</span>
              <span className={'statusBadge statusBadgeSm '+INST_STATUS_CSS[i.status]}>{INST_STATUS_LABELS[i.status]}</span>
              <span>{Number(i.amount).toLocaleString()} AED</span>
              <span style={{color:'#dc2626'}}>محصّل: {Number(i.collected_amount).toLocaleString()}</span>
            </div>)}
          </div>}
          {/* Rent balance result */}
          <div className={'terminateResult'+(tenantOwes?' terminateResultOwes':' terminateResultRefund')}>
            <div className="terminateResultIcon">{tenantOwes?'⚠️':'✅'}</div>
            <div style={{flex:1}}>
              <div className="terminateResultTitle">{tenantOwes?'فرق الإيجار — المستأجر مدين بـ':'فرق الإيجار — مبلغ مسترد للمستأجر'}</div>
              <div className="terminateResultAmt">{Math.abs(balance).toLocaleString()} AED</div>
              <div className="terminateResultSub">{tenantOwes?`دفع ${alreadyCollected.toLocaleString()} والمستحق ${amtForUsedDays.toLocaleString()}`:`دفع ${alreadyCollected.toLocaleString()} والمستحق ${amtForUsedDays.toLocaleString()} فقط`}</div>
            </div>
          </div>
          {/* Deposit section */}
          {depositAmt>0&&<div className="terminateDepositSection">
            <div className="terminateDepositHeader"><Shield size={14}/>التأمين ({depositTypeLabel}) — {depositAmt.toLocaleString()} AED</div>
            {/* Rent balance deduction */}
            <div className="terminateDepositLine">
              <span>{tenantOwes?'خصم فرق الإيجار':'إضافة فرق الإيجار'}</span>
              <span style={{color:tenantOwes?'#dc2626':'#15803d'}}>{tenantOwes?'−':'+‎'}{Math.abs(balance).toLocaleString()} AED</span>
            </div>
            {/* Extra deductions */}
            {extraDeductions.map((d,i)=><div key={i} className="terminateDepositLine">
              <span>{d.desc}</span>
              <div style={{display:'flex',align:'center',gap:8}}>
                <span style={{color:'#dc2626'}}>−{Number(d.amt).toLocaleString()} AED</span>
                <button type="button" className="iconBtn danger" style={{padding:'2px 6px'}} onClick={()=>setExtraDeductions(p=>p.filter((_,j)=>j!==i))}><X size={11}/></button>
              </div>
            </div>)}
            {/* Add deduction */}
            <div className="terminateAddDeduction">
              <input className="terminateAddDesc" placeholder="وصف الخصم (تلف، تنظيف...)" value={extraDesc} onChange={e=>setExtraDesc(e.target.value)}/>
              <input className="terminateAddAmt" type="number" min="0" step="0.01" placeholder="المبلغ" value={extraAmt} onChange={e=>setExtraAmt(e.target.value)}/>
              <button type="button" className="secondary" onClick={()=>{if(!extraDesc||!extraAmt)return;setExtraDeductions(p=>[...p,{desc:extraDesc,amt:extraAmt}]);setExtraDesc('');setExtraAmt('');}}><Plus size={13}/>إضافة</button>
            </div>
            {/* Final deposit result */}
            <div className={'terminateDepositResult'+(depositAfterAll>=0?' terminateDepositResultPos':' terminateDepositResultNeg')}>
              <span className="terminateDepositResultLbl">{depositAfterAll>=0?'صافي التأمين المُرد للمستأجر':'مبلغ إضافي على المستأجر بعد التأمين'}</span>
              <span className="terminateDepositResultVal">{Math.abs(depositAfterAll).toLocaleString()} AED</span>
            </div>
          </div>}
          {/* Check deposit — informational only, not part of settlement */}
          {!isCashDeposit&&rawDepositAmt>0&&<div className="terminateCheckNote">
            <Shield size={14}/>
            <span>التأمين بشيك ({rawDepositAmt.toLocaleString()} AED) لا يدخل في التسوية — يُعاد الشيك للمستأجر بشكل منفصل.</span>
          </div>}
          {/* ── Preview of what will happen ── */}
          {(()=>{
            const collectedInsts=activeInsts.filter(i=>i.status==='collected');
            const toCancel=unpaidInsts;
            const finalOwes=depositAmt>0?depositAfterAll<0:tenantOwes;
            const finalAmt=depositAmt>0?Math.abs(depositAfterAll??0):Math.abs(balance);
            // compute cascade deductions newest→oldest
            const cascadeDeductions=[];
            if(!finalOwes&&finalAmt>0){
              let rem=finalAmt;
              const sorted=[...collectedInsts].sort((a,b)=>String(b.due_date).localeCompare(String(a.due_date)));
              for(const inst of sorted){
                if(rem<=0)break;
                const paid=Number(inst.collected_amount);
                const deduct=Math.min(rem,paid);
                cascadeDeductions.push({inst,deduct,fullyCleared:deduct>=paid});
                rem=Math.round((rem-deduct)*100)/100;
              }
            }
            const affectedIds=new Set(cascadeDeductions.map(c=>c.inst.id));
            // build unified sorted list
            const allRows=[
              ...collectedInsts.filter(i=>!affectedIds.has(i.id)).map(i=>({
                key:'ok-'+i.id, date:String(i.due_date).slice(0,10), cls:'tpRowOk', icon:'✓',
                label:'دفعة '+String(i.due_date).slice(0,10),
                sub:'محصّل: '+Number(i.collected_amount).toLocaleString()+' AED من أصل '+Number(i.amount).toLocaleString(),
                action:'بدون تغيير'
              })),
              ...cascadeDeductions.map(({inst,deduct,fullyCleared})=>({
                key:'adj-'+inst.id, date:String(inst.due_date).slice(0,10), cls:'tpRowAdj', icon:'↩',
                label:'دفعة '+String(inst.due_date).slice(0,10),
                sub:'سيُخصم منها '+deduct.toLocaleString()+' AED '+(fullyCleared?'(تُصفَّر بالكامل)':'(جزء منها)')+' — كان محصّلاً '+Number(inst.collected_amount).toLocaleString(),
                action:fullyCleared?'تُصفَّر كاملاً':'خصم جزئي'
              })),
              ...toCancel.map(i=>({
                key:'cancel-'+i.id, date:String(i.due_date).slice(0,10), cls:'tpRowCancel', icon:'✕',
                label:'دفعة '+String(i.due_date).slice(0,10),
                sub:Number(i.amount).toLocaleString()+' AED'+(Number(i.collected_amount)>0?' — محصّل جزئياً: '+Number(i.collected_amount).toLocaleString():' — لم تُحصَّل'),
                action:'ستُلغى'
              })),
              ...(finalOwes&&finalAmt>0?[{
                key:'new', date:terminateDate, cls:'tpRowNew', icon:'+',
                label:'دفعة تسوية — '+terminateDate,
                sub:'مبلغ مستحق على المستأجر عند الإنهاء',
                action:finalAmt.toLocaleString()+' AED'
              }]:[])
            ].sort((a,b)=>a.date.localeCompare(b.date));
            return <div className="tpPreview">
              <div className="tpPreviewTitle"><ListChecks size={14}/>ملخص ما سيتم تطبيقه عند التأكيد</div>
              {allRows.map(r=><div key={r.key} className={'tpRow '+r.cls}>
                <div className="tpRowIcon">{r.icon}</div>
                <div className="tpRowBody">
                  <span className="tpRowDate">{r.label}</span>
                  <span className="tpRowSub">{r.sub}</span>
                </div>
                <div className="tpRowAction">{r.action}</div>
              </div>)}
            </div>;
          })()}
        </>}
        {tDate&&<button type="button" style={{width:'100%',marginTop:4,background:'#0369a1',color:'#fff',border:'none',borderRadius:9,padding:'10px 0',fontWeight:700,fontSize:13,display:'flex',alignItems:'center',justifyContent:'center',gap:7,cursor:'pointer'}} onClick={()=>{
          const rows2=[
            ['مدة العقد الكاملة',totalDays+' يوم'],
            ['أيام الإقامة الفعلية',usedDays+' يوم'],
            ['الأيام المتبقية',Math.max(0,totalDays-usedDays)+' يوم'],
            ['إجمالي الإيجار الأصلي',totalAmt.toLocaleString()+' AED'],
            ['المستحق عن '+usedDays+' يوم',amtForUsedDays.toLocaleString()+' AED'],
            ['تم تحصيله فعلاً',alreadyCollected.toLocaleString()+' AED'],
          ];
          const balanceRow=tenantOwes
            ?`<tr style="background:#fef2f2"><td>فرق الإيجار (مدين)</td><td style="color:#dc2626;font-weight:700">${Math.abs(balance).toLocaleString()} AED</td></tr>`
            :`<tr style="background:#f0fdf4"><td>فرق الإيجار (مسترد)</td><td style="color:#15803d;font-weight:700">${Math.abs(balance).toLocaleString()} AED</td></tr>`;
          const depRows=depositAmt>0?`
            <tr style="background:#e0f2fe"><td colspan="2" style="font-weight:700;color:#0369a1;padding:10px 12px">التأمين (${depositTypeLabel}) — ${depositAmt.toLocaleString()} AED</td></tr>
            <tr><td>${tenantOwes?'خصم فرق الإيجار':'إضافة فرق الإيجار'}</td><td style="color:${tenantOwes?'#dc2626':'#15803d'}">${tenantOwes?'−':'+'}${Math.abs(balance).toLocaleString()} AED</td></tr>
            ${extraDeductions.map(d=>`<tr><td>${d.desc}</td><td style="color:#dc2626">−${Number(d.amt).toLocaleString()} AED</td></tr>`).join('')}
            <tr style="background:${depositAfterAll>=0?'#dcfce7':'#fef2f2'}"><td style="font-weight:700">${depositAfterAll>=0?'صافي التأمين المُرد':'مبلغ إضافي على المستأجر'}</td><td style="font-weight:900;font-size:16px;color:${depositAfterAll>=0?'#15803d':'#dc2626'}">${Math.abs(depositAfterAll).toLocaleString()} AED</td></tr>
          `:'';
          const unpaidHtml=unpaidInsts.length>0?`
            <h3 style="margin:18px 0 8px;font-size:13px;color:#1e3a5f">دفعات لم تُحصَّل (${unpaidInsts.length})</h3>
            <table style="width:100%;border-collapse:collapse;font-size:12px">
              <thead><tr style="background:#1e3a5f;color:#fff"><th style="padding:7px 10px">تاريخ الاستحقاق</th><th>المبلغ</th><th>محصّل</th><th>الحالة</th></tr></thead>
              <tbody>${unpaidInsts.map(i=>`<tr style="border-bottom:1px solid #e5e7eb"><td style="padding:6px 10px">${String(i.due_date).slice(0,10)}</td><td>${Number(i.amount).toLocaleString()} AED</td><td style="color:#dc2626">${Number(i.collected_amount).toLocaleString()} AED</td><td>${INST_STATUS_LABELS[i.status]}</td></tr>`).join('')}</tbody>
            </table>`:'';
          const html=`<!doctype html><html dir="rtl" lang="ar"><head><meta charset="utf-8"><title>تسوية إنهاء عقد — ${lease.tenant_name}</title>
          <style>*{box-sizing:border-box;margin:0;padding:0}body{font-family:Tahoma,Arial,sans-serif;padding:30px;color:#1a1a1a;direction:rtl}
          h1{font-size:18px;color:#1e3a5f;margin-bottom:4px}
          .sub{font-size:12px;color:#666;margin-bottom:18px}
          table{width:100%;border-collapse:collapse;font-size:13px}
          td,th{padding:8px 12px;border:1px solid #e5e7eb;text-align:right}
          thead tr{background:#1e3a5f;color:#fff}
          tr:nth-child(even){background:#f9fafb}
          .print-btn{display:block;margin:20px auto;padding:10px 30px;background:#1e3a5f;color:#fff;border:none;border-radius:8px;font-size:14px;cursor:pointer;font-family:Tahoma}
          @media print{.print-btn{display:none}}
          </style></head><body>
          <h1>وثيقة تسوية إنهاء عقد إيجار</h1>
          <div class="sub">المستأجر: <strong>${lease.tenant_name}</strong> &nbsp;|&nbsp; تاريخ الإنهاء: <strong>${terminateDate}</strong> &nbsp;|&nbsp; بداية العقد: ${String(lease.start_date).slice(0,10)} &nbsp;|&nbsp; نهاية العقد: ${String(lease.end_date).slice(0,10)}</div>
          <table><thead><tr><th>البيان</th><th>القيمة</th></tr></thead><tbody>
          ${rows2.map(([k,v])=>`<tr><td>${k}</td><td>${v}</td></tr>`).join('')}
          ${balanceRow}${depRows}
          </tbody></table>
          ${unpaidHtml}
          <button class="print-btn" onclick="window.print()">طباعة / حفظ PDF</button>
          </body></html>`;
          const blob=new Blob([html],{type:'text/html;charset=utf-8'});
          const url=URL.createObjectURL(blob);
          const w=window.open(url,'_blank');
          if(w)w.onload=()=>{w.focus();w.print();URL.revokeObjectURL(url);};
        }}><Printer size={14}/>طباعة / حفظ PDF</button>}
        {tDate&&<button type="button" style={{width:'100%',marginTop:4,background:'#b91c1c',color:'#fff',border:'none',borderRadius:9,padding:'11px 0',fontWeight:700,fontSize:13,display:'flex',alignItems:'center',justifyContent:'center',gap:7,cursor:'pointer'}} onClick={async()=>{
          if(!window.confirm(`تأكيد إنهاء العقد بتاريخ ${terminateDate}؟\nسيتم إلغاء الدفعات غير المحصّلة وتسجيل التسوية المالية.`))return;
          // ── separate the two money channels ──
          // rent channel: overpayment → cascade refund; shortfall → owed (minus cash deposit cover)
          const rentDebt=tenantOwes?Math.abs(balance):0;          // rent under-paid
          const cascadeRefund=!tenantOwes?Math.abs(balance):0;    // rent over-paid → reverse from installments
          // deposit (cash only) absorbs rent debt + extra deductions; remainder owed becomes an installment
          const depositObligations=rentDebt+totalExtra;
          const newOwed=depositAmt>0?Math.max(0,depositObligations-depositAmt):rentDebt;
          const depositReturned=depositAmt>0?Math.max(0,depositAmt-depositObligations):0;
          // build settlement summary for lease notes
          const L=[];
          L.push(`المدة: ${usedDays} من ${totalDays} يوم | المستحق: ${amtForUsedDays.toLocaleString()} | المحصّل: ${alreadyCollected.toLocaleString()}`);
          if(cascadeRefund>0)L.push(`استرداد إيجار زائد: ${cascadeRefund.toLocaleString()} AED (من الدفعات المحصّلة)`);
          if(rentDebt>0)L.push(`عجز إيجار: ${rentDebt.toLocaleString()} AED`);
          if(depositType==='cash'&&depositAmt>0){
            L.push(`تأمين نقدي: ${depositAmt.toLocaleString()} AED`);
            extraDeductions.forEach(d=>L.push(`  خصم (${d.desc}): ${Number(d.amt).toLocaleString()} AED`));
            if(depositReturned>0)L.push(`صافي التأمين المُعاد للمستأجر: ${depositReturned.toLocaleString()} AED`);
          }else if(depositType==='check'&&rawDepositAmt>0){
            L.push(`تأمين بشيك: ${rawDepositAmt.toLocaleString()} AED — يُعاد الشيك للمستأجر منفصلاً`);
          }
          if(newOwed>0)L.push(`مبلغ مستحق على المستأجر بعد التسوية: ${newOwed.toLocaleString()} AED`);
          const notesSummary=L.join('\n');
          try{
            await api(`/leases/${leaseDetail.lease.id}/terminate`,{method:'POST',body:JSON.stringify({terminate_date:terminateDate,cascade_refund_amount:cascadeRefund,new_owed_amount:newOwed,notes_summary:notesSummary})});
            setTerminateOpen(false);setExtraDeductions([]);setExtraDesc('');setExtraAmt('');
            setPaymentsInst(null);setPayments([]);
            loadDetail(leaseDetail.lease.id);
            showToast('تم إنهاء العقد وتطبيق التسوية','success');
          }catch(e){showToast(e.message||'حدث خطأ أثناء الإنهاء','error');}
        }}><Check size={15}/>تأكيد الإنهاء وتطبيق التسوية</button>}
        <button type="button" className="secondary" style={{width:'100%',marginTop:4}} onClick={()=>{setTerminateOpen(false);setExtraDeductions([]);setExtraDesc('');setExtraAmt('');}}>إغلاق</button>
      </div>
    </Modal>;
  })()}
  </>
}

// ─── List view ───────────────────────────────────────────────
return <>
{/* Summary bar */}
<div className="leasesHeader">
  <div className="leasesSummaryBar">
    <div className="leasesSumCard leasesSumCardMain">
      <span className="leasesSumVal">{rows.length}</span>
      <span className="leasesSumLbl">إجمالي العقود</span>
    </div>
    <div className="leasesSumCard">
      <span className="leasesSumVal" style={{color:'#15803d'}}>{activeCount}</span>
      <span className="leasesSumLbl">عقد نشط</span>
    </div>
    <div className="leasesSumCard">
      <span className="leasesSumVal">{totalAmount.toLocaleString()}</span>
      <span className="leasesSumLbl">إجمالي (AED)</span>
    </div>
    <div className="leasesSumCard">
      <span className="leasesSumVal" style={{color:'#15803d'}}>{totalCollected.toLocaleString()}</span>
      <span className="leasesSumLbl">محصّل (AED)</span>
    </div>
    <div className="leasesSumCard">
      <span className="leasesSumVal" style={{color:(totalAmount-totalCollected)>0?'#dc2626':'#15803d'}}>{(totalAmount-totalCollected).toLocaleString()}</span>
      <span className="leasesSumLbl">متبقي (AED)</span>
    </div>
  </div>
  <div className="leasesToolbar">
    <div className="leasesFilterTabs">
      {[['all','الكل',rows.length],['active','نشط',activeCount],['expired','منتهي',rows.length-activeCount]].map(([v,l,c])=>
        <button key={v} className={'leasesFilterTab'+(statusFilter===v?' leasesFilterTabActive':'')} onClick={()=>setStatusFilter(v)}>{l}<span className="leasesFilterCount">{c}</span></button>
      )}
    </div>
    <div className="leasesToolbarRight">
      <div className="tenantSearch"><input placeholder="بحث بالاسم أو الفيلا..." value={qs} onChange={e=>setQs(e.target.value)}/></div>
      <button onClick={()=>{setEditing(null);setForm(empty);setOpen(true)}}><Plus size={16}/>إضافة عقد</button>
    </div>
  </div>
</div>

{filtered.length===0&&<div className="tenantEmpty"><Banknote size={36} style={{opacity:.2}}/><p>{qs||statusFilter!=='all'?'لا توجد نتائج مطابقة':'لا يوجد عقود بعد'}</p></div>}

{(()=>{
  // group filtered leases by villa
  const groups={};
  filtered.forEach(r=>{const k=r.villa_id||r.villa_name;(groups[k]=groups[k]||{villa_id:r.villa_id,villa_name:r.villa_name,leases:[]}).leases.push(r);});
  const list=Object.values(groups).sort((a,b)=>String(a.villa_name).localeCompare(String(b.villa_name),'ar'));
  return list.map(g=>{
    const activeInG=g.leases.filter(r=>r.is_active&&r.end_date>=today).length;
    const isOpen=openVilla===g.villa_id||!!qs;
    return <div key={g.villa_id} className={'villaSection'+(isOpen?' villaSectionOpen':'')}>
      <div className="villaSectionHeader villaSectionHeaderClickable" onClick={()=>toggleLeaseVilla(g.villa_id)}>
        <div className="villaSectionTitle">
          <ChevronDown size={16} className={'villaChevron'+(isOpen?' villaChevronOpen':'')}/>
          <Building2 size={16}/>{g.villa_name}
        </div>
        <div className="villaSectionRight">
          <span className="aptCountChip">{g.leases.length} عقد</span>
          <span className="aptCountChip aptCountAvail">{activeInG} نشط</span>
        </div>
      </div>
      {isOpen&&<div className="leaseRows">
      {g.leases.map(r=>{
        const st=r.is_active&&r.end_date>=today?'active':'expired';
        const collected=Number(r.collected_amount||0);
        const total=Number(r.total_amount||0);
        const remaining=total-collected;
        const pct=total>0?Math.min(100,Math.round(collected/total*100)):0;
        return <div key={r.id} className={'leaseRow'+(st==='expired'?' leaseRowExpired':'')} onClick={()=>loadDetail(r.id)}>
          <div className="leaseRowMain">
            <span className={st==='active'?'leaseBlockBadge leaseBlockBadgeActive':'leaseBlockBadge leaseBlockBadgeExpired'}>{st==='active'?'نشط':'منتهي'}</span>
            <div className="leaseRowIdentity">
              <span className="leaseRowTenant">{r.tenant_name}</span>
              <span className="leaseRowAptChip">شقة {r.apartment_no}</span>
            </div>
          </div>
          <div className="leaseRowDates"><Calendar size={12}/>{new Date(r.start_date).toLocaleDateString('ar-AE')} — {new Date(r.end_date).toLocaleDateString('ar-AE')}</div>
          <div className="leaseRowFin">
            <div className="leaseRowFinItem"><span className="leaseRowFinVal">{total.toLocaleString()}</span><span className="leaseRowFinLbl">إجمالي</span></div>
            <div className="leaseRowFinItem"><span className="leaseRowFinVal" style={{color:'#15803d'}}>{collected.toLocaleString()}</span><span className="leaseRowFinLbl">محصّل</span></div>
            <div className="leaseRowFinItem"><span className="leaseRowFinVal" style={{color:remaining>0?'#dc2626':'#15803d'}}>{remaining.toLocaleString()}</span><span className="leaseRowFinLbl">متبقي</span></div>
          </div>
          <div className="leaseRowProgress">
            <div className="leaseRowProgressBar"><div className="leaseRowProgressFill" style={{width:pct+'%',background:st==='expired'?'#94a3b8':undefined}}/></div>
            <span className="leaseRowPct">{pct}%</span>
          </div>
          <div className="leaseRowActions" onClick={e=>e.stopPropagation()}>
            <button className="secondary leaseRowViewBtn" onClick={()=>loadDetail(r.id)}><Eye size={13}/>الدفعات</button>
            <button className="iconBtn secondary" onClick={()=>{setEditing(r.id);setForm({apartment_id:r.apartment_id,tenant_id:r.tenant_id,start_date:String(r.start_date).slice(0,10),end_date:String(r.end_date).slice(0,10),total_amount:r.total_amount,fees_amount:r.fees_amount||'',deposit_amount:r.deposit_amount||'',deposit_type:r.deposit_type||'',deposit_notes:r.deposit_notes||'',notes:r.notes||'',is_active:r.is_active,_villa_id:''});setOpen(true)}}><Edit size={14}/></button>
            {isAdmin&&<button className="iconBtn danger" onClick={()=>removeLease(r)}><Trash2 size={14}/></button>}
          </div>
        </div>;
      })}
      </div>}
    </div>;
  });
})()}

<Modal open={open} onClose={()=>setOpen(false)} title={editing?'تعديل عقد':'إضافة عقد إيجار'}><form className="form" onSubmit={saveLease}>
  <Field label="الفيلا" required><select required value={form._villa_id||''} onChange={e=>setForm({...form,_villa_id:e.target.value,apartment_id:''})}><option value="">اختر الفيلا</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
  <Field label="الشقة" required><select required value={form.apartment_id} onChange={e=>setForm({...form,apartment_id:e.target.value})} disabled={!form._villa_id}><option value="">اختر الشقة</option>{apts.filter(a=>a.villa_id==form._villa_id).map(a=><option key={a.id} value={a.id}>{a.apartment_no}</option>)}</select></Field>
  <LeaseFormFields form={form} setForm={setForm} tenants={tenants}/>
  {editing&&<Field label="الحالة"><select value={form.is_active} onChange={e=>setForm({...form,is_active:Number(e.target.value)})}><option value={1}>فعّال</option><option value={0}>منتهي</option></select></Field>}
  <button><Plus size={16}/>{editing?'حفظ التعديل':'إضافة العقد'}</button><button type="button" className="secondary" onClick={()=>setOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
  <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
  <Field label="المبلغ (AED)" required><input required type="number" min="0.01" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
  <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات: ${Number(paymentsInst?.amount||0).toLocaleString()} AED`}>
  {paymentsInst&&<div className="paymentsModal">
    <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toLocaleString()} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
    <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
      <Field label="المبلغ المدفوع (AED)" required><input required type="number" min="0.01" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
      <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
      <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
      <button><Plus size={14}/>تسجيل دفع</button>
    </form>
  </div>}
</Modal>
</>
}


function PaymentsTracker({user}){
const api=useApi();const isAdmin=user?.role==='ADMIN';
const[rows,setRows]=useState([]);const[loading,setLoading]=useState(true);
const[statusFilter,setStatusFilter]=useState('all');
const[villaFilter,setVillaFilter]=useState('');
const[villas,setVillas]=useState([]);
const[fromDate,setFromDate]=useState('');const[toDate,setToDate]=useState('');
const[expandedMonths,setExpandedMonths]=useState({});
// payments modal (reuse)
const[paymentsInst,setPaymentsInst]=useState(null);const[payments,setPayments]=useState([]);
const[payForm,setPayForm]=useState({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});const[payOpen,setPayOpen]=useState(false);

async function load(){
  setLoading(true);
  const params=new URLSearchParams();
  if(fromDate)params.set('from',fromDate);
  if(toDate)params.set('to',toDate);
  if(villaFilter)params.set('villa_id',villaFilter);
  const data=await api('/installments/all?'+params.toString());
  setRows(data||[]);setLoading(false);
}
useEffect(()=>{api('/villas').then(setVillas);load()},[]);
useEffect(()=>{load()},[fromDate,toDate,villaFilter]);

const today=new Date().toISOString().slice(0,10);
const filtered=statusFilter==='all'?rows:rows.filter(r=>r.status===statusFilter);

// KPIs
const kpiOverdue=rows.filter(r=>r.status==='overdue');
const kpiDueSoon=rows.filter(r=>r.status==='due_soon');
const kpiCollected=rows.filter(r=>r.status==='collected');
const kpiUpcoming=rows.filter(r=>r.status==='upcoming');
const totalOverdueAmt=kpiOverdue.reduce((s,r)=>s+Number(r.amount)-Number(r.collected_amount),0);
const totalDueSoonAmt=kpiDueSoon.reduce((s,r)=>s+Number(r.amount)-Number(r.collected_amount),0);

// Group by month
const groups={};
filtered.forEach(r=>{
  const raw=r.due_date.slice?r.due_date.slice(0,10):String(r.due_date).slice(0,10);
  const [yr,mo]=raw.split('-');
  const key=`${yr}-${mo}`;
  const label=`${AR_MONTHS[parseInt(mo,10)-1]} ${yr}`;
  if(!groups[key])groups[key]={key,label,rows:[],total:0,collected:0};
  groups[key].rows.push(r);
  groups[key].total+=Number(r.amount);
  groups[key].collected+=Number(r.collected_amount);
});
const sortedGroups=Object.values(groups).sort((a,b)=>a.key.localeCompare(b.key));

function toggleMonth(key){setExpandedMonths(s=>({...s,[key]:!s[key]}));}
function expandAll(){const m={};sortedGroups.forEach(g=>{m[g.key]=true});setExpandedMonths(m);}
function collapseAll(){const m={};sortedGroups.forEach(g=>{m[g.key]=false});setExpandedMonths(m);}
// only current month + months with overdue open by default
function isExpanded(key){
  if(key in expandedMonths)return expandedMonths[key];
  if(key===today.slice(0,7))return true;
  // expand months with overdue installments
  const g=sortedGroups.find(x=>x.key===key);
  if(g&&g.rows.some(r=>r.status==='overdue'))return true;
  return false;
}

function printMonthPDF(g){
  const STATUS_AR={collected:'تم التحصيل',overdue:'متأخرة',partial:'جزئي',due_soon:'قريبة',upcoming:'قادمة'};
  const remaining=g.total-g.collected;
  const pct=g.total>0?Math.round(g.collected/g.total*100):0;
  const rows=g.rows.map(r=>{
    const rem=Number(r.amount)-Number(r.collected_amount);
    const statusColor={collected:'#15803d',overdue:'#dc2626',partial:'#b45309',due_soon:'#b45309',upcoming:'#0f766e'}[r.status]||'#666';
    const date=(r.due_date.slice?r.due_date:String(r.due_date)).slice(0,10);
    return `<tr>
      <td>${date}</td>
      <td>${r.tenant_name||''}</td>
      <td>${r.villa_name||''} / شقة ${r.apartment_no||''}</td>
      <td style="text-align:left">${Number(r.amount).toLocaleString()} AED</td>
      <td style="text-align:left;color:#15803d">${Number(r.collected_amount).toLocaleString()} AED</td>
      <td style="text-align:left;color:${rem>0?'#dc2626':'#15803d'}">${rem.toLocaleString()} AED</td>
      <td style="color:${statusColor};font-weight:600">${STATUS_AR[r.status]||r.status}</td>
    </tr>`;
  }).join('');
  const html=`<!DOCTYPE html><html dir="rtl" lang="ar"><head><meta charset="UTF-8"/>
  <title>تقرير الدفعات — ${g.label}</title>
  <style>
    *{margin:0;padding:0;box-sizing:border-box}
    body{font-family:'Segoe UI',Tahoma,Arial,sans-serif;direction:rtl;padding:30px;color:#1a1a2e;font-size:13px}
    .header{border-bottom:3px solid #1e40af;padding-bottom:16px;margin-bottom:20px;display:flex;justify-content:space-between;align-items:flex-end}
    .title{font-size:22px;font-weight:700;color:#1e40af}
    .subtitle{font-size:14px;color:#64748b;margin-top:4px}
    .meta{text-align:left;font-size:12px;color:#64748b}
    .kpis{display:grid;grid-template-columns:repeat(4,1fr);gap:12px;margin-bottom:20px}
    .kpi{background:#f8fafc;border:1px solid #e2e8f0;border-radius:8px;padding:12px 16px}
    .kpi-label{font-size:11px;color:#64748b;margin-bottom:4px}
    .kpi-value{font-size:18px;font-weight:700}
    .kpi-cur{font-size:11px;color:#94a3b8}
    table{width:100%;border-collapse:collapse;font-size:12px}
    th{background:#1e40af;color:#fff;padding:8px 10px;text-align:right;font-weight:600}
    td{padding:7px 10px;border-bottom:1px solid #e2e8f0}
    tr:nth-child(even) td{background:#f8fafc}
    .footer{margin-top:20px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:11px;color:#94a3b8;display:flex;justify-content:space-between}
    @media print{body{padding:15px}.no-print{display:none}}
  </style></head><body>
  <div class="header">
    <div><div class="title">تقرير الدفعات — ${g.label}</div><div class="subtitle">إجمالي ${g.rows.length} دفعة</div></div>
    <div class="meta">تاريخ الطباعة: ${new Date().toLocaleDateString('ar-AE')}</div>
  </div>
  <div class="kpis">
    <div class="kpi"><div class="kpi-label">إجمالي المستحق</div><div class="kpi-value">${g.total.toLocaleString()}</div><div class="kpi-cur">AED</div></div>
    <div class="kpi"><div class="kpi-label">تم التحصيل</div><div class="kpi-value" style="color:#15803d">${g.collected.toLocaleString()}</div><div class="kpi-cur">AED</div></div>
    <div class="kpi"><div class="kpi-label">المتبقي</div><div class="kpi-value" style="color:${remaining>0?'#dc2626':'#15803d'}">${remaining.toLocaleString()}</div><div class="kpi-cur">AED</div></div>
    <div class="kpi"><div class="kpi-label">نسبة التحصيل</div><div class="kpi-value" style="color:#1e40af">${pct}%</div></div>
  </div>
  <table><thead><tr><th>تاريخ الاستحقاق</th><th>المستأجر</th><th>الفيلا / الشقة</th><th>المبلغ</th><th>المحصّل</th><th>المتبقي</th><th>الحالة</th></tr></thead>
  <tbody>${rows}</tbody></table>
  <div class="footer"><span>Maintenance Pro — نظام إدارة الفلل والشقق</span><span>صفحة 1</span></div>
  <div class="no-print" style="text-align:center;margin-top:20px"><button onclick="window.print()" style="padding:10px 32px;background:#1e40af;color:#fff;border:none;border-radius:8px;font-size:15px;cursor:pointer;font-family:inherit">🖨️ طباعة / حفظ PDF</button></div>
  </body></html>`;
  const blob=new Blob([html],{type:'text/html;charset=utf-8'});
  const url=URL.createObjectURL(blob);
  const w=window.open(url,'_blank');
  if(w)w.onload=()=>{w.focus();w.print();URL.revokeObjectURL(url);};
}

async function openPayments(inst){
  setPaymentsInst(inst);
  const p=await api('/installments/'+inst.id+'/payments');
  setPayments(p||[]);setPayOpen(true);
}
async function addPayment(e){e.preventDefault();await runAction(async()=>{
  await api('/installments/'+paymentsInst.id+'/payments',{method:'POST',body:JSON.stringify(payForm)});
  const p=await api('/installments/'+paymentsInst.id+'/payments');
  setPayments(p||[]);
  setPayForm({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});
  load();
},'تم تسجيل الدفعة')}
async function removePayment(id){if(!confirm('تأكيد حذف الدفع؟'))return;await runAction(async()=>{
  await api('/payments/'+id,{method:'DELETE'});
  const p=await api('/installments/'+paymentsInst.id+'/payments');
  setPayments(p||[]);load();
},'تم الحذف')}

const STATUS_ICON={collected:<CheckCircle2 size={14}/>,overdue:<AlertCircle size={14}/>,partial:<Clock size={14}/>,due_soon:<Clock size={14}/>,upcoming:<Calendar size={14}/>};

return <>
{/* KPI bar */}
<div className="ptKpiBar">
  {[
    {label:'متأخرة',icon:'⚠',count:kpiOverdue.length,amt:totalOverdueAmt,color:'#dc2626',bg:'#fef2f2',border:'#fecaca',status:'overdue'},
    {label:'قيد التحصيل',icon:'⏳',count:kpiDueSoon.length,amt:totalDueSoonAmt,color:'#b45309',bg:'#fef3c7',border:'#fde68a',status:'due_soon'},
    {label:'تم التحصيل',icon:'✅',count:kpiCollected.length,amt:kpiCollected.reduce((s,r)=>s+Number(r.amount),0),color:'#15803d',bg:'#f0fdf4',border:'#a7f3d0',status:'collected'},
    {label:'قادمة',icon:'📅',count:kpiUpcoming.length,amt:kpiUpcoming.reduce((s,r)=>s+Number(r.amount),0),color:'#0f766e',bg:'#f8fafc',border:'#e2e8f0',status:'upcoming'},
  ].map(k=><button key={k.status} className={'ptKpiCard'+(statusFilter===k.status?' ptKpiCardActive':'')} style={statusFilter===k.status?{background:k.bg,borderColor:k.color}:{}} onClick={()=>setStatusFilter(s=>s===k.status?'all':k.status)}>
    <div className="ptKpiTop"><span className="ptKpiIcon">{k.icon}</span>{k.count>0&&statusFilter!==k.status&&k.status==='overdue'&&<span className="ptKpiPulse"/>}</div>
    <span className="ptKpiCount" style={{color:k.color}}>{k.amt.toLocaleString()}</span>
    <span className="ptKpiAmtCur" style={{color:k.color}}>AED</span>
    <span className="ptKpiLabel">{k.label}</span>
    <span className="ptKpiSub">{k.count} دفعة</span>
  </button>)}
</div>

{/* Toolbar */}
<div className="ptToolbar">
  <div className="ptFilters">
    <select value={villaFilter} onChange={e=>setVillaFilter(e.target.value)} className="ptSelect">
      <option value="">كل الفلل</option>
      {villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}
    </select>
    <input type="date" value={fromDate} onChange={e=>setFromDate(e.target.value)} className="ptDateInput" title="من تاريخ"/>
    <span className="ptDateSep">—</span>
    <input type="date" value={toDate} onChange={e=>setToDate(e.target.value)} className="ptDateInput" title="إلى تاريخ"/>
    {(fromDate||toDate||villaFilter)&&<button className="secondary ptResetBtn" onClick={()=>{setFromDate('');setToDate('');setVillaFilter('')}}><RotateCcw size={14}/>إعادة</button>}
  </div>
  <div className="ptToolbarLeft">
    <span className="ptTotal">{filtered.length} دفعة</span>
    <button className="secondary ptExpandBtn" onClick={expandAll}>فتح الكل</button>
    <button className="secondary ptExpandBtn" onClick={collapseAll}>طي الكل</button>
  </div>
</div>

{loading&&<div className="ptLoading"><Loader2 size={24} className="spin"/></div>}

{!loading&&sortedGroups.length===0&&<div className="tenantEmpty"><ListChecks size={36} style={{opacity:.2}}/><p>لا توجد دفعات مطابقة</p></div>}

{/* Month groups */}
{!loading&&sortedGroups.map(g=>{
  const expanded=isExpanded(g.key);
  const isPast=g.key<today.slice(0,7);const isCurrent=g.key===today.slice(0,7);
  const pct=g.total>0?Math.min(100,Math.round(g.collected/g.total*100)):0;
  const hasOverdue=g.rows.some(r=>r.status==='overdue');
  return <div key={g.key} className={'ptMonth'+(isCurrent?' ptMonthCurrent':'')}>
    <button className="ptMonthHeader" onClick={()=>toggleMonth(g.key)}>
      <div className="ptMonthHeaderRight">
        <span className="ptMonthName">{g.label}</span>
        {isCurrent&&<span className="ptMonthCurrentBadge">الشهر الحالي</span>}
        {hasOverdue&&<span className="ptMonthOverdueBadge"><AlertCircle size={11}/>متأخرة</span>}
      </div>
      <div className="ptMonthHeaderLeft">
        <div className="ptMonthMiniBar"><div className="ptMonthMiniBarFill" style={{width:pct+'%'}}/></div>
        <span className="ptMonthPct">{pct}%</span>
        <span className="ptMonthCount">{g.rows.length} دفعة</span>
        <span className="ptMonthAmt">{g.total.toLocaleString()} AED</span>
        <button className="iconBtn secondary ptPrintBtn" title="تصدير PDF" onClick={e=>{e.stopPropagation();printMonthPDF(g);}}><Printer size={14}/></button>
        {expanded?<ChevronDown size={16}/>:<ChevronDown size={16} style={{transform:'rotate(-90deg)'}}/>}
      </div>
    </button>
    {expanded&&<div className="ptMonthBody">
      <table className="ptTable">
        <thead><tr><th>التاريخ</th><th>المستأجر</th><th>الفيلا / الشقة</th><th>المبلغ</th><th>المحصّل</th><th>الحالة</th><th></th></tr></thead>
        <tbody>{g.rows.map(r=>{
          const remaining=Number(r.amount)-Number(r.collected_amount);
          const pctRow=Number(r.amount)>0?Math.min(100,Math.round(Number(r.collected_amount)/Number(r.amount)*100)):0;
          const isToday=r.due_date===today;
          return <tr key={r.id} className={'ptRow ptRow-'+r.status+(isToday?' ptRowToday':'')}>
            <td className="ptRowDate">
              <span className="ptRowDateMain">{(()=>{const AR_M=['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];const p=(r.due_date.slice?r.due_date:String(r.due_date)).slice(0,10).split('-');return `${parseInt(p[2])} ${AR_M[parseInt(p[1],10)-1]}`;})()}</span>
              {isToday&&<span className="ptRowTodayBadge">اليوم</span>}
            </td>
            <td className="ptRowTenant">{r.tenant_name}</td>
            <td className="ptRowLoc"><span className="ptRowVilla">{r.villa_name}</span><span className="ptRowApt">شقة {r.apartment_no}</span></td>
            <td className="ptRowAmt">{Number(r.amount).toLocaleString()}</td>
            <td className="ptRowCollected">
              <div className="ptRowProgress">
                <div className="ptRowProgressBar"><div className="ptRowProgressFill" style={{width:pctRow+'%'}}/></div>
                <span className="ptRowProgressPct">{pctRow}%</span>
              </div>
            </td>
            <td><span className={'statusBadge statusBadgeSm '+INST_STATUS_CSS[r.status]}>{INST_STATUS_LABELS[r.status]}</span></td>
            <td className="ptRowAction">
              <button className="iconBtn secondary" title="المدفوعات" onClick={()=>openPayments(r)}><DollarSign size={14}/></button>
            </td>
          </tr>;
        })}</tbody>
      </table>
    </div>}
  </div>;
})}

<Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات: ${Number(paymentsInst?.amount||0).toLocaleString()} AED — ${paymentsInst?.tenant_name||''}`}>
  {paymentsInst&&<div className="paymentsModal">
    <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toLocaleString()} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
    <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
      <Field label="المبلغ المدفوع (AED)" required><input required type="number" min="0.01" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
      <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
      <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
      <button><Plus size={14}/>تسجيل دفع</button>
    </form>
  </div>}
</Modal>
</>;
}

createRoot(document.getElementById('root')).render(<App/>);
