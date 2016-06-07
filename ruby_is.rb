def revlist(y )
if nil == y[1..-1] 
 	 return y[0] 
 else 
 	 [revlist(y[1..-1])].concat([y[0]]) 
 end 
 end
 