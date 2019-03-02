require 'pry'
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


require 'io/console'
curves = packed.map do |x,y,s|
  c=s.unpack('m')[0].unpack('b*')[0].chars
  []while'1'!=c.pop
  n=[]
  n<<(
    c.shift==?0 ?
    (v=c.shift(4).join.to_i 2)>7?v-=16:v :
    (v=c.shift(5+2*a=c.shift.to_i).join.to_i 2)>15+a*48?v-40-a*112:v+7+a*15
  )while c[0]
  n.each_slice(6).map{|a,b,c,d,e,f|[x,y,a,b,a+c,b+d,s=a+c+e,t=b+d+f,x+=s,y+=t]}
end

rows, cols = IO.console&.winsize||[0,0]
size = [[rows * 2, cols].min,48].max
canvas = Array.new(size) { [0] * size }
curves.zip([1,2,*([3]*8),4,4,*([5]*6)]) do |curve, color|
  coords = []
  curve.each do |x,y,q,r,s,t,u,v|
    n=1+(u.abs+v.abs)*w=size/1024.0
    n.to_i.times do |i|
      a=3*(1-z=i/n)**2*z
      coords<<[(x+a*q+z**3*u+s*b=3*z*z*(1-z))*w,(y+a*r+z**3*v+t*b)*w]
    end
  end
  segments = {}
  coords.each_with_index do |(next_x, next_y), i|
    prev_x, prev_y = coords[i-1]
    xb = coords[i+1-coords.size][0]
    x0, x1 = [prev_x, next_x].sort
    (x0.ceil..x1.floor).each do |ix|
      next if ix == prev_x || (ix == next_x && (prev_x - next_x) * (xb - next_x) >= 0)
      (segments[ix] ||= []) << prev_y + (next_y - prev_y) * (ix - prev_x) / (next_x - prev_x)
    end
  end
  segments.each do |ix, ys|
    ys.sort.each_slice(2) do |y1, y2|
      (y1.ceil...y2).each do |iy|
        canvas[ix][iy] = color
      end
    end
  end
end

(size / 2).times do |y|
  puts size.times.map{|x|
    [
      %( `''"^),
      %(.:]TYY),
      %(,;IEPP),
      %(cjL8RR),
      %(xLJ&WW),
      %(xLJ&##)
    ][canvas[x][2 * y + 1]][canvas[x][2 * y]]
  }.join.gsub(/ +$/, '')
end
