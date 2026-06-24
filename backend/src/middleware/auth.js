import jwt from 'jsonwebtoken';
export function auth(req,res,next){
 const h=req.headers.authorization||''; const token=h.startsWith('Bearer ')?h.slice(7):null;
 if(!token) return res.status(401).json({message:'Unauthorized'});
 try{ req.user=jwt.verify(token, process.env.JWT_SECRET || 'dev_secret'); next(); }
 catch{ return res.status(401).json({message:'Invalid token'}); }
}
export function adminOnly(req,res,next){ if(req.user?.role!=='ADMIN') return res.status(403).json({message:'Admin only'}); next(); }
