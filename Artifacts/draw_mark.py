import math,struct,zlib
from pathlib import Path
N=1024;data=bytearray(bytes((17,17,17))*N*N)
def poly(p,c):
 for y in range(max(0,int(min(a[1] for a in p))),min(N,int(max(a[1] for a in p))+1)):
  xs=[]
  for a,b in zip(p,p[1:]+p[:1]):
   if (a[1]<=y+0.5<b[1]) or (b[1]<=y+0.5<a[1]):xs.append(a[0]+(y+0.5-a[1])*(b[0]-a[0])/(b[1]-a[1]))
  xs.sort()
  for lo,hi in zip(xs[::2],xs[1::2]):
   l=max(0,int(lo));h=min(N,int(hi)+1);data[(y*N+l)*3:(y*N+h)*3]=bytes(c)*(h-l)
def circ(x,y,r,c):
 p=[(x+math.cos(a*math.pi/90)*r,y+math.sin(a*math.pi/90)*r) for a in range(180)];poly(p,c)
def line(a,b,w,c):
 dx,dy=b[0]-a[0],b[1]-a[1];l=math.hypot(dx,dy);ox,oy=-dy/l*w/2,dx/l*w/2;poly([(a[0]+ox,a[1]+oy),(b[0]+ox,b[1]+oy),(b[0]-ox,b[1]-oy),(a[0]-ox,a[1]-oy)],c);circ(*a,w/2,c);circ(*b,w/2,c)
p=[(-85,-165),(-190,-105),(-240,-5),(-155,40),(-120,-10),(-120,220),(120,220),(120,-10),(155,40),(240,-5),(190,-105),(85,-165),(50,-120),(0,-103),(-50,-120)]
svg=['<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1024 1024"><rect width="1024" height="1024" fill="#111111"/>']
for x,y,a,c in [(642,397,0.23,(64,34,18)),(366,450,-0.20,(255,107,0))]:
 q=[(x+xx*math.cos(a)-yy*math.sin(a),y+xx*math.sin(a)+yy*math.cos(a)) for xx,yy in p];poly(q,c)
 for f,t in zip(q,q[1:]+q[:1]):line(f,t,9,(255,123,26))
 svg.append('<polygon points="'+' '.join(f'{xx},{yy}' for xx,yy in q)+'" fill="rgb'+str(c)+'" stroke="#ff7b1a" stroke-width="9"/>')
circ(485,757,112,(8,8,8));poly([(460,675),(585,675),(654,617),(738,659),(642,773),(550,773)],(8,8,8))
circ(481,746,79,(250,250,250));poly([(460,675),(578,675),(646,624),(714,661),(630,750),(531,750)],(250,250,250));circ(476,746,30,(255,107,0));line((574,698),(610,698),15,(17,17,17))
raw=b''.join(b'\0'+data[y*N*3:(y+1)*N*3] for y in range(N))
def chunk(t,d):return struct.pack('>I',len(d))+t+d+struct.pack('>I',zlib.crc32(t+d)&0xffffffff)
out=Path('BoraJogar/Resources/FieldMark.xcassets/AppIcon.appiconset/Mark.png');out.write_bytes(b'\x89PNG\r\n\x1a\n'+chunk(b'IHDR',struct.pack('>IIBBBBB',N,N,8,2,0,0,0))+chunk(b'IDAT',zlib.compress(raw,9))+chunk(b'IEND',b''))
print(out)