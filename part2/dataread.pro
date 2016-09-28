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

PRO plotcomp, ssample1, ssample2, name

	i = 0
	dim_info = size(ssample1)
	nprobs = dim_info[1]
	n_stars = dim_info[2]
	probs = fltarr(nprobs)
	for i=0,nprobs-1 do begin
		kstwo, ssample1[i,0:n_stars-1], ssample2[i,0:n_stars-1], D, prob
		probs[i] = prob
	endfor
	nbins = 20
	myHist = histogram(probs, binsize=0.05, MIN=0.0, MAX=0.95)

	bins = [0.025:1.0:0.05]

	print, "--------------------"
	print, name
	print, "Fraction of realisations with <5% likelihoods"
	print, myHist[0]/float(nprobs)
	print, "Fraction of realisations wiht <10% likelihoods"
	print, (myHist[0] + myHist[1])/float(nprobs)
	p = barplot(bins, myHist/float(nprobs), XTITLE = "Likelihood", $
		YTITLE = "Probability")
	p.Save, name 
END

PRO main
	readin, cr09, cr0, cr4, cr3_4, karl

	nsamples = 1000
	nstars = 100

	supersample, cr09, nsamples, nstars, cr09ss
	supersample, cr0,  nsamples, nstars, cr0ss
	supersample, karl, nsamples, nstars, karlss
	supersample, cr4,  nsamples, nstars, cr4ss

	plotcomp, cr0ss,  karlss, "cr0_karl_10.eps"
	;plotcomp, cr0ss,  cr4ss,  "cr0_cr4_10.eps"
	;plotcomp, cr0ss,  cr09ss, "cr0_cr09_10.eps"
	plotcomp, cr09ss, cr4ss,  "cr09_cr4_10.eps"
	;plotcomp, cr09ss, karlss, "cr09_karl_10.eps"
	;plotcomp, cr4ss,  karlss, "cr4_karl_10.eps"
	
END
