import React,{useEffect,useMemo,useState}from'react';import{createRoot}from'react-dom/client';import{Home,Users,Wrench,Building2,LayoutDashboard,FileText,Plus,Trash2,Edit,LogOut,Download,X,Mail,Lock,Eye,EyeOff,Loader2,ShieldCheck,Filter,RotateCcw,ClipboardList,Wallet,TrendingUp,Coins,Check,Settings as SettingsIcon,UserCheck,Banknote,ChevronRight,Calendar,DollarSign,ListChecks,AlertCircle,CheckCircle2,Clock,ChevronDown}from'lucide-react';import{BarChart,Bar,XAxis,YAxis,Tooltip,ResponsiveContainer,CartesianGrid,LabelList}from'recharts';import'./style.css';
const API=import.meta.env.VITE_API_URL||(location.hostname==='localhost'?'http://localhost:4000/api':'/api');

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
function App(){const[user,setUser]=useState(()=>localStorage.user?JSON.parse(localStorage.user):null);const[page,setPage]=useState('dashboard');const isAdmin=user?.role==='ADMIN';const[perms,setPerms]=useState(null);const api=user?useApi():null;
useEffect(()=>{if(user)api('/permissions').then(setPerms)},[user?.id]);
if(!user)return <><Login onOk={setUser}/><Toaster/></>;
const logout=()=>{localStorage.clear();setUser(null)};
const allowedIds=isAdmin?ALL_PAGES.map(p=>p[0]):(perms?.SUPERVISOR||['dashboard']);
const items=ALL_PAGES.filter(p=>allowedIds.includes(p[0])).concat(isAdmin?[['users','المستخدمين',Users],['settings','الصلاحيات',SettingsIcon]]:[]);
const activePage=items.some(i=>i[0]===page)?page:'dashboard';
return <div className="app" dir="rtl"><aside><div className="logo">Maintenance<span>Pro</span></div>{items.map(([id,t,I])=><button key={id} className={activePage===id?'active':''} onClick={()=>setPage(id)}><I size={18}/>{t}</button>)}<button onClick={logout}><LogOut size={18}/>خروج</button></aside><main><header><div><h2>{items.find(i=>i[0]===activePage)?.[1]}</h2><p>نظام إدارة كشف الصيانة اليومي للفلل والشقق</p></div><div className="headerRight"><div className="user"><div className="userAvatar">{user.name?.[0]}</div><div className="userMeta"><span className="userName">{user.name}</span><span className={'roleBadge role-'+user.role}>{ROLE_LABELS[user.role]||user.role}</span></div></div><button className="mobileLogout" onClick={logout}><LogOut size={18}/></button></div></header>{activePage==='dashboard'&&<Dashboard/>}{activePage==='records'&&<Records/>}{activePage==='villas'&&<Villas user={user}/>}{activePage==='apartments'&&<Apartments user={user}/>}{activePage==='technicians'&&<Technicians user={user}/>}{activePage==='users'&&<UsersPage user={user}/>}{activePage==='tenants_mgmt'&&<TenantsMgmt user={user}/>}{activePage==='leases'&&<Leases user={user}/>}{activePage==='payments_tracker'&&<PaymentsTracker user={user}/>}{activePage==='settings'&&<PermissionsSettings/>}</main><nav className="mobileTabs">{items.map(([id,t,I])=><button key={id} className={activePage===id?'active':''} onClick={()=>setPage(id)}><I size={20}/><span>{t}</span></button>)}</nav><Toaster/></div>}

function monthStart(){const t=new Date();return new Date(t.getFullYear(),t.getMonth(),1).toISOString().slice(0,10)}
function todayStr(){return new Date().toISOString().slice(0,10)}
const DEFAULT_DASH_FILTERS={from:monthStart(),to:todayStr(),villa_id:'',technician_id:''};
function Dashboard(){const api=useApi();const[d,setD]=useState(null);const[villas,setVillas]=useState([]);const[techs,setTechs]=useState([]);const[f,setF]=useState(DEFAULT_DASH_FILTERS);
useEffect(()=>{api('/villas').then(setVillas);api('/technicians').then(setTechs)},[]);
useEffect(()=>{const qs=new URLSearchParams(Object.fromEntries(Object.entries(f).filter(([,v])=>v))).toString();api('/dashboard'+(qs?'?'+qs:'')).then(setD)},[f]);
const isFiltered=f.villa_id||f.technician_id||f.from!==DEFAULT_DASH_FILTERS.from||f.to!==DEFAULT_DASH_FILTERS.to;
if(!d)return <Loader/>;
return <>
<Panel title={<span className="panelTitleIcon"><Filter size={16}/>تصفية النتائج</span>}>
  <div className="filterBar">
    <Field label="من تاريخ"><input type="date" value={f.from} onChange={e=>setF({...f,from:e.target.value})}/></Field>
    <Field label="إلى تاريخ"><input type="date" value={f.to} onChange={e=>setF({...f,to:e.target.value})}/></Field>
    <Field label="الفيلا"><select value={f.villa_id} onChange={e=>setF({...f,villa_id:e.target.value})}><option value="">كل الفلل</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
    <Field label="الفني"><select value={f.technician_id} onChange={e=>setF({...f,technician_id:e.target.value})}><option value="">كل الفنيين</option>{techs.map(t=><option key={t.id} value={t.id}>{t.name}</option>)}</select></Field>
    <button type="button" className="secondary filterReset" onClick={()=>setF(DEFAULT_DASH_FILTERS)}><RotateCcw size={14}/>إعادة تعيين</button>
  </div>
</Panel>
<section className="cards">
  <Card t="أعمال اليوم" v={d.today.records} icon={ClipboardList} tone="teal"/>
  <Card t="تكلفة اليوم" v={Number(d.today.cost).toFixed(2)+' AED'} icon={Wallet} tone="amber"/>
  <Card t={isFiltered?'أعمال الفترة المحددة':'أعمال الشهر'} v={isFiltered?d.filtered.records:d.month.records} icon={TrendingUp} tone="blue"/>
  <Card t={isFiltered?'تكلفة الفترة المحددة':'تكلفة الشهر'} v={Number(isFiltered?d.filtered.cost:d.month.cost).toFixed(2)+' AED'} icon={Coins} tone="purple"/>
</section>
<section className="grid2">
<Panel title="الأعمال حسب الفني">{d.byTech.every(x=>x.total===0)?<EmptyChart/>:<div dir="ltr"><ResponsiveContainer height={280}><BarChart data={d.byTech} margin={{top:8,right:8,left:0,bottom:50}}><CartesianGrid strokeDasharray="3 3" vertical={false}/><XAxis dataKey="name" tick={{fontSize:11}} interval={0} angle={-35} textAnchor="end" height={60}/><YAxis allowDecimals={false} width={28} tick={{fontSize:12}}/><Tooltip formatter={v=>[v+' عمل','الإجمالي']}/><Bar dataKey="total" fill="#0f766e" radius={[6,6,0,0]} maxBarSize={48} isAnimationActive={false}><LabelList dataKey="total" position="top" style={{fontSize:12,fontWeight:700,fill:'#0f766e'}}/></Bar></BarChart></ResponsiveContainer></div>}</Panel>
<Panel title="الأعمال حسب الفيلا">{d.byVilla.every(x=>x.total===0)?<EmptyChart/>:<div dir="ltr"><ResponsiveContainer height={280}><BarChart data={d.byVilla} margin={{top:8,right:8,left:0,bottom:50}}><CartesianGrid strokeDasharray="3 3" vertical={false}/><XAxis dataKey="name" tick={{fontSize:11}} interval={0} angle={-35} textAnchor="end" height={60}/><YAxis allowDecimals={false} width={28} tick={{fontSize:12}}/><Tooltip formatter={v=>[v+' عمل','الإجمالي']}/><Bar dataKey="total" fill="#0e7490" radius={[6,6,0,0]} maxBarSize={48} isAnimationActive={false}><LabelList dataKey="total" position="top" style={{fontSize:12,fontWeight:700,fill:'#0e7490'}}/></Bar></BarChart></ResponsiveContainer></div>}</Panel>
</section>
<Panel title="التكلفة المدفوعة حسب الفيلا (AED)">{d.byVilla.every(x=>Number(x.cost)===0)?<EmptyChart/>:<div dir="ltr"><ResponsiveContainer height={280}><BarChart data={d.byVilla} margin={{top:8,right:8,left:0,bottom:50}}><CartesianGrid strokeDasharray="3 3" vertical={false}/><XAxis dataKey="name" tick={{fontSize:11}} interval={0} angle={-35} textAnchor="end" height={60}/><YAxis allowDecimals={false} width={36} tick={{fontSize:12}}/><Tooltip formatter={v=>[Number(v).toFixed(2)+' AED','التكلفة']}/><Bar dataKey="cost" fill="#b45309" radius={[6,6,0,0]} maxBarSize={48} isAnimationActive={false}><LabelList dataKey="cost" position="top" formatter={v=>Number(v).toFixed(0)} style={{fontSize:12,fontWeight:700,fill:'#b45309'}}/></Bar></BarChart></ResponsiveContainer></div>}</Panel>
<Panel title="آخر السجلات"><Table rows={d.recent} cols={['record_date','villa_name','spare_part_cost']}/></Panel></>}

function Card({t,v,icon:Icon,tone='teal'}){return <div className="card"><div className={'cardIcon tone-'+tone}>{Icon&&<Icon size={18}/>}</div><div className="cardBody"><p>{t}</p><h3>{v}</h3></div></div>}
function EmptyChart(){return <div className="emptyChart">لا توجد بيانات كافية لعرض الرسم البياني لهذه الفترة</div>}
function Panel(p){return <section className="panel"><h3>{p.title}</h3>{p.children}</section>}
function Loader(){return <div className="panel">جاري التحميل...</div>}
function Field({label,required,wide,children}){return <label className={'field'+(wide?' wide':'')}><span>{label}{required&&<b className="req">*</b>}</span>{children}</label>}
function Modal({open,onClose,title,children}){useEffect(()=>{if(!open)return;const onKey=e=>{if(e.key==='Escape')onClose()};document.addEventListener('keydown',onKey);return()=>document.removeEventListener('keydown',onKey)},[open,onClose]);if(!open)return null;return <div className="modalOverlay" onClick={onClose}><div className="modalBox" onClick={e=>e.stopPropagation()}><div className="modalHead"><h3>{title}</h3><button type="button" className="iconBtn" onClick={onClose}><X size={18}/></button></div>{children}</div></div>}

function Records(){const api=useApi();const[rows,setRows]=useState([]),[villas,setVillas]=useState([]),[apts,setApts]=useState([]),[techs,setTechs]=useState([]);const empty={record_date:new Date().toISOString().slice(0,10),villa_id:'',apartment_id:'',issue_type:'',description:'',technician_ids:[],reported_time:'',completed_time:'',spare_part:'',spare_part_cost:0,notes:''};const[form,setForm]=useState(empty);const[editing,setEditing]=useState(null);const[modalOpen,setModalOpen]=useState(false);const[viewing,setViewing]=useState(null);const load=()=>{api('/records').then(setRows);api('/villas').then(setVillas);api('/apartments').then(setApts);api('/technicians').then(setTechs)};useEffect(()=>{load()},[]);function openAdd(){setEditing(null);setForm(empty);setModalOpen(true)}function closeModal(){setModalOpen(false)}async function save(e){e.preventDefault();if(form.technician_ids.length===0)return showToast('اختر فنيًا واحدًا على الأقل','error');await runAction(async()=>{await api(editing?'/records/'+editing:'/records',{method:editing?'PUT':'POST',body:JSON.stringify(form)});setForm(empty);setEditing(null);setModalOpen(false);load()},editing?'تم حفظ التعديل':'تمت إضافة السجل')}function edit(r){setEditing(r.id);setForm({...r,record_date:String(r.record_date).slice(0,10),reported_time:r.reported_time||'',completed_time:r.completed_time||'',technician_ids:r.technician_ids?String(r.technician_ids).split(',').map(Number):[]});setModalOpen(true)}async function remove(r){if(!confirm('تأكيد حذف سجل الصيانة هذا؟ لا يمكن التراجع.'))return;await runAction(async()=>{await api('/records/'+r.id,{method:'DELETE'});load()},'تم حذف السجل')}function csv(){let c='Date,Villa,Apartment,IssueType,Description,Technician,Reported,Completed,Part,Cost\n'+rows.map(r=>[r.record_date,r.villa_name,r.apartment_no,ISSUE_TYPE_LABELS[r.issue_type]||r.issue_type,r.description,r.technician_name,r.reported_time,r.completed_time,r.spare_part,r.spare_part_cost].map(x=>'"'+(x??'')+'"').join(',')).join('\n');let a=document.createElement('a');a.href=URL.createObjectURL(new Blob([c]));a.download='maintenance-records.csv';a.click()}return <><Panel title="كشف الصيانة"><div className="panelActions"><button onClick={openAdd}><Plus size={16}/>إضافة سجل صيانة</button><button className="secondary" onClick={csv}><Download size={16}/>تصدير CSV / Excel</button></div><Table rows={rows.map(r=>({...r,status:r.completed_time?'مكتمل':'قيد التنفيذ'}))} cols={['record_date','villa_name','apartment_no','issue_type','technician_name','status','spare_part_cost']} searchable actions={r=><><button className="secondary" onClick={()=>setViewing(r)}><Eye size={15}/></button><button onClick={()=>edit(r)}><Edit size={15}/></button><button className="danger" onClick={()=>remove(r)}><Trash2 size={15}/></button></>}/></Panel>
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
<Field label="التكلفة (AED)"><input type="number" value={form.spare_part_cost} onChange={e=>setForm({...form,spare_part_cost:e.target.value})}/></Field>
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
<div className="villasGrid">
{filtered.map(r=><div key={r.id} className={'villaCard'+(r.is_active?'':' villaCardInactive')}>
  <div className="villaCardBanner" style={{background:villaGradient(r.name)}}>
    <span className="villaCardInitials">{r.name.replace('فيلا','').trim().slice(0,2)||r.name.slice(0,2)}</span>
    <span className={'villaCardStatusBadge'+(r.is_active?' villaCardStatusActive':' villaCardStatusInactive')}>{r.is_active?'نشطة':'متوقفة'}</span>
  </div>
  <div className="villaCardBody">
    <div className="villaCardNameRow">
      <h3 className="villaCardName">{r.name}</h3>
      {isAdmin&&<div className="villaCardActions">
        <button className="iconBtn secondary" onClick={()=>{setEditingVilla(r.id);setVilla({name:r.name,area:r.area||'',notes:r.notes||'',is_active:r.is_active});setModalOpen(true)}}><Edit size={14}/></button>
        <button className="iconBtn danger" onClick={()=>removeVilla(r)}><Trash2 size={14}/></button>
      </div>}
    </div>
    {r.area&&<div className="villaCardAreaChip"><span>{r.area}</span></div>}
    {r.notes&&<p className="villaCardNotes">{r.notes}</p>}
    <div className="villaCardFooter">
      <div className="villaCardAptCount"><Home size={14}/><span className="villaCardAptNum">{r.aptCount}</span><span className="villaCardAptLbl">شقة</span></div>
      <div className="villaCardBarWrap"><div className="villaCardBar"><div className="villaCardBarFill" style={{width:Math.round(r.aptCount/maxApts*100)+'%',background:villaGradient(r.name)}}/></div></div>
    </div>
  </div>
</div>)}
</div>
<Modal open={modalOpen} onClose={()=>setModalOpen(false)} title={editingVilla?'تعديل فيلا':'إضافة فيلا'}><form className="form compact" onSubmit={saveVilla}>
  <Field label="اسم الفيلا" required><input required placeholder="فيلا الياسمين" value={villa.name} onChange={e=>setVilla({...villa,name:e.target.value})}/></Field>
  <Field label="المنطقة"><input placeholder="دبي" value={villa.area} onChange={e=>setVilla({...villa,area:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><input value={villa.notes||''} onChange={e=>setVilla({...villa,notes:e.target.value})}/></Field>
  {editingVilla&&<Field label="الحالة"><select value={villa.is_active} onChange={e=>setVilla({...villa,is_active:Number(e.target.value)})}><option value={1}>فعّال</option><option value={0}>متوقف</option></select></Field>}
  <button>{editingVilla?'حفظ التعديل':'إضافة'}</button><button type="button" className="secondary" onClick={()=>setModalOpen(false)}>إلغاء</button>
</form></Modal>
</>;}


function AptLeasesView({apt,api,isAdmin,onBack}){
const[leasesDetail,setLeasesDetail]=useState(null);
const[tenants,setTenants]=useState([]);
const[leaseForm,setLeaseForm]=useState({tenant_id:'',start_date:'',end_date:'',total_amount:'',notes:''});
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

async function saveLease(e){e.preventDefault();await runAction(async()=>{await api('/leases',{method:'POST',body:JSON.stringify({...leaseForm,apartment_id:apt.id})});setLeaseForm({tenant_id:'',start_date:'',end_date:'',total_amount:'',notes:''});setLeaseOpen(false);reload()},'تمت إضافة العقد')}
async function saveInst(e){e.preventDefault();await runAction(async()=>{if(editingInst){await api('/installments/'+editingInst,{method:'PUT',body:JSON.stringify(instForm)})}else{await api('/leases/'+targetLeaseId+'/installments',{method:'POST',body:JSON.stringify(instForm)})}setInstForm({due_date:'',amount:'',notes:''});setEditingInst(null);setInstOpen(false);reload()},editingInst?'تم تعديل الدفعة':'تمت إضافة الدفعة')}
async function removeInst(id){if(!confirm('تأكيد حذف الدفعة؟'))return;await runAction(async()=>{await api('/installments/'+id,{method:'DELETE'});reload()},'تم الحذف')}
async function openPayments(inst){setPaymentsInst(inst);const p=await api('/installments/'+inst.id+'/payments');setPayments(p||[]);setPayOpen(true)}
async function addPayment(e){e.preventDefault();await runAction(async()=>{await api('/installments/'+paymentsInst.id+'/payments',{method:'POST',body:JSON.stringify(payForm)});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);setPayForm({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});reload()},'تم تسجيل الدفعة')}
async function removePayment(id){if(!confirm('تأكيد حذف هذا الدفع؟'))return;await runAction(async()=>{await api('/payments/'+id,{method:'DELETE'});const p=await api('/installments/'+paymentsInst.id+'/payments');setPayments(p||[]);reload()},'تم الحذف')}

if(!leasesDetail)return <div className="panel">جاري التحميل...</div>;
return <>
<div className="tenantDetailHeader">
  <button type="button" className="backBtn" onClick={onBack}><ChevronRight size={18}/>رجوع</button>
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
  <Field label="المستأجر" required><select required value={leaseForm.tenant_id} onChange={e=>setLeaseForm({...leaseForm,tenant_id:e.target.value})}><option value="">اختر المستأجر</option>{tenants.map(t=><option key={t.id} value={t.id}>{t.name}</option>)}</select></Field>
  <Field label="تاريخ البداية" required><input required type="date" value={leaseForm.start_date} onChange={e=>setLeaseForm({...leaseForm,start_date:e.target.value})}/></Field>
  <Field label="تاريخ النهاية" required><input required type="date" value={leaseForm.end_date} onChange={e=>setLeaseForm({...leaseForm,end_date:e.target.value})}/></Field>
  <Field label="إجمالي الإيجار (AED)" required><input required type="number" step="0.01" value={leaseForm.total_amount} onChange={e=>setLeaseForm({...leaseForm,total_amount:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={leaseForm.notes} onChange={e=>setLeaseForm({...leaseForm,notes:e.target.value})}/></Field>
  <button><Plus size={16}/>إضافة العقد</button><button type="button" className="secondary" onClick={()=>setLeaseOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
  <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
  <Field label="المبلغ (AED)" required><input required type="number" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
  <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات دفعة: ${Number(paymentsInst?.amount||0).toFixed(2)} AED`}>
  {paymentsInst&&<div className="paymentsModal">
    <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toFixed(2)} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
    <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
      <Field label="المبلغ المدفوع (AED)" required><input required type="number" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
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
const emptyApt={villa_id:'',apartment_no:'',floor:''};const[apt,setApt]=useState(emptyApt);const[editingApt,setEditingApt]=useState(null);const[modalOpen,setModalOpen]=useState(false);
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
{grouped.map(({villa,apts:vapts})=>(
<div key={villa.id} className="villaSection">
  <div className="villaSectionHeader">
    <div className="villaSectionTitle"><Building2 size={16}/>{villa.name}{villa.area&&<span className="villaSectionArea">{villa.area}</span>}</div>
    <div className="villaSectionRight">
      <span className="villaSectionCount">{vapts.length} شقة</span>
      {isAdmin&&<button className="secondary villaSectionAdd" onClick={()=>openAdd(String(villa.id))}><Plus size={13}/>إضافة</button>}
    </div>
  </div>
  <div className="aptGrid">
    {vapts.map(r=>(
    <div key={r.id} className="aptCard">
      <div className="aptCardNum">{r.apartment_no}</div>
      {r.floor&&<div className="aptCardFloor"><Home size={11}/>{r.floor}</div>}
      <div className="aptCardActions">
        <button className="secondary aptCardBtn" onClick={()=>setSelectedApt(r)}><Banknote size={13}/>العقود</button>
        {isAdmin&&<>
          <button className="secondary iconBtn aptCardIcon" onClick={()=>{setEditingApt(r.id);setApt({villa_id:r.villa_id,apartment_no:r.apartment_no,floor:r.floor||''});setModalOpen(true)}}><Edit size={13}/></button>
          <button className="danger iconBtn aptCardIcon" onClick={()=>removeApt(r)}><Trash2 size={13}/></button>
        </>}
      </div>
    </div>))}
  </div>
</div>))}
<Modal open={modalOpen} onClose={()=>setModalOpen(false)} title={editingApt?'تعديل شقة':'إضافة شقة'}><form className="form compact" onSubmit={saveApt}>
  <Field label="الفيلا" required><select required value={apt.villa_id} onChange={e=>setApt({...apt,villa_id:e.target.value})}><option value="">اختر الفيلا</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
  <Field label="رقم الشقة" required><input required value={apt.apartment_no} onChange={e=>setApt({...apt,apartment_no:e.target.value})}/></Field>
  <Field label="الدور"><input value={apt.floor||''} onChange={e=>setApt({...apt,floor:e.target.value})}/></Field>
  <button>{editingApt?'حفظ التعديل':'إضافة'}</button><button type="button" className="secondary" onClick={()=>setModalOpen(false)}>إلغاء</button>
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
const INST_STATUS_LABELS={collected:'تم التحصيل',overdue:'متأخرة',partial:'جزئي',due_soon:'قيد التحصيل',upcoming:'قادمة'};
const INST_STATUS_CSS={collected:'status-on',overdue:'status-danger',partial:'status-partial',due_soon:'status-warn',upcoming:'status-off'};
function formatCell(c,v){if(c==='status'){if(INST_STATUS_LABELS[v])return <span className={'statusBadge '+INST_STATUS_CSS[v]}>{INST_STATUS_LABELS[v]}</span>;return <span className={'statusBadge '+(v==='مكتمل'?'status-on':'status-pending')}>{v}</span>}if(v===null||v===undefined||v==='')return'-';if(c==='record_date'||c==='start_date'||c==='end_date'||c==='due_date'||c==='payment_date')return new Date(v).toLocaleDateString('ar-AE');if(c.endsWith('_time'))return String(v).slice(0,5);if(c==='spare_part_cost'||c==='total_amount'||c==='collected_amount'||c==='amount')return Number(v).toFixed(2)+' AED';if(c==='role')return <span className={'roleBadge role-'+v}>{ROLE_LABELS[v]||v}</span>;if(c==='is_active')return <span className={'statusBadge '+(v?'status-on':'status-off')}>{v?'فعّال':'موقوف'}</span>;if(c==='issue_type')return ISSUE_TYPE_LABELS[v]||v;return String(v)}
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
    <td className="instTblBarCell"><div className="instTblBar"><div className="instTblBarFill" style={{width:pct+'%'}}/></div><span className="instTblPct">{Math.round(pct)}%</span></td>
    <td><span className={'statusBadge statusBadgeSm '+INST_STATUS_CSS[i.status]}>{INST_STATUS_LABELS[i.status]}</span></td>
    <td className="instTblActions">
      <button className="secondary iconBtn" title="المدفوعات" onClick={()=>onPayments(i)}><DollarSign size={13}/></button>
      <button className="secondary iconBtn" onClick={()=>onEdit(i,leaseId)}><Edit size={13}/></button>
      {isAdmin&&<button className="danger iconBtn" onClick={()=>onDelete(i.id)}><Trash2 size={13}/></button>}
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
const emptyLease={apartment_id:'',_villa_id:'',start_date:'',end_date:'',total_amount:'',notes:''};
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
  {/* Profile hero */}
  <div className="tenantProfile">
    <div className="tenantProfileBg"/>
    <div className="tenantProfileBody">
      <button type="button" className="tenantProfileBack" onClick={()=>setSelected(null)}><ChevronRight size={16}/>رجوع</button>
      <div className="tenantProfileMain">
        <div className="tenantProfileAvatarWrap">
          <div className="tenantProfileAvatar" style={{background:avatarColor(tenant.name)}}>{tenant.name[0]}</div>
          {activeLeases>0&&<span className="tenantProfileActiveDot"/>}
        </div>
        <div className="tenantProfileInfo">
          <h2 className="tenantProfileName">{tenant.name}</h2>
          <div className="tenantProfileContacts">
            {tenant.phone&&<span className="tenantProfileContact"><span className="tenantProfileContactIcon">📞</span>{tenant.phone}</span>}
            {tenant.national_id&&<span className="tenantProfileContact"><span className="tenantProfileContactIcon">🪪</span>{tenant.national_id}</span>}
            {tenant.email&&<span className="tenantProfileContact"><span className="tenantProfileContactIcon">✉️</span>{tenant.email}</span>}
          </div>
        </div>
      </div>
      <div className="tenantProfileStats">
        <div className="tenantProfileStat"><span className="tenantProfileStatVal">{leasesDetail.length}</span><span className="tenantProfileStatLbl">إجمالي العقود</span></div>
        <div className="tenantProfileStatDiv"/>
        <div className="tenantProfileStat"><span className="tenantProfileStatVal" style={{color:'#15803d'}}>{activeLeases}</span><span className="tenantProfileStatLbl">عقد نشط</span></div>
        <div className="tenantProfileStatDiv"/>
        <div className="tenantProfileStat"><span className="tenantProfileStatVal">{totalCollected.toLocaleString()}</span><span className="tenantProfileStatLbl">محصّل (AED)</span></div>
        <div className="tenantProfileStatDiv"/>
        <div className="tenantProfileStat"><span className="tenantProfileStatVal" style={{color:(totalAmount-totalCollected)>0?'#dc2626':'#15803d'}}>{(totalAmount-totalCollected).toLocaleString()}</span><span className="tenantProfileStatLbl">متبقي (AED)</span></div>
      </div>
      <div className="tenantProfileActions">
        <button onClick={()=>setLeaseOpen(true)}><Plus size={15}/>عقد جديد</button>
        <button className="secondary" onClick={()=>{setEditing(tenant.id);setForm({name:tenant.name,phone:tenant.phone||'',national_id:tenant.national_id||'',email:tenant.email||'',notes:tenant.notes||''});setTenantOpen(true)}}><Edit size={15}/>تعديل</button>
        {isAdmin&&<button className="danger secondary" onClick={()=>removeTenant(tenant)}><Trash2 size={15}/></button>}
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
    <Field label="تاريخ البداية" required><input required type="date" value={leaseForm.start_date} onChange={e=>setLeaseForm({...leaseForm,start_date:e.target.value})}/></Field>
    <Field label="تاريخ النهاية" required><input required type="date" value={leaseForm.end_date} onChange={e=>setLeaseForm({...leaseForm,end_date:e.target.value})}/></Field>
    <Field label="إجمالي الإيجار (AED)" required><input required type="number" step="0.01" value={leaseForm.total_amount} onChange={e=>setLeaseForm({...leaseForm,total_amount:e.target.value})}/></Field>
    <Field label="ملاحظات" wide><textarea value={leaseForm.notes} onChange={e=>setLeaseForm({...leaseForm,notes:e.target.value})}/></Field>
    <button><Plus size={16}/>إضافة العقد</button><button type="button" className="secondary" onClick={()=>setLeaseOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
    <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
    <Field label="المبلغ (AED)" required><input required type="number" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
    <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
    <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات دفعة: ${Number(paymentsInst?.amount||0).toFixed(2)} AED`}>
    {paymentsInst&&<div className="paymentsModal">
      <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toFixed(2)} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
      <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
        <Field label="المبلغ المدفوع (AED)" required><input required type="number" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
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

<div className="tenantGrid">
{filtered.map(r=><div key={r.id} className="tenantCard" onClick={()=>openTenant(r)}>
  <div className="tenantCardTop">
    <div className="tenantCardAvatar" style={{background:avatarColor(r.name)}}>{r.name[0]}</div>
    <div className="tenantCardInfo">
      <div className="tenantCardName">{r.name}</div>
      {r.phone&&<div className="tenantCardPhone">{r.phone}</div>}
      {r.national_id&&<div className="tenantCardId">🪪 {r.national_id}</div>}
    </div>
  </div>
  {r.email&&<div className="tenantCardEmail">{r.email}</div>}
  <div className="tenantCardFooter">
    <button className="tenantCardViewBtn" onClick={e=>{e.stopPropagation();openTenant(r)}}><Eye size={14}/>العقود</button>
    <div className="tenantCardIconBtns">
      <button className="iconBtn secondary" onClick={e=>{e.stopPropagation();setEditing(r.id);setForm({name:r.name,phone:r.phone||'',national_id:r.national_id||'',email:r.email||'',notes:r.notes||''});setTenantOpen(true)}}><Edit size={14}/></button>
      {isAdmin&&<button className="iconBtn danger" onClick={e=>{e.stopPropagation();removeTenant(r)}}><Trash2 size={14}/></button>}
    </div>
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
const empty={apartment_id:'',tenant_id:'',start_date:'',end_date:'',total_amount:'',notes:'',is_active:1,_villa_id:''};
const[form,setForm]=useState(empty);const[editing,setEditing]=useState(null);const[open,setOpen]=useState(false);
const[instForm,setInstForm]=useState({due_date:'',amount:'',notes:''});const[instOpen,setInstOpen]=useState(false);const[editingInst,setEditingInst]=useState(null);
const[paymentsInst,setPaymentsInst]=useState(null);const[payments,setPayments]=useState([]);
const[payForm,setPayForm]=useState({amount:'',payment_date:new Date().toISOString().slice(0,10),notes:''});const[payOpen,setPayOpen]=useState(false);

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
  <div className="leaseDetailPage">
    {/* Hero */}
    <div className="leaseDetailHero">
      <div className="leaseDetailHeroBg"/>
      <div className="leaseDetailHeroBody">
        <button className="leaseDetailBack" onClick={()=>{setSelectedLease(null);setLeaseDetail(null)}}><ChevronRight size={16}/>رجوع</button>
        <div className="leaseDetailHeroTop">
          <div className="leaseDetailHeroIcon"><Banknote size={28}/></div>
          <div className="leaseDetailHeroInfo">
            <div className="leaseDetailHeroMeta">
              <span className={st==='active'?'leaseBlockBadge leaseBlockBadgeActive':'leaseBlockBadge leaseBlockBadgeExpired'}>{st==='active'?'نشط':'منتهي'}</span>
              {overdueCount>0&&<span className="leaseDetailOverdueBadge">⚠ {overdueCount} دفعة متأخرة</span>}
            </div>
            <h2 className="leaseDetailHeroName">{lease.tenant_name}</h2>
            <div className="leaseDetailHeroSub"><Building2 size={14}/>{lease.villa_name} — شقة {lease.apartment_no}<span className="leaseDetailHeroDiv"/><Calendar size={13}/>{new Date(lease.start_date).toLocaleDateString('ar-AE')} — {new Date(lease.end_date).toLocaleDateString('ar-AE')}</div>
          </div>
          <div className="leaseDetailHeroActions">
            <button onClick={()=>{setInstOpen(true);setEditingInst(null);setInstForm({due_date:'',amount:'',notes:''})}}><Plus size={15}/>إضافة دفعة</button>
            <button className="secondary" onClick={()=>{setEditing(lease.id);setForm({apartment_id:lease.apartment_id,tenant_id:lease.tenant_id,start_date:String(lease.start_date).slice(0,10),end_date:String(lease.end_date).slice(0,10),total_amount:lease.total_amount,notes:lease.notes||'',is_active:lease.is_active,_villa_id:''});setOpen(true)}}><Edit size={15}/>تعديل</button>
            {isAdmin&&<button className="danger secondary" onClick={()=>removeLease(lease)}><Trash2 size={15}/></button>}
          </div>
        </div>
        {/* Financial stats */}
        <div className="leaseDetailStats">
          <div className="leaseDetailStat"><span className="leaseDetailStatVal">{Number(lease.total_amount).toLocaleString()}</span><span className="leaseDetailStatLbl">إجمالي (AED)</span></div>
          <div className="leaseDetailStatDiv"/>
          <div className="leaseDetailStat"><span className="leaseDetailStatVal" style={{color:'#15803d'}}>{collected.toLocaleString()}</span><span className="leaseDetailStatLbl">محصّل (AED)</span></div>
          <div className="leaseDetailStatDiv"/>
          <div className="leaseDetailStat"><span className="leaseDetailStatVal" style={{color:remaining>0?'#dc2626':'#15803d'}}>{remaining.toLocaleString()}</span><span className="leaseDetailStatLbl">متبقي (AED)</span></div>
          <div className="leaseDetailStatDiv"/>
          <div className="leaseDetailStat"><span className="leaseDetailStatVal" style={{color:pct===100?'#15803d':'var(--text)'}}>{pct}%</span><span className="leaseDetailStatLbl">نسبة التحصيل</span></div>
        </div>
        <div className="leaseDetailProgressBar"><div className="leaseDetailProgressFill" style={{width:pct+'%',background:st==='expired'?'#94a3b8':undefined}}/></div>
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
    <Field label="المستأجر" required><select required value={form.tenant_id} onChange={e=>setForm({...form,tenant_id:e.target.value})}><option value="">اختر المستأجر</option>{tenants.map(t=><option key={t.id} value={t.id}>{t.name}</option>)}</select></Field>
    <Field label="تاريخ البداية" required><input required type="date" value={form.start_date} onChange={e=>setForm({...form,start_date:e.target.value})}/></Field>
    <Field label="تاريخ النهاية" required><input required type="date" value={form.end_date} onChange={e=>setForm({...form,end_date:e.target.value})}/></Field>
    <Field label="إجمالي الإيجار (AED)" required><input required type="number" step="0.01" value={form.total_amount} onChange={e=>setForm({...form,total_amount:e.target.value})}/></Field>
    <Field label="الحالة"><select value={form.is_active} onChange={e=>setForm({...form,is_active:Number(e.target.value)})}><option value={1}>فعّال</option><option value={0}>منتهي</option></select></Field>
    <Field label="ملاحظات" wide><textarea value={form.notes} onChange={e=>setForm({...form,notes:e.target.value})}/></Field>
    <button><Plus size={16}/>حفظ التعديل</button><button type="button" className="secondary" onClick={()=>setOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
    <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
    <Field label="المبلغ (AED)" required><input required type="number" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
    <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
    <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
  </form></Modal>
  <Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات: ${Number(paymentsInst?.amount||0).toLocaleString()} AED`}>
    {paymentsInst&&<div className="paymentsModal">
      <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toLocaleString()} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
      <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
        <Field label="المبلغ المدفوع (AED)" required><input required type="number" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
        <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
        <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
        <button><Plus size={14}/>تسجيل دفع</button>
      </form>
    </div>}
  </Modal>
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

<div className="leasesGrid">
{filtered.map(r=>{
  const st=r.is_active&&r.end_date>=today?'active':'expired';
  const collected=Number(r.collected_amount||0);
  const total=Number(r.total_amount||0);
  const remaining=total-collected;
  const pct=total>0?Math.min(100,Math.round(collected/total*100)):0;
  return <div key={r.id} className={'leaseCard'+(st==='expired'?' leaseCardExpired':'')} onClick={()=>loadDetail(r.id)}>
    <div className="leaseCardHeader">
      <span className={st==='active'?'leaseBlockBadge leaseBlockBadgeActive':'leaseBlockBadge leaseBlockBadgeExpired'}>{st==='active'?'نشط':'منتهي'}</span>
      <div className="leaseCardActions" onClick={e=>e.stopPropagation()}>
        <button className="iconBtn secondary" onClick={()=>{setEditing(r.id);setForm({apartment_id:r.apartment_id,tenant_id:r.tenant_id,start_date:String(r.start_date).slice(0,10),end_date:String(r.end_date).slice(0,10),total_amount:r.total_amount,notes:r.notes||'',is_active:r.is_active,_villa_id:''});setOpen(true)}}><Edit size={14}/></button>
        {isAdmin&&<button className="iconBtn danger" onClick={()=>removeLease(r)}><Trash2 size={14}/></button>}
      </div>
    </div>
    <div className="leaseCardTenant">{r.tenant_name}</div>
    <div className="leaseCardLocation"><Building2 size={13}/>{r.villa_name}<span className="leaseCardAptChip">شقة {r.apartment_no}</span></div>
    <div className="leaseCardDates"><Calendar size={12}/>{new Date(r.start_date).toLocaleDateString('ar-AE')} — {new Date(r.end_date).toLocaleDateString('ar-AE')}</div>
    <div className="leaseCardFinRow">
      <div className="leaseCardFin"><span className="leaseCardFinVal">{total.toLocaleString()}</span><span className="leaseCardFinLbl">إجمالي</span></div>
      <div className="leaseCardFin"><span className="leaseCardFinVal" style={{color:'#15803d'}}>{collected.toLocaleString()}</span><span className="leaseCardFinLbl">محصّل</span></div>
      <div className="leaseCardFin"><span className="leaseCardFinVal" style={{color:remaining>0?'#dc2626':'#15803d'}}>{remaining.toLocaleString()}</span><span className="leaseCardFinLbl">متبقي</span></div>
    </div>
    <div className="leaseCardProgressWrap">
      <div className="leaseCardProgressBar"><div className="leaseCardProgressFill" style={{width:pct+'%',background:st==='expired'?'#94a3b8':undefined}}/></div>
      <span className="leaseCardPct">{pct}%</span>
    </div>
    <button className="leaseCardViewBtn"><Eye size={13}/>عرض الدفعات</button>
  </div>;
})}
</div>

<Modal open={open} onClose={()=>setOpen(false)} title={editing?'تعديل عقد':'إضافة عقد إيجار'}><form className="form" onSubmit={saveLease}>
  <Field label="المستأجر" required><select required value={form.tenant_id} onChange={e=>setForm({...form,tenant_id:e.target.value})}><option value="">اختر المستأجر</option>{tenants.map(t=><option key={t.id} value={t.id}>{t.name}</option>)}</select></Field>
  <Field label="الفيلا" required><select required value={form._villa_id||''} onChange={e=>setForm({...form,_villa_id:e.target.value,apartment_id:''})}><option value="">اختر الفيلا</option>{villas.map(v=><option key={v.id} value={v.id}>{v.name}</option>)}</select></Field>
  <Field label="الشقة" required><select required value={form.apartment_id} onChange={e=>setForm({...form,apartment_id:e.target.value})} disabled={!form._villa_id}><option value="">اختر الشقة</option>{apts.filter(a=>a.villa_id==form._villa_id).map(a=><option key={a.id} value={a.id}>{a.apartment_no}</option>)}</select></Field>
  <Field label="تاريخ البداية" required><input required type="date" value={form.start_date} onChange={e=>setForm({...form,start_date:e.target.value})}/></Field>
  <Field label="تاريخ النهاية" required><input required type="date" value={form.end_date} onChange={e=>setForm({...form,end_date:e.target.value})}/></Field>
  <Field label="إجمالي الإيجار (AED)" required><input required type="number" step="0.01" value={form.total_amount} onChange={e=>setForm({...form,total_amount:e.target.value})}/></Field>
  {editing&&<Field label="الحالة"><select value={form.is_active} onChange={e=>setForm({...form,is_active:Number(e.target.value)})}><option value={1}>فعّال</option><option value={0}>منتهي</option></select></Field>}
  <Field label="ملاحظات" wide><textarea value={form.notes} onChange={e=>setForm({...form,notes:e.target.value})}/></Field>
  <button><Plus size={16}/>{editing?'حفظ التعديل':'إضافة العقد'}</button><button type="button" className="secondary" onClick={()=>setOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={instOpen} onClose={()=>setInstOpen(false)} title={editingInst?'تعديل دفعة':'إضافة دفعة'}><form className="form compact" onSubmit={saveInst}>
  <Field label="تاريخ الاستحقاق" required><input required type="date" value={instForm.due_date} onChange={e=>setInstForm({...instForm,due_date:e.target.value})}/></Field>
  <Field label="المبلغ (AED)" required><input required type="number" step="0.01" value={instForm.amount} onChange={e=>setInstForm({...instForm,amount:e.target.value})}/></Field>
  <Field label="ملاحظات" wide><textarea value={instForm.notes} onChange={e=>setInstForm({...instForm,notes:e.target.value})}/></Field>
  <button>{editingInst?'حفظ التعديل':'إضافة الدفعة'}</button><button type="button" className="secondary" onClick={()=>setInstOpen(false)}>إلغاء</button>
</form></Modal>
<Modal open={payOpen} onClose={()=>setPayOpen(false)} title={`مدفوعات: ${Number(paymentsInst?.amount||0).toLocaleString()} AED`}>
  {paymentsInst&&<div className="paymentsModal">
    <div className="paymentsList">{payments.length===0&&<p className="empty" style={{padding:12,textAlign:'center'}}>لا توجد مدفوعات بعد</p>}{payments.map(p=><div key={p.id} className="paymentRow"><div><span className="payAmount">{Number(p.amount).toLocaleString()} AED</span><span className="payDate">{new Date(p.payment_date).toLocaleDateString('ar-AE')}</span>{p.notes&&<span className="payNotes">{p.notes}</span>}</div>{isAdmin&&<button className="danger iconBtn" onClick={()=>removePayment(p.id)}><Trash2 size={14}/></button>}</div>)}</div>
    <form className="form compact" style={{borderTop:'1px solid var(--line)',marginTop:12,paddingTop:12}} onSubmit={addPayment}>
      <Field label="المبلغ المدفوع (AED)" required><input required type="number" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
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
  const AR_MONTHS=['يناير','فبراير','مارس','أبريل','مايو','يونيو','يوليو','أغسطس','سبتمبر','أكتوبر','نوفمبر','ديسمبر'];
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
      <Field label="المبلغ المدفوع (AED)" required><input required type="number" step="0.01" value={payForm.amount} onChange={e=>setPayForm({...payForm,amount:e.target.value})}/></Field>
      <Field label="تاريخ الدفع" required><input required type="date" value={payForm.payment_date} onChange={e=>setPayForm({...payForm,payment_date:e.target.value})}/></Field>
      <Field label="ملاحظات" wide><input value={payForm.notes} onChange={e=>setPayForm({...payForm,notes:e.target.value})}/></Field>
      <button><Plus size={14}/>تسجيل دفع</button>
    </form>
  </div>}
</Modal>
</>;
}

createRoot(document.getElementById('root')).render(<App/>);
