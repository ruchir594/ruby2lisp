def revlist(x )
if nil == x[1] 
 	 ["car", "x"] 
 else 
 	 ["list", "revlist x[1]", "x[0]"] 
 end 
 