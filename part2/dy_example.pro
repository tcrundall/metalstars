;This is an example of a comment
;To compile and run this code, type ".r dy_example" and you should see this ...
;
;IDL> .r dy_example 
;% Compiled module: $MAIN$.
;% Compiled module: REVERSE.
;      1.00000
;      2.00000
;      3.00000


a = [1,2,3] 	; define an array
a = float(a) 	; change integers to float

b = reverse(a) 	; invert the array 

nmax = n_elements(a) ; define the number of elements in array "a"

for i=0,nmax-1 do begin	;loop over all elements in array "a" 

	print, a(i) ;write each element of the array

endfor

 plot, a, b, line=0 ; an example plot 

end

