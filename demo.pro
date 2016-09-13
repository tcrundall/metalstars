x = findgen(200)
y = sin(x/50.0 * 2 * !pi)
;; plot, x, y, yrange=[-2,2]

set_plot, 'ps'
device, filename = 'sin.ps'
plot, x, y, psym=1, xtitle='x', ytitle='sin(x)', yrange=[-2,2], $
	position = [0.2, 0.2, 0.85, 0.9], xcharsize=2, ycharsize=2, $
	xthick=3, ythick=3, charthick=2
oplot, x, y, thick=2
device, /close
set_plot, 'x'

forprint,x,y textout='sin.dat', format='(f,f)'

readcol, 'sin.dat', u, v, format='(f,f)'
