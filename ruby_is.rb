def rlen(x )
	 if nil == x 
 	 	 return 0 
 	 end 
 	 if x.length == 1 
 	 	 return 0 
 	 end 
 	 if x.length > 1 
 	 	 return 1 + rlen(x[1..-1]) 
 	 end 
 end
 