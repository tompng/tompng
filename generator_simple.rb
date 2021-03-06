require 'chunky_png'
def load_shape(name, w)
  img = ChunkyPNG::Image.from_file "resources/#{name}.png"
  h = (w * img.height / img.width).round
  lines = h.times.map do |y|
    chars = w.times.map do |x|
      color = img[img.width * x / w, img.height * y / h]
      color & 0xff00 < 0xff00 / 2 ? '#' : ' '
    end
    chars.join
  end

  a=lines.map{|a|a.scan(/^ */).first.size}.min
  b=lines.map{|a|a.scan(/ *$/).first.size}.min
  p [a, b]
  lines.map!{|l|l[a...-b]}
  lines.shift while lines.first.count('#')==0
  lines.pop while lines.last.count('#')==0
  lines=lines.each_slice(2).map(&:first)+lines.each_slice(2).map(&:last)
  [lines[0].size,lines.size, lines.join("\n")]
end

w,h,shape = load_shape('tompng', 40)

segments = shape.delete("\n").scan(/( +)(#+)/).flatten.map(&:size)
s=segments.map{|a|(a+32).chr}.join
s+='@tompng'.reverse
quote = '%q~'+s.gsub('\\','\\\\\\')+'~'

code, template = DATA.read.split(/\n{2,}/)
chars = code.delete(" \n").gsub('QUOTE', quote).chars
eval chars.join
formatted = template.lines.map{|l|
  chars.shift if chars.first==';'
  l.gsub('#') { chars.shift }
}.join
File.write 'tompng_simple.rb', formatted
puts formatted
__END__
i=0;s=%w`a=(q=QUOTE).chars.map{|c|[i=1-i]*(c.ord-32)}*'';952.times{|i|
  $><<(q[1127-i]||('#",%c'%32)[(a[i]+a[i+952]).to_i(2)])<<$/[~i%34]
}`*'';eval(s)

   ###
#########   ########   ######## ######   #########    ### #####    #########
#########  ##########  ################  ###########  ##########  ###########
   ###     ###    ###  ###   ####   ###  ###     ###  ####   ###  ####   ####
   ###     ###    ###  ###   ####   ###  ###     ###  ###    ###  ####   ####
   ######  ##########  ###   ####   ###  ###########  ###    ###   ##########
   ######   ########   ###   ####   ###  #########    ###    ###     ########
                                         ###                      ###    ####
                                         ###                      ##########
