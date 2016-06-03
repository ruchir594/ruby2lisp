def maxall(x )
if nil == x[1] 
 	 x[0] 
 else 
 	 if x[0] >  maxall x[1] 
 	 x[0] 
 else 
 	 ["maxall", "x[1]"] 
 end 
 
 end 
 