def extract2(i, lispfun)
  j=i
  count=1
  cmax=1
  #print lispfun[j]
  while count != 0 do
    #print lispfun[j], " ", count, "\n"
    if lispfun[j] == '('
      count=count+1
    end
    if count>cmax
      cmax=count
    end
    if lispfun[j] == ')'
      count=count-1
    end
    j=j+1
  end
  return j, cmax
end

def get_all_cond(bb, ab)
  i=1
  a=[]
  while i<ab[0].length
    if ab[0][i] == '('
      j=extract2(i+1, ab[0])
      gg = ab[0][i,j[0]-i]
      i=j[0]
      #print "\n```` #{gg} `````\n"
      a.push(gg)
    end
    i=i+1
  end
  return a
end

def ind_cond(a)
  j = extract2(2,a)
  a1 = a[2, j[0]-3]
  a2 = a[j[0]..-2]
  return a1, a2
end

def beautify(pars)
  if pars[0] == "null"
    return "nil == #{pars[1]}"
  end
  if pars[0] == "atom"
    return "#{pars[1]}.length == 1"
  end
  if pars[0] == "consp"
    return "#{pars[1]}.length > 1"
  end
end

def simplify2(blk)
  pars = blk[0].split(/\W([><+-^\*\,\.\s]*)/)
  pars = pars.reject { |c| c.empty? }
  pars = pars.reject { |c| c==" "}
  #print "\n``````` #{pars} ``````\n"
  condition_it = "=="
  pars = beautify(pars)
  return "\t if #{pars} \n \t \t return #{blk[1]} \n \t end \n"
end

def get_cond_block(bb, ab)
  gg = get_all_cond(bb, ab)
  #print gg, "\n"
  i=0
  kk=[]
  while i < gg.length
    blk = ind_cond (gg[i])
    #print "\n`````` #{blk} `````\n"
    plk = simplify2 (blk)
    i=i+1
    kk.push(plk)
  end
  print kk
  return kk, 3
end
