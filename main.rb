require 'pry'
SIZE = 256
data = File.read 'tompng.svg'
colors = data.scan(/<path fill="#(.{6})"/).map do |(color)|
  rgb = color.scan(/../).map { |c| c.to_i(16) }
  1 - rgb.sum.fdiv(0xff*3)
end
colors = colors.map { |c| (c - colors.min) / (colors.max - colors.min) * 0.9 + 0.1 }

curves = data.scan(/d="[^"]+"/).map do |s|
  /M(?<start>-?\d+ -?\d+) c(?<other>.+)/ =~ s
  x, y = start.split.map(&:to_i)
  other.split(',').map do |bez|
    points = [x, y, *bez.split.map(&:to_i)]
    x += points[6]
    y += points[7]
    points
  end
end


canvas = Array.new(SIZE) { [0] * SIZE }
def show(canvas, n=16)
  step = canvas.size / n
  (step / 2).times do |y|
    line = step.times.map do |x|
      a = (n * n).times.sum { |i|canvas[n * x + i % n][2 * y * n + i / n] }.fdiv(n * n)
      b = (n * n).times.sum { |i|canvas[n * x + i % n][(2 * y + 1)* n + i / n] }.fdiv(n * n)
      ai = a < 0 ? 0 : a >= 1 ? 3 : (a * 4).floor
      bi = b < 0 ? 0 : b >= 1 ? 3 : (b * 4).floor
      ai = 1 if (a>0 && ai == 0)
      bi = 1 if (b>0 && bi == 0)
      [%( '"^),%(.:TY),%(,;EP),%(xLJ#)][bi][ai]
    end
    puts line.join
  end
end
t0 = Time.now
curves.zip(colors).each do |curve, color|
  coords = []
  curve.each do |x, y, dx1, dy1, dx2, dy2, dx, dy|
    step = [[dx.abs, dy.abs].max * SIZE / 1024 / 2, 1].max
    step.times do |i|
      t = i.fdiv step
      a = 3 * t * (1 - t) * (1 - t)
      b = 3 * t * t * (1 - t)
      c = t * t * t
      px = (x + a * dx1 + b * dx2 + c * dx) * SIZE / 1024
      py = (y + a * dy1 + b * dy2 + c * dy) * SIZE / 1024
      coords.push([px, py])
    end
  end
  prev_x, prev_y = coords.last
  segments = {}
  coords.each do |(next_x, next_y)|
    x0, x1 = prev_x < next_x ? [prev_x.ceil, next_x.floor] : [next_x.ceil, prev_x.floor]
    (x0..x1).each do |ix|
      next if ix == next_x
      y = prev_y + (next_y - prev_y) * (ix - prev_x) / ((next_x - prev_x).nonzero? || 1)
      (segments[ix] ||= []) << y
    end
    prev_x = next_x
    prev_y = next_y
  end
  segments.each do |ix, ys|
    ys.sort.each_slice(2) do |y1, y2|
      break if y2.nil?
      (y1.ceil...y2).each do |iy|
        canvas[ix][iy] = color
      end
    end
  end
end

puts(Time.now - t0)
# binding.pry
#
# 1024.times.to_a.repeated_permutation(2){|i,j|canvas[i][j]=i < j ? 1 : 0}
show(canvas, 1)
