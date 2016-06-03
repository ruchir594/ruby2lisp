def dfs(y )
	 if nil == y 
 	 	 return nil 
 	 end 
 	 if y.length == 1 
 	 	 return y 
 	 end 
 	 if y.length > 1 
 	 	 return [dfs([y[0]])] + dfs([y[1..-1]]) 
 	 end 
 end
 