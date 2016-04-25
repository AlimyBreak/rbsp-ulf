;+
;FUNCTION; get_bkg3d,dat
;PURPOSE:  Uses energy steps defined by esteps array,  computes average 
;  count rate in those steps and then copies that average value into all
;  data values.  Each angle bin is treated separately.  The result can be
;  used for background subtraction.
;
;INPUT:  
;	dat:	3d data structure such as is generated by 
;		"get_el" and other get routines
;KEYWORDS
;	ESTEPS:	Two element array of integers that corresponds to the first
;           and last energy steps to be used.  (default is [0,3])
;
;CREATED BY:	Davin Larson
;LAST MODIFICATION:	@(#)get_bkg3d.pro	1.9 02/04/17
;
;WARNING!  This is a crude subroutine. Use at your own risk.
;-



function  get_bkg3d, dat, $
    esteps=esteps, $
    fudge = fudge,  $
    bins = bins, $
    average=average

if n_elements(esteps) eq 0 then esteps = [0,3]

e1 = esteps(0)
e2 = esteps(1)
nbins = dat.nbins
nenergy = dat.nenergy

bdat = dat

nbkg = total( finite(dat.data(e1:e2,*)) ,1)
bkg = total( dat.data(e1:e2,*),1 , /nan) / nbkg 
sbkg = sqrt(bkg) / nbkg

if keyword_set(average) then begin
  theta= reform(bdat.theta(0,*))
  anode =  fix((90.-theta)/180.*8.)

  for a=0,7 do begin
    w = where(anode eq a and bins,count)
    print,float(w)
    print,bkg(w)
    print,sqrt(bkg(w))
    nel = total( finite( bkg(w) ) )
    tot = total(bkg(w), /nan)
    sig = sqrt(tot)
    bkg(w) = tot/nel
    sbkg(w) = sig/nel
    print,tot/nel
    print,sig/nel
    print,''
  endfor
endif

bdat.data =  replicate(1.,nenergy) # bkg
str_element,/add,bdat,'ddata',replicate(1.,nenergy) # sbkg

return,bdat
end


   