data = File.read 'tompng.svg'
colors = data.scan(/<path fill="#(.{6})"/).map do |(color)|
  rgb = color.scan(/../).map { |c| c.to_i(16) }
  1 - rgb.sum.fdiv(0xff*3)
end
colors = colors.map { |c| (c - colors.min) / (colors.max - colors.min) * 0.9 + 0.1 }

starts = []
curves_base = data.scan(/d="[^"]+"/).map do |s|
  x, y, *other = s.scan(/-?\d+/).map(&:to_i)
  starts.push [x, y]
  other.each_slice(6).map { |a,b,c,d,e,f| [a, b, c - a, d - b, e - c, f - d] }.flatten
end
packed = curves_base.zip(starts).map do |numbers,(sx,sy)|
  bits = numbers.map do |v|
    next [0, 4.times.map{|i|(v>>i)&1}.reverse] if -8 <= v && v < 8
    v -= v > 0 ? 8-1 : -8
    next [1, 0, 5.times.map{|i|(v>>i)&1}.reverse] if -16 <= v && v < 16
    v -= v > 0 ? 16-1 : -16
    next [1, 1, 7.times.map{|i|(v>>i)&1}.reverse]
  end
  [sx,sy,[[bits.join+'1'].pack('b*')].pack('m').delete("\n=")]
end

code = File.read(__FILE__).split(/\nexit\n/).last
packed_rb = '[' + packed.map { |x,y,s| "[#{x},#{y},%(#{s})]" }.join(",\n") + ']'
code = code.gsub('packed', packed_rb)

File.write('tmp.rb', code) unless File.exist? 'tmp.rb'
tmp = File.read('tmp.rb').delete "\n "
unless File.exist? 'template.txt'
  require 'chunky_png'
  png = ChunkyPNG::Image.from_file 'template.png'
  ratio = (png.width*png.height).times.count{|xy|(png[xy%png.width,xy/png.width]&0xff00)<0xff00/2}.fdiv(png.width*png.height)
  w = 184
  h = (tmp.size / (1-ratio) / w).round
  p tmp.size, w, h
  shape = h.times.map{|y|
    w.times.map{|x|
      (png[x*png.width/w,y*png.height/h]&0xff00)<0xff00/2 ? ' ' : '#'
    }.join
  }.join("\n")
  File.write 'template.txt', shape
end
shape = File.read 'template.txt'
idx=0
out=''
shape.chars.map{|c|
  if c=='#'
    out << (tmp[idx] || ';')
    idx+=1
  else
    out << c
  end
}
out << (tmp[idx..-1]||';')
File.write('out.rb', out)
code.delete!("\n ")
eval out
exit

require'io/console';
cx,w,h,m=cy=0.5;
zm=2;
R=->{
  l='';
  h,w=IO.console&.winsize||[48]*2;
  h*=2;m=1.0*[w,h].min;
  m*zm<=w&&cx=0.5;
  m*zm<=h&&cy=0.5;
  g=(0...h).map{[0]*w};
  packed.map{|x,y,c|
    c=c.unpack(?m)[0].unpack('b*')[0].chars;
    []while'1'!=c.pop;
    n=[];
    n<<(
      c.shift==?0 ?
      (v=(c.shift(4)*l).to_i(2))>7?v-=16:v :
      (v=(c.shift(5+2*a=c.shift.to_i)*l).to_i(2))>15+a*48?v-40-a*112:v+7+a*15
    )while(c[0]);
    c=[];
    n.each_slice(6){|q,r,s,t,u,v,p=(m*zm/1024.0)|
      u+=s+=q;
      v+=t+=r;
      (0...n=1+(u.abs+v.abs)*p).each{|i|
        a=3*(1-z=i/n)**2*z;
        c<<[
          (x+a*q+z**3*u+s*b=3*z*z*(1-z))*p+(w-m*zm)*cx,
          (y+a*r+z**3*v+t*b)*p+(h-m*zm)*cy
        ]
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
      ([p.ceil,0].max..[q.floor,w-1].min).each{|j|
        j!=u&&(j!=x||(u-x)*(c[i][0]-x)<0)&&(s[j]||=[])<<v+(y-v)*(j-u)/(x-u)
      }
    };
    s.map{|i,t|
      t.sort.each_slice(2){|u,v|
        ([u.ceil,0].max...[v,h].min).map{|j|g[j][i]=a}
      }
    }
  };
  $> << "\e[1;1H\e[J"+g.each_slice(2).map{|a,b|(a.zip(b).map{|i,j|%(\x20`''"^.:]TYY,;IEPPcjL8RRxLJ&WWxLJ&##)[i+6*j]}*l)}*"\r\n"
};
R[];
trap(:WINCH){R[]};
STDIN.raw{
  loop{
    s=$<.getc;
    s.ord==3&&exit;
    s=="\e"&&s<<$<.gets(2);
    zm=[1,16,zm*2**(('-m+p'.index(s)||1.0)/2*2-1)].sort[1];
    cx=[0,cx+(s=~/[ahD]/?1:s=~/[dlC]/?-1:0)*w/(w-m*zm+1)/2,1].sort[1];
    cy=[0,cy+(s=~/[wkA]/?1:s=~/[sjB]/?-1:0)*h/(h-m*zm+1)/2,1].sort[1];
    R[]
  }
}
