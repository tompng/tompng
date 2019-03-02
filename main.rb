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
packed = curves_base.map do |numbers|
  bits = numbers.map do |v|
    next [0, 4.times.map{|i|(v>>i)&1}.reverse] if -8 <= v && v < 8
    v -= v > 0 ? 8-1 : -8
    next [1, 0, 5.times.map{|i|(v>>i)&1}.reverse] if -16 <= v && v < 16
    v -= v > 0 ? 16-1 : -16
    next [1, 1, 7.times.map{|i|(v>>i)&1}.reverse]
  end
  [[bits.join+'1'].pack('b*')].pack('m').delete("\n=")
end

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
      v = cs.shift(7).join.to_i(2)
      v -= 128 if v >= 64
      v += v > 0 ? 8 - 1 + 16 - 1 : -8 - 16
    end
    aaa << v
  end
  aaa
end

curves = curves_base.zip(starts).map do |numbers, (x, y)|
  numbers.each_slice(6).map do |bez|
    [x, y, *bez].tap do
      x += bez[0]+bez[2]+bez[4]
      y += bez[1]+bez[3]+bez[5]
    end
  end
end

def show(canvas)
  lines = (canvas.size / 2).times.map do |y|
    canvas.size.times.map do |x|
      a = canvas[x][2 * y]
      b = canvas[x][2 * y + 1]
      ai = (a * 3.99).floor
      bi = (b * 3.99).floor
      ai = 1 if a > 0 && ai == 0
      bi = 1 if b > 0 && bi == 0
      [%( '"^),%(.:TY),%(,;EP),%(xLJ#)][bi][ai]
    end.join.gsub(/ +$/, '')
  end
  $><< "\e[1;1H\e[2J#{lines.join("\n")}"
end


require 'io/console'
def render(curves, colors, size)
  rows, cols = IO.console.winsize
  size = [rows * 2, cols].min
  canvas = Array.new(size) { [0] * size }
  curves.zip(colors).each do |curve, color|
    coords = []
    curve.each do |x, y, dx1, dy1, dx2, dy2, dx3, dy3|
      dx=dx1+dx2+dx3
      dy=dy1+dy2+dy3
      step = [[dx.abs, dy.abs].max * size / 1024 / 2, 1].max
      step.times do |i|
        t = i.fdiv step
        a = 3 * t * (1 - t) * (1 - t)
        b = 3 * t * t * (1 - t)
        c = t * t * t
        px = (x + a * dx1 + b * (dx1+dx2) + c * dx) * size / 1024
        py = (y + a * dy1 + b * (dy1+dy2) + c * dy) * size / 1024
        coords.push [px, py]
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
          canvas[ix][iy] = color if 0 <= iy && iy < size
        end
      end
    end
  end
  show(canvas)
end

rows, cols = IO.console.winsize
size = [rows * 2, cols].min
render curves, colors, size
