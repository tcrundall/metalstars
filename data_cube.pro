FITS_READ, 'data_cubes/s1.fits', data, header
header
; dim1: wavelength      411
; dim2: right ascension  66
; dim3: declination      51

help, data
print, 'want to transpose so dimensions are RA, Dec, wl'
print, ' so 66, 51, 411'
data_t = transpose(data, [1,2,0])

print, 'should now read [66, 51, 411]...'
help, data_t

tarr1 = findgen(2,3,5)
tarr_2d = fltarr(2,3)

print, "dims of tarr_2d"
help, tarr_2d

data_2d = fltarr(66,51)

For i=0,65 Do $
	For j=0,50 Do $
		data_2d(i,j) = median(data_t(i,j,*))


