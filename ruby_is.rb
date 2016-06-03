def dfs(x )
	 if nil == x 
 	 	 return  nil 
 	 end 
 	 if x.length == 1 
 	 	 return  (cons x nil) 
 	 end 
 	 if x.length > 1 
 	 	 return  (nconc (dfs(car x)) (dfs(cdr x))) 
 	 end 
 end
 