###############################################################################
###############################################################################
# This file has function which will translate a "(cond ())" block of lisp
# into the respective ruby code with if - else ladder
###############################################################################
# Extract2 function essentiialy helps get the words between two brackets '('  ')'
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
###############################################################################
# This function helps get all the various conditions in the "(cond ())" block
# try printing #{gg} and feel the difference
def get_all_cond(bb, ab)
  i=1
  a=[]
  while i<ab[0].length
    if ab[0][i] == '('
      j=extract2(i+1, ab[0])
      gg = ab[0][i,j[0]-i]
      i=j[0]
      print "\n```` #{gg} `````\n"
      a.push(gg)
    end
    i=i+1
  end
  return a
end
###############################################################################
def ind_cond(a)
  j = extract2(2,a)
  a1 = a[2, j[0]-3]
  a2 = a[j[0]..-2]
  return a1, a2
end
###############################################################################
# beautiful takes small brackets in lisp which deals with cons cells like car, cdr, nconc,
# and converts them in respective ruby code.
# car of a list a, would be the same as taking first element a[0]
# cdr of a list a, would be the same as taking all but first element a[1..-1]
def beautify(pars, wars)
  #print "\n\t #{pars} \t #{wars}"
  if pars[0] == "null"
    return "nil == #{pars[1]}"
  end
  if pars[0] == "atom"
    return "#{pars[1]}.length == 1"
  end
  if pars[0] == "consp"
    return "#{pars[1]}.length > 1"
  end
  if pars[0] == "cons"
    return "#{pars[1]}"
  end
  if pars[0] == "car"
    # car of a list a, would be the same as taking first element a[0]
    return "#{pars[1]}[0]"
  end
  if pars[0] == "cdr"
    # cdr of a list a, would be the same as taking all but first element a[1..-1]
    return "#{pars[1]}[1..-1]"
  end
  if pars[1] == "car"
    return "[#{pars[0]}([#{pars[2]}[0]])]"
  end
  if pars[1] == "cdr"
    return "#{pars[0]}([#{pars[2]}[1..-1]])"
  end
  if pars[0] == "nconc"
    j=extract2(9, wars)
    lhs = wars[9,j[0]-10]
    rhs = wars[j[0]..-2]
    print "\n````` #{lhs} 111111 #{rhs}``````\n"
    plhs = lhs.split(/\W([><+-^\*\,\.\s]*)/)
    plhs = plhs.reject { |c| c.empty? }
    plhs = plhs.reject { |c| c==" "}
    prhs = rhs.split(/\W([><+-^\*\,\.\s]*)/)
    prhs = prhs.reject { |c| c.empty? }
    prhs = prhs.reject { |c| c==" "}
    lhs = beautify(plhs, lhs)
    rhs = beautify(prhs, rhs)
    return "#{lhs} + #{rhs}"
  end
  return pars[0]
end
###############################################################################
def simplify2(blk)
  pars = blk[0].split(/\W([><+-^\*\,\.\s]*)/)
  pars = pars.reject { |c| c.empty? }
  pars = pars.reject { |c| c==" "}
  print "\n``````` #{pars} ``````\n"
  condition_it = "=="
  pars = beautify(pars, blk[0])

  qars = blk[1].split(/\W([><+-^\*\,\.\s]*)/)
  qars = qars.reject { |c| c.empty? }
  qars = qars.reject { |c| c==" "}
  print "\n``````` #{qars} ``````\n"
  qars = beautify(qars, blk[1])

  return "\t if #{pars} \n \t \t return #{qars} \n \t end \n"
end
###############################################################################
# this is like mothercall which takes the string of lisp defun and makes calls
# to various finctions which will parse the defun
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
