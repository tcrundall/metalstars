; a little program to read in some ASCII files and make sense of them
;

PRO readin, cr09, cr0, cr4, cr3_4, karl
	readcol, "Salvadori2007/mdf2009.dat", c1, c2
	cr09 = transpose([[c1], [c2]])

	readcol, "Salvadori2007/mdfZcr0_2007.dat", c1, c2, c3
	cr0 = transpose([[c1], [c2], [c3]])
	
	readcol, "Salvadori2007/mdfZcr4_2007.dat", c1, c2, c3
	cr4 = transpose([[c1], [c2], [c3]])
	
	readcol, "Salvadori2007/mdfZcr3_4_2007.dat", c1, c2, c3
	cr3_4 = transpose([[c1], [c2], [c3]])
	
	readcol, "Karlsson2006/HMP_MDF2006.tbl", c1, c2
	karl = transpose([[c1],[c2]])
END

PRO samplekarl, data,  nsamples, output
	star_count = total(data[1,0:178])
	sample_ix = star_count * randomu(Seed, nsamples)

	samples = fltarr(nsamples)

	for i = 0, nsamples-1 do begin
		j = 0	
		star_count = sample_ix[i]
		while (star_count GT 0) do begin
			star_count -= data[1,j]
			j++
		endwhile
		samples[i] = data[0,j-1]
	endfor
	output = samples
END

PRO sample2009, data, nsamples, output
	star_count = total(data[1,0:4])
	sample_ix = star_count * randomu(Seed, nsamples)

	samples = fltarr(nsamples)

	for i = 0, nsamples-1 do begin
		j = 0	
		star_count = sample_ix[i]
		while (star_count GT 0) do begin
			star_count -= data[1,j]
			j++
		endwhile
		samples[i] = data[0,j-1]
	endfor
	output = samples
END


PRO sample, data, nsamples, output

	; get total stars with metallicity <= -4
	n_elem = n_elements(data)
	if (n_elem EQ 870) then max_row = 269

	if (n_elem EQ 70) then max_row = 4

	if (n_elem EQ 458) then max_row = 178

	; get total number of stars with metallicity <= -4
	star_count = total(data[1,0:max_row])

	; get a random number in range 0:star_count
	sample_ix = star_count * randomu(Seed, nsamples)
	samples = fltarr(nsamples)

	; work out which 'bin' each star index falls into
	for i = 0, nsamples-1 do begin
		j = 0	
		star_count = sample_ix[i]
		while (star_count GT 0) do begin
			star_count -= data[1,j]
			j++
		endwhile
		samples[i] = data[0,j-1]
	endfor
	output = samples
END

PRO supersample, data, nsupersamples, nsamples, output
	output = fltarr(nsupersamples, nsamples)
	for i=0, nsupersamples-1 do begin
		sample, data, nsamples, out
		output[i,0:nsamples-1] = out
	endfor
END

PRO compare, cr09, cr0, cr4, cr3_4, karl
	N = 10

	kstwo, cr0, cr4, D, prob
	print, prob
	
	kstwo, cr0, cr2009, D, prob
	print, prob
	
	kstwo, cr0, karl, D, prob
	print, prob
	
	kstwo, cr4, cr2009, D, prob
	print, prob
	
	kstwo, cr4, karl, D, prob
	print, prob

	kstwo, cr2009, karl, D, prob
	print, prob

END

PRO plotcomp2, ssample1, ssample2, name

	i = 0
	dim_info = size(ssample1)
	nprobs = dim_info[1]
	n_stars = dim_info[2]
	probs = fltarr(nprobs)
	for i=0,nprobs-1 do begin
		kstwo, ssample1[i,0:n_stars-1], ssample2[i,0:n_stars-1], D, prob
		probs[i] = prob
	endfor
	print, "Probs:"
	help, probs
	print, probs

	nbins = 20

	myHist = histogram(probs, nbins=nbins)
	binmin = 0
	print, myHist / float(nprobs)
	help, myHist
	print, binmin
	binwidth = (max(probs) - binmin)/nbins
	print, max(probs)
	print, binwidth
	bins = findgen(nbins, increment=binwidth) + binwidth/2.0
	;bins = [binwidth/2.0:10*binwidth+binwidth/2.0:binwidth]

	print, myHist[0]/float(nprobs)
	p = barplot(bins, myHist/float(nprobs), XTITLE = "Likelihood", $
		YTITLE = "Probability")
	p.Save, name 


END

PRO plotcomp, cr0, cr4, nprobs
	N = 10
	i = 0
	probs = fltarr(nprobs)
	for i=0,nprobs-1 do begin
		sample, cr0, N, cr0_samp
		sample, cr4, N, cr4_samp
		kstwo, cr0_samp, cr4_samp, D, prob
		probs[i] = prob
	endfor
	print, "Probs:"
	help, probs
	print, probs

	nbins = 20

	myHist = histogram(probs, nbins=nbins)
	binmin = 0
	print, myHist / float(nprobs)
	help, myHist
	print, binmin
	binwidth = (max(probs) - binmin)/nbins
	print, max(probs)
	print, binwidth
	bins = findgen(nbins, increment=binwidth) + binwidth/2.0
	;bins = [binwidth/2.0:10*binwidth+binwidth/2.0:binwidth]
	plot, bins, myHist/float(nprobs), PSYM = 10
END

PRO saveplot
	x = FINDGEN(41)/10 - 2
	gauss = EXP(-x^2)
	p = BARPLOT(x, gauss, $
			TITLE='gaussian distriubtion', $
			YRANGE=[0,1.1])
	p.Save, "Gausssian.png", boarder=10, resolution=300, $
				/TRANSPARENT
	p1 = plot(x, gauss)
	p1.save, "gaussian2.png"
END

PRO plothist
	data = [[-5, 4, 2, -8, 1], $
				  [ 3, 0, 5, -5, 1], $
					[ 6, -7, 4, -4, -8], $
					[-1, -5, -14, 2, 1]]
	hist = HISTOGRAM(data)
	bins = FINDGEN(N_ELEMENTS(hist)) + MIN(data)
	PRINT, MIN(hist)
	PRINT, bins
	PLOT, bins, hist, YRANGE = [MIN(hist)-1, MAX(hist)+1], PSYM = 10, $
		XTITLE = "Bin Number", YTITLE = "Density per bin"
END

PRO main
	readin, cr09, cr0, cr4, cr3_4, karl

	nsamples = 1000

	supersample, cr09, nsamples, 10, cr09ss
	supersample, cr0, nsamples, 10, cr0ss
	supersample, karl, nsamples, 10, karlss
	supersample, cr4, nsamples, 10, cr4ss

	plotcomp2, cr0ss,  karlss, "cr0_karl.eps"
	plotcomp2, cr0ss,  cr4ss,  "cr0_cr4.eps"
	plotcomp2, cr0ss,  cr09ss, "cr0_cr09.eps"
	plotcomp2, cr09ss, cr4ss,  "cr09_cr4.eps"
	plotcomp2, cr09ss, karlss, "cr09_karl.eps"
	plotcomp2, cr4ss,  karlss, "cr4_karl.eps"
	
END
