require'io/console';
s=IO.console&.winsize;g=(0...m=2*($*[0]&.to_i||(s&&[s[0],s[1]/2].min)||24)).map{[0]*m};
packed.map{|x,y,c|
  c=c.unpack(?m)[0].unpack('b*')[0].chars;
  []while'1'!=c.pop;
  n=[];
  n<<(
    c.shift==?0 ?
    (v=(c.shift(4)*'').to_i(2))>7?v-=16:v :
    (v=(c.shift(5+2*a=c.shift.to_i)*'').to_i(2))>15+a*48?v-40-a*112:v+7+a*15
  )while(c[0]);
  c=[];
  n.each_slice(6){|q,r,s,t,u,v|
    u+=s+=q;
    v+=t+=r;
    (0...n=1+(u.abs+v.abs)*w=m/1024.0).each{|i|
      a=3*(1-z=i/n)**2*z;
      c<<[(x+a*q+z**3*u+s*b=3*z*z*(1-z))*w,(y+a*r+z**3*v+t*b)*w]
    };
    x+=u;
    y+=v
  };
  c
}.zip([1,2,*([3]*8),4,4,*([5]*6)]){|c,a|
  s={};
  c.size.times{|i|
    u,v=c[i-2];
    x,y=c[i-1];
    p,q=[u,x].sort;
    (p.ceil..q.floor).each{|j|
      j!=u&&(j!=x||(u-x)*(c[i][0]-x)<0)&&(s[j]||=[])<<v+(y-v)*(j-u)/(x-u)
    }
  };
  s.map{|i,t|
    t.sort.each_slice(2){|u,v|
      (u.ceil...v).map{|j|g[j][i]=a}
    }
  }
};
puts(g.each_slice(2).map{|a,b|(a.zip(b).map{|i,j|%(\x20`''"^.:]TYY,;IEPPcjL8RRxLJ&WWxLJ&##)[i+6*j]}*'')})