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

colors = [1, 2, 3, 3, 3, 3, 3, 3, 3, 3, 4, 4, 5, 5, 5, 5, 5, 5]

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

require 'io/console'

rows, cols = IO.console&.winsize||[0,0]
size = [[rows * 2, cols].min,48].max
canvas = Array.new(size) { [0] * size }
curves.zip(colors).each do |curve, color|
  coords = []
  curve.each do |x, y, dx1, dy1, dx2, dy2, dx3, dy3|
    dx=dx1+dx2+dx3
    dy=dy1+dy2+dy3
    step = (dx.abs + dy.abs) * size / 1024 + 1
    step.times do |i|
      t = i.fdiv step
      a = 3 * t * (1 - t) * (1 - t)
      b = 3 * t * t * (1 - t)
      c = t * t * t
      coords.push [
        (x + a * dx1 + b * (dx1+dx2) + c * dx) * size / 1024,
        (y + a * dy1 + b * (dy1+dy2) + c * dy) * size / 1024
      ]
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
