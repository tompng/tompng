data = File.read 'resources/tompng.svg'
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

# code = File.read('src/dynamic.rb')
code = File.read('src/static.rb')
packed_rb = '[' + packed.map { |x,y,s| "[#{x},#{y},%(#{s})]" }.join(",\n") + ']'
code = code.gsub('packed', packed_rb)

File.write('tmp.rb', code) unless File.exist? 'tmp.rb'
tmp = File.read('tmp.rb').delete "\n "
unless File.exist? 'template.txt'
  require 'chunky_png'
  png = ChunkyPNG::Image.from_file 'resources/template.png'
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
eval code
exit
