PRO demov1
; Purpose: Demonstrating commands in IDL intro class
; Last updated Aug-15-2016 by TTY


;;;;;;   
; Starting:  type idl at system prompt
; Interrupting:  ctl-c   (stop what idl is doing, sometimes variables disappear)
;                  retall (return to the top, refresh variables)
; Resetting:     .reset    (important when you add new routines to !path)
; Exiting:       exit ; (quit won't work) 
; Aborting:      "ctl-\", only in emergency, will stop the whole idl.


; ----------------------  
; -------------- How to use HELP--------------
  
;  Arrays   
  a= [1.,2., 3.,5.]
  b=[[1.,2,4],[2,6,5]]
  help, a, b

  print,'IDL index starts from zero'
  print, a[0]
  print, b[0,1]
  
  help,a,/str   ;; for structure - see later


stop

;-------------------- Data Types ------
print,' IDL is dynamically typed. Operation can change variable type'
print,' IDL has 8 basic types [float,integral,double,]+ structure'

c=a[0]
help,c
c=double(c)
help,c
c=float(c)
help,c
c=fix(c)
help,c

; -------------- Variables --------------
print, 'Variables Named repositories of information. Has to begin with a letter. 1-128 characters long. Second and subsequent charaters can be letters, numbers, underscore, or the dollar sign.'
strangeV_$4=10 ; but no others like #%@!~^&* because they are reserved for other functions


;-------------- Special Commands --------------
$pwd                            ;unix command
; use $ at the end of line: continue to the next line
   longvariable=[0, 1, 2, 3, $
                    4, 5]   
; @script :  issue a series of idl comments stored in ASCII file

; & issue two commands at the same line
       line1=1 & line2=2 

       
;--------------Operators -------------       
;  + -  * /  > < =
;  #    multiplying the columns of the first array by the rows of the second array.
; ##   multiplying the rows of the first array by the columns of the second array. 
;  &&  logical AND
;  ||  logical OR
;  ~   logical negation
;; see examples online: http://www.harrisgeospatial.com/docs/Logical_Operators.html
;; operator precedence: http://www.harrisgeospatial.com/docs/Operator_Precedence.html

    a = 5 & b=3
IF (A GT B) THEN Z = A ELSE Z = B

retall
Z = (A GT B) ? A : B



;;; Functions vs. Procedures
;; see example of calculating radius



;;; findpro,'procedure/function name'
; findpro,'fits_read'




;; Others: 

;; Smart coding - save Computation  time
; try avoid loops, use:   >WHERE
; reduce repeating calculations :  >SAVE  and then >RESTORE variables
; save data in structures and fits files
; handling multiple files:  string manipulations





;;;;;




;;  Now practice a little bit
;;; THe following exercises are adapted from various resources online

; creates a 4x4 floating-point (f-p) array with values of 0 everywhere
array1 = fltarr(4,4)
help, array1
print, array1


; create a 4x4 double-precision array with values of 0 everywhere
array2 = dblarr(4,4)
help, array2  & print, array2


; create a 4x4 f-p array with values equal to its 1-D subscript (index)
array3 = findgen(4,4)
print, array3



; create two 4x4 f-p arrays with values equal to array3's first and second 2-D subscripts 
x = fix(array3) mod 4          
y = fix(array3) / 4
print,x
print,y
;;  yy = transpose(x)



; array operation
array4 = exp(sqrt((array3 + array2) /20.0) - 1.0)

; create a 200-element sin-wave array with period of 50 and amplitude of 1
x = findgen(200)
y = sin(x/50.0 * 2 * !pi)
plot, x, y, psym=1, xtitle='x', ytitle='sin(x)', yrange=[-2,2]
oplot, x, y


; an equivalent and stupid way (but sometimes necessary) of doing the above
x = fltarr(200)
y = fltarr(200)
FOR i=0,199 DO x[i] = i
FOR i=0,199 DO y[i] = sin(x[i]/50.0 * 2 * !pi) 



; make the above plot into a ps file   ; or eps file, pls google for details
set_plot, 'ps'
device, filename = 'sin.ps'   
plot, x, y, psym=1, xtitle='x', ytitle='sin(x)', yrange=[-2,2], $
   position = [0.2,0.2,0.85,0.9], xcharsize=2, ycharsize=2, $
   xthick=3, ythick=3, charthick=2
oplot, x, y, thick=2
device, /close
set_plot, 'x'
$ gv sin.ps &      ;; gv is very useful as it updates the plot automatically as you run the program

;;
   
   
   
; print the above x,y values to an ASCII file
openw, out, 'sin.dat', /get_lun
FOR i=0,199 DO printf, out, x[i], y[i]
free_lun, out
$more sin.dat

   ;; OR a much simpler way (no loop)
forprint,x,y textout='sin.dat',format='(f,f)'


;  read such an ASCII file into idl
readcol,'sin.dat',x,y,format='(f,f)'
  
;; 

;; NOW MOVE ON TO FITS FILES




   
 

END
