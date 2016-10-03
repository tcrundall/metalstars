; reads in a fits file and stores in out as [RA, Dec, wavelength]
PRO readin, cubeno, out
	filename = strjoin(["fits/s100303_", cubeno, "_Hn3_100.fits"])
	FITS_READ, filename, data, header
	; dim1: wavelength      411
	; dim2: right ascension  66
	; dim3: declination      51
	
	;print, 'want to transpose so dimensions are RA, Dec, wl'
	out = transpose(data, [1,2,0])
END

; takes a row of fluxes and returns the index
; of the location of median flux
; this is achieved by finding total flux (incremented so as to account
; for negative fluxes) and finding the index in which the sum is half total
PRO getmedix, data, out
	length = 411

	; each flux is incremented slightly to keep total positive
	total_flux = total(data + 0.05)
	raw_tflux = total(data)
	half_f = 0.5 * total_flux

	; debugging - since half_f isn't guaranteed to be positive before loop
	; trial and error has assured this now
	if (half_f LT 0) then print, half_f 

	i = 0
	while (half_f GT 0) do begin
		half_f -= data[i] + 0.05
		i++
	endwhile 
	out = i - 1
END

; takes a row of fluxes and returns the median wavelength
FUNCTION getmedwl, data
	length = 411

	getmedix, data, ix
	
	refwl = 1594
	delwl = 0.2

	if (ix EQ 205) then return, 0.0

	return, refwl + delwl*ix
END

; takes a whole fits datacube and collapses it to the strongest
; (by median) wavelength per pixel
PRO wlcollapse, cube, result
	result = fltarr(66,51)
	
	for i=0, 66-1 do begin
		for j = 0, 51-1 do begin
			result[i,j] = getmedwl(cube[i,j,0:410])
		endfor
	endfor	
END

; a rough trapezoidal approximation of the h-alpha (#1) filter
FUNCTION filter, wl 

	; shift the observed wavelengths to corresponding wavelengths at
	; rest given the redshift = 1.489
	wl = wl/(1+1.489)
	if (wl GT 664) and (wl LT 672) then return, -0.00125*wl + 0.84
	if (wl LT 643) or  (wl GT 672) then return, 0.0
	if (wl GT 643) and (wl LT 653) then return, 0.001*wl - 0.0643
	if (wl GT 653) and (wl LT 664) then return, 1
END

; convert wavelength to binary image where the wavelength
; would be picked up by h-alpha filter if subject was at rest
; (deshifted wl > 648 and < 667
PRO halpha, cube, result
	wlcollapse, cube, wlarr

	result = fltarr(66,51)
	;result = filter(wlarr)
	
	;FOR i=0, 66*51 - 1 do result[i] = filter(wlarr[i])

	for i=0, 66*51 -1 do begin
		if ( (wlarr[i] GT 1613) and (wlarr[i] LT 1660) ) then result[i] = filter(wlarr[i])
	endfor
END

; write the halpha 2d image to a csv file
PRO write, data, cubeno
	filename = STRJOIN(["halphas/s100303_", cubeno, "_halpha.csv"])
	$ touch halphas/c1cube.csv
	$ echo here
	WRITE_CSV, filename, data
END

; produce an halpha image for each fits file
PRO main

	files = ["a023003", "a023004", "a024001", "a024003", "a024004", "a025001", $
					 "a030001", "a031001", "a031003", "a031004", "a032001", "a032003", $
					 "a032004", "a033001", "a033003", "a033004", "a034001", "a034002"]

	for i=0, 17 do begin
		readin, files[i], cube
		halpha, cube, result
		write, result, files[i] 
	endfor
END
