​<!-- run(`ruby README.md`).to_update
BEGIN {
    pattern = /<!-{2} EMBED: ((?<path>[\w.\/]+)|`(?<command>[^`]+)`) -{2}>(\n?```+(?<type>\w*)(\n|([^`\n]|`[^`\n]|``[^`\n])[^\n]*\n)*```\n)?/
  markdown = File.read(__FILE__).gsub pattern do |text|
    match = pattern.match text
    [
      "<!#{'-' * 2} EMBED: #{match[:path] || "`#{match[:command]}`"} #{'-' * 2}>",
      "```#{match[:type]}",
      (match[:path] ? File.read(match[:path]) : `#{match[:command]}`).gsub(/\n\z/, ''),
      '```'
    ].join("\n") + "\n"
  end
  File.write __FILE__, markdown
  exit
}
__END__
-->

# Self Introduction Code

<!-- EMBED: tompng_simple.rb -->
```ruby
   i=0
s=%w`a=(q   =%q~'%9,   4/23/7+9 *9):(;   '<%#!:$"!    8!# %9!$$    9"$":#$!9
$'!5&&"2*  $"*#%+##'&  &)"%&%).%&*-%)$1  $=(9*8(:(8*  6.3015-8+9  ):(:(;'<%"!
   <#;     !$$    9"$  ":"   $":#   '!6  %&"     3(%  "2+#   "(&  %*"$   '&'(
   "%%     &*-    $'(  !!-   %*"2   &;(  9*8     (?"  gnp    mot  @~).   char
   s.map{  |c|[i=1-i]  *(c   .ord   -32  )}*'';952.t  ime    s{|   i|$><<(q[1
   127-i]   ||('#".%   c'%   32)[   (a[  i]+a[i+95    2])    .to     _i(2)])<
                                         <$/                      [~i    %34]
                                         }`*                      '';eval(s)
```

<!-- EMBED: `ruby tompng_simple.rb` -->
```
    ...#####..                    
  .############.                  
 ###############.                 
###################..             
#######################.          
"########################.        
 #########################.       
 ##########################       
 ###########################      
 ############################     
##".##########################.   
##.######################## ###.  
  ######################### "###. 
 .#########################  #### 
 ##########################   ####
.##"######################    "###
### "###################"      "##
###  ##################          "
###  ########""   "####.          
##"   #######      ######.        
##     #####"     #########.      
       ####"      ########"#      
       #####         "##"         
        ####..                    
       ########                   
      ##########                  
      ########                    
      """""##"             @tompng
```


<!-- EMBED: tompng.rb -->
```ruby
require'io/console';cx,w,h,m=cy=0.5;zm=2;R=->{l='';h,w=IO.console&.winsize||[48]*2;h*=2;m=1.0*[w,h].min;m*zm<=w&&cx=0.5;m*zm<=h&&cy=0.5;g=(0...h).map{[0]*w};[[524,489,%(H9zR0b8H/R4EJlT
y5fyPUDVdSVeyIiuzaChOoHiIwhiK9wfZpEuoHKGEBkHQcBv9EWmH28FWXMf0kHDYhi0R3AYdgxEYgYNDGZiGKZ3zOTeC52RWRdv5Zr414suo7ujuEpZHeZyNUsMMEE5a0e41OvXu5/b3wvf/z299+f/lX6H4wQY)],[509,22,%(FVAgpVA59Dv
dSraTKmVyJoeGk6FkaGhSNB1JDwE0SZK1gWKgHNjP98f1x9a2uGluWnANC7Igx8wwS1+Tv+Qv/EiKpBD6iiAGPoFiME5G04EkHxpGEyxBOYmQiI2wMA1HEjEYg8Pq0Ua0jt8ggYR3yGADHbfcjOnkTc4M4RmZFpFWop6oD/wT+h/6D76Doi+pv67
velZAD31yUD     ATzJBJ4WGhoZERsVwsmx8ZtCGHv7iCL3b/9H73/rR/1n82fn170yv3y7Tbr/cb9Xq5Wqo9rxQrxXL7T7PZbPQ6DVHvV0wZBA)],[628,111,%(APz70G6321JUVFU/w/+DhWA13My2cnqsHmvGssVuuBthciZt0/0oiMF4cD
CDDMT+E4GFN     qRP+0N/R0VURHQIhkEqDgAArBnqBDvj3/MO7wJBNDHEU8tsBFBJBfmvOqpT7tV1Xf/0Xdqh3QgMgdDIJGSQaWawRlIppHE/4ailkFpooe5rYIAhhhrqsxop3LdaaeUbsA7r9HuoEqpEa8lmspVr5EzODOPpYCo4aDgAAQ)],
[639,115,%(     EMzODowPTIweFIlH4zSNKGKYeOihMsoo06y3ZUfUZNu3XZF74AEEHnjQLOqe7jth+65vasBDDwD0AQ)],[417,358,%(DndGi+FieHu5nqQmu6lwOBxOJ2KCCULYYUc/4P/4H/pACrjA/pI+6TOBIQImCcIwApMkQsIszhGH
UUn7tK++gC7     seoc7uJv/Bhqw0a44bbX10EGXYTEQhymYU1k5/Veyl+xREVERFZEhGIbhMCUUA0oQhiGNIIIeAwyIjeEgDobCjDLGHeWUw6kYIEAkklCaouu6nukBAzQyCCCQHhnKh3LB0cHBwcHB4eFMOJMbAgAA1U+yLuq9/0ADDSwCCGS
HAgCA                 /NAviGLje             6fUKdWLqqM      6so         088rFI          MBgMZoYhD      4H            umb7pV78YY     QSQ1          jtngUUG9kOWOgo           pp      JBy5q
mnimu                 kUccbbX                 WoZvu2L3      t             9I              0wLtmmb                      VjPNcCPc     Cj              bCzXA9Wg/W                     g6VgG
7VRxw                 sjjOl        qq50B        BhjomA           EG             iJ4        DFgBoc           Q)],         [733,+           435        ,%(HkcZ        pJAoC          imgLE
QghtRhi60X2     CATdMggA6S      z1gpvoYWAW       mhBp2        +AARYDF         A)],[33      +400,+        624,%(AITH      hrKhTH         ZSiIUYBS     Ef8sl+       UAd1SALnn        fUGGN
iJCtRHfdzTX     V0rdmudWu      0NAAE)],[673      ,622,       %(AOTaMRW      XQzvcBm0QA     A+cshp       o0GA90iVd2ud      93kgB       EA)],[513,      +803,      %(APzLi3g/r       lImZZ
JmIIyjOMtgj     DEE1BOfas      RBHIwZzBBDEBG      HHfl      CO6zDu9RQz      RDWyNi2FU5     4KYUSb      dEUrf67MgAB)],     [689,      683,%(7Wh9O      QiBI      KIEURSRHHLIWJ      AFaTQ
RJBxTxC03kT     9cBRVzHHA     fYdQTgD1yyAHlt      TfeS      inFhVs1W7V      90okG)],[8     *60-1,      766,%(DoORMARD     hALqq     WUAAJBAERAGO      Rd2Y      R+zAACgpdVOmb      bt275
qeesN9M4716     J92Ac1a6E     BHngc)],[659,+      765,      %(ANAulVTF      ekxyiRTXTA     dVCIVg      OBvmERbDYRzBWQ     wAAEZ     ZbXSv2ev2u/W      mErJ      vrBVO4LrXTnur      nfbFU
Ae3cY1opJAD     DjnsMCCQB     BnmhJMY4JB74rh      lvZA      LuiCLQwoYY      AAE)],[600     ,72,%(      ANTKbdmSdVUGZf     AxVIl     UI+1UP96P27B      N2RQ      Z6AeCvJqJEEZI      UkB8l
FFMMWYEEgAt     c8xN6BBPH      PIAQvA9I7jkDu     ugCvY      yhltmqccee      QwhBLF2UIV     UTIdNW      HMYkVE5pBRpRV      qgHu6     Gu3nJFVfUQgm      lbIh+     X1Rk27VcDfVx       n0jus
CMQIYLp0CTE     kBjkkEPWW2     yxjymmWItJJJ      G0Ghn      kmSGGyLCEE      vW9VkrZIqy     havw7b       /Em0cFOsB0p       xPrRX     tzFXcJmQBwn8      KA4AA      E)],[16*31        ,205,
%(FkpmiSWGQ     QgR99hjRxy       y2BLlHXD       GWRA)]      ,[375,5*68      ,%(DqiYCZt     IbyCIw          mg4hSGG       0GGLbe     Qn6ZIubgAAQC      dtnPX4        j7fe           eOtB)
],[645,130,           %(AJA                    8D/NwPB      jncT4IxVmc      JYKMMEIZ8B     C0S33R                       77dkx3R     0FWmrjVXQQZu      j0AJb6HR                     0V5c1
AAE)],[433,           379,%(D                lrosMMo7a      IuIqM6oZO9      jB6kB5lZIO     mTIIkh      g              thigzQqox     ZsggpuozZpY4      klNVAj7QS0          0AI      LPQQE
QgyRZT7ouU2iC         IzQFCGEEkQ          89ayLFZFIAgm      lllBAEWwTQ      SR1uI/65oe     RRkprv      fUOeO      QgCjvkkAXWWSe     KzjnngQMB)],      [843,387,%(ANR+9tv9Vqvk     nPXeO+
ghisAQCsIwi7PEyHkIYwIRAtBD5a231jvjtO2avul3/gMAwMAhGGGEEPQB)]].map{|x,y,c|n=[];c=c.unpack('m')[0].      unpack('b*')[0].chars;[]while'1'!=c.pop;n<<(c.shift==?0?(v=c.shift(4)      .join.
to_i(2))>7?v-=16:v:(v=(c.shift(5+2*a=c.shift.to_i)*l).to_i(2))>15+a*48?v-40-a*112:v+7+a*15)while(      c[0]);c=[];n.each_slice(6){|q,r,s,t,u,v,p=(zm*m/1024)     |u+=s+=q;       v+=t+=r
;(0...n=1+(u.abs+v.abs)*p).map{|i|a=3*(1-z=i/n)**2*z;c<<[(x+a*q+z**3*u+s*b=3*z*z*(1-z))*p+(w-m*zm      )*cx,(y+a*r+z**3*v+t*b)*p+(h-m*zm)*cy]};x+=u;y+=v};c}                    .zip([1,
2,*([3]*8),4,4,*([5]*6)]){|c,a|s={};c.size.times{|i|u,v=c[i-2];x,y=c[i-1];p,q=[u,x].sort;([p.ceil      ,0].max..[q.floor,w-1].min).each{|j|j!=u&&(j!=x||(x-u)*                (-c[i][0]+
x)<0)&&(s[j]||=[])<<v+(y-v)*(j-u)/(x-u)}};s.map{|i,t|t.sort.each_slice(2){|u,v|([u.ceil,0].max...      [v,h].min).map{|j|g[j][i]=a}}}};$><<("\e[1;1H\e[J");$>.write     g.each_slice(2).
map{|a,b|(a.zip(b).map{|i,j|%(\x20`''"^.:]TYY,;IEPPcjL8RRxLJ&WWxLJ&##)[i+6*j]}*l)}*"\r\n"};R[];trap(:WINCH){R[]};STDIN.raw{loop{s=$<.getc;s.ord==3&&exit;s=="\e"&&s<<$<.gets(2);zm=[2**(
('-m+p'.index(s)||1.0)/2*2-1)*zm,16,1].sort[1];cx=[0,cx+(s=~/[ahD]/?1:s=~/[dlC]/?-1:0)*w/(w-m*zm+1)/2,1].sort[1];cy=[0,cy+(s=~/[wkA]/?1:s=~/[sjB]/?-1:0)*h/(h-m*zm+1)/2,1].sort[1];R[]}}
```

<!-- EMBED: `ruby tompng_static.rb` -->
```

                                   ,cxJJJJJxc
                               ,cJ&###RRRPPPRRJ
                             ,I8####REEIIIIIIIIE,
                             IL####PIIIIIIIIIIIIII,
                            II####EIIIILJJJJJLIIIIE&&xc
                            II###EIIIII########8IIIR###R8c
                            II##8IIIIIIIP#######IIII8RRR##&xc
                            'I##8IIIIIJ8#####RPEIIIIIIIIIIEPR&
                             I##8IILJ&&####R8IIIIIIIIIIIIIIIIE8
                             'RR&JJ#R#####REIIIIIIIIIIIILLIIIII,
                              88888&####REIIIIIIIIIIIL88888LIL88
                             c888&###RR8EIIIIIIIIIL888EEE88EII&E8
                             &88&REIIIEIIIIIIIIL888EIIIIIIEE88##IE,
                             #88'8L8LIIIIIILL888EIIIIIIIIIII888#RJI,
                            ### 88#8&8EE888EEEIIIIIIIIIIIIIIIE8,#8LI,
                            ##'L88####8IIIIIIIIIIIIIIIIIIIIIIII8 P8LII
                               88######IIIIIIIIIIIIIIIIIIIE8L8IE  88LI,
                              L8#R####EIIIIIIIIIIIIIIIIIIIIE8III  I88II,
                             ,8&#8###EIIIIIIIIIIIIIIIIIIIIIIIIII   E88II
                             I8#8I###IIIIIIIIIIIIIIIIIIIIIIIIII'   'LEIII
                             88#I]##RIIIIIIIIIIIIIIIIIIIIIIIII'     ILIII
                            I8##::888IIIIIIIIIIIIIIIIIIIIIILL'       'LIII
                           :I8#P::IEEIIIIIIIIIIIIIIIIIILEEI'          'LI'
                          ::I8#I::IIIIIIIIIIIIIIIIIIJJJJWWW             '
                       ..:::I88I:::IIIIIIIIIIII]]]:YWWWWWWW
                    .:::::::I88::::EIIIIIIIII::::::::WWWWWWWx.
                  .:::::::::I88:::::ELIIIIIII::::::::WWWRRWWWWL:..
                 :::::::::::I8E::::::ELIIILL]:::::::WWR8888RRWWW:::.
                :::::::::::::]:::::::IIEEEI]::::::::R888888888888j``
                ::::::::::::::::::::::WWWWW::::::::`'''888888'''''
                ::::::::::::::::::::::WWWWWW::::`       '888'
                 :::::::::::`:::::::::WWWWWWL``
                 ::::`` ```          c888888888c
                .:::                 88888888888
                ::`                 888888888888'
                ``                  8888888888'
                                    8888888888
                                     '    ''8'

```
