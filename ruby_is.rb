def dfs(x )
	 if null == x 
 	 	 return  nil 
 	 end 
 	 if atom == x 
 	 	 return  (cons x nil) 
 	 end 
 	 if consp == x 
 	 	 return  (nconc (dfs(car x)) (dfs(cdr x))) 
 	 end 
 end
 