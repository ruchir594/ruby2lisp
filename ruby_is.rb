def revlist(x )
if nil == x[1] 
 	 x[0] 
 else 
 	 list revlist cdr x x[0] 
 end 
 