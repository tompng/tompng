require 'pry'
SIZE = 128
data = File.read 'tompng.svg'
colors = data.scan(/<path fill="#(.{6})"/).map do |(color)|
  rgb = color.scan(/../).map { |c| c.to_i(16) }
  1 - rgb.sum.fdiv(0xff*3)
end
colors = colors.map { |c| (c - colors.min) / (colors.max - colors.min) * 0.9 + 0.1 }

curves_base = data.scan(/d="[^"]+"/).map do |s|
  x, y, *other = s.scan(/-?\d+/).map(&:to_i)

  [x, y, *other.each_slice(6).map{|a,b,c,d,e,f|
    [a, b, c-a, d-b, e-c, f-d]
  }.flatten]
end

packed = curves_base.map{|a|
  [[a.map { |v|
    next [0, 4.times.map{|i|(v>>i)&1}.reverse] if -8 <= v && v < 8
    v -= v > 0 ? 8-1 : -8
    next [1, 0, 5.times.map{|i|(v>>i)&1}.reverse] if -16 <= v && v < 16
    v -= v > 0 ? 16-1 : -16
    next [1, 1, 11.times.map{|i|(v>>i)&1}.reverse]
  }.join+'1'].pack('b*')].pack('m').delete("\n=")
}

colors = [0.1, 0.4, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.7, 0.8, 0.8, 1, 1, 1, 1, 1, 1]

curves_base = packed.map do |s|
  cs = s.unpack('m')[0].unpack('b*')[0].chars.map(&:to_i)
  cs.pop while cs.last == 0
  cs.pop
  aaa = []
  loop do
    break if cs.empty?
    if cs[0] == 0
      cs.shift
      v = cs.shift(4).join.to_i(2)
      v -= 16 if v >= 8
    elsif cs[1] == 0
      cs.shift(2)
      v = cs.shift(5).join.to_i(2)
      v -= 32 if v >= 16
      v += v > 0 ? 8 - 1 : -8
    else
      cs.shift(2)
      v = cs.shift(11).join.to_i(2)
      v -= 2048 if v >= 1024
      v += v > 0 ? 8 - 1 + 16 - 1 : -8 - 16
    end
    aaa << v
  end
  aaa
end

curves = curves_base.map do |(x, y, *other)|
  other.each_slice(6).map do |bez|
    [x, y, *bez].tap do
      x += bez[0]+bez[2]+bez[4]
      y += bez[1]+bez[3]+bez[5]
    end
  end
end

def show(canvas)
  aa = (canvas.size / 2).times.map do |y|
    line = canvas.size.times.map do |x|
      a = canvas[x][2 * y]
      b = canvas[x][2 * y + 1]
      ai = (a * 3.99).floor
      bi = (b * 3.99).floor
      ai = 1 if a > 0 && ai == 0
      bi = 1 if b > 0 && bi == 0
      [%( '"^),%(.:TY),%(,;EP),%(xLJ#)][bi][ai]
    end
    line.join
  end
  $><< "\e[1;1H#{aa.join("\n")}"
end

def render(curves, colors, time)
  canvas = Array.new(SIZE) { [0] * SIZE }
  pos_x = SIZE / 8 * Math.sin(0.7 * time)
  pos_y = SIZE / 8 * Math.cos(1.1 * time)
  scale = 0.7 + 0.5 * Math.sin(0.5 * time)
  curves.zip(colors).each do |curve, color|
    coords = []
    curve.each do |x, y, dx1, dy1, dx2, dy2, dx3, dy3|
      dx=dx1+dx2+dx3
      dy=dy1+dy2+dy3
      step = [[dx.abs, dy.abs].max * SIZE / 1024 / 2, 1].max
      step.times do |i|
        t = i.fdiv step
        a = 3 * t * (1 - t) * (1 - t)
        b = 3 * t * t * (1 - t)
        c = t * t * t
        px = (x + a * dx1 + b * (dx1+dx2) + c * dx) * SIZE / 1024
        py = (y + a * dy1 + b * (dy1+dy2) + c * dy) * SIZE / 1024
        coords.push([
          pos_x + SIZE / 2 + scale * (px - SIZE / 2),
          pos_y + SIZE / 2 + scale * (py - SIZE / 2)
        ])
      end
    end
    prev_x, prev_y = coords.last
    xs = coords.map(&:first)
    segments = {}
    coords.zip(xs.rotate(-1), xs.rotate(1)).each do |(next_x, next_y), xa, xb|
      x0, x1 = prev_x < next_x ? [prev_x.ceil, next_x.floor] : [next_x.ceil, prev_x.floor]
      (x0..x1).each do |ix|
        next if ix == prev_x
        next if ix == next_x && (xa - next_x) * (xb - next_x) >= 0
        y = prev_y + (next_y - prev_y) * (ix - prev_x) / ((next_x - prev_x).nonzero? || 1)
        (segments[ix] ||= []) << y
      end
      prev_x = next_x
      prev_y = next_y
    end
    segments.each do |ix, ys|
      break unless canvas[ix]
      ys.sort.each_slice(2) do |y1, y2|
        break if y2.nil?
        (y1.ceil...y2).each do |iy|
          canvas[ix][iy] = color if 0 <= iy && iy < SIZE
        end
      end
    end
  end
  show(canvas)
end

t0 = Time.now
loop do
  render curves, colors, Time.now - t0
  sleep 0.05
end
