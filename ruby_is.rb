def revlist_f(y )
if nil == y[0] 
 	 return y[1..-1] 
 else 
 	 revlist_f(y[0]) + y[1..-1] 
 end 
 end
 