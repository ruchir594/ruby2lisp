def maxall(x )
if [] == x[1..-1] 
 	 return x[0] 
 else 
 	 if x[0] >  maxall(x[1..-1]) 
 	 return x[0] 
 else 
 	 maxall(x[1..-1]) 
 end 
 
 end 
 end
 