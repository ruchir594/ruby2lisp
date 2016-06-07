class String
    def is_i?
       /\A[-+]?\d+\z/ === self
    end
end
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
###############################################################################
def ind_cond(a)
  j = extract2(2,a)
  a1 = a[2, j[0]-3]
  a2 = a[j[0]..-2]
  return a1, a2
end
###############################################################################
def beautify(pars, wars)
  print "\n\t #{pars} \t #{wars}"
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
    return "#{pars[1]}[0]"
  end
  if pars[0] == "cdr"
    return "#{pars[1]}[1..-1]"
  end
  if pars[1] == "car"
    return "[#{pars[0]}([#{pars[2]}[0]])]"
  end
  if pars[1] == "cdr"
    return "#{pars[0]}(#{pars[2]}[1..-1])"
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
  i=0
  while i < wars.length
    if wars[i] == "+" || wars[i] == "*" || wars[i] == "-"
      condition_it = wars[i]
      print "\n\n~~~~~gotcha\n"
      i=i+2
      print wars[i].class
      if wars[i] == '('
        print "\n\n~~~~~gotcha2\n"
        j=extract2(i+1, wars)
        lhs=[i+1, j[0]-i+2]
        i=j[0]
        if wars[i] == '('
          j=extract2(i+1, wars)
          rhs=[i+1, j[0]-i+2]
        else
          rhs=wars[j[0]..-2]
        end
        print "\n````` #{lhs} 111111 #{rhs}``````\n"
        plhs = lhs.split(/\W([><+-^\*\,\.\s]*)/)
        plhs = plhs.reject { |c| c.empty? }
        plhs = plhs.reject { |c| c==" "}
        lhs = beautify(plhs, lhs)
        prhs = rhs.split(/\W([><+-^\*\,\.\s]*)/)
        prhs = prhs.reject { |c| c.empty? }
        prhs = prhs.reject { |c| c==" "}
        rhs = beautify(prhs, rhs)
        return "#{lhs} #{condition_it} #{rhs}"
      end
      if wars[i].is_i? == true
        print "\n\n~~~~~gotcha3\n"
        lhs=wars[i]
        i=i+1
        j=extract2(i+1,wars)
        rhs=wars[i+1, j[0]-i+2]
        i=j[0]
        print "\n````` #{lhs} 111111 #{rhs}``````\n"
        prhs = rhs.split(/\W([><+-^\*\,\.\s]*)/)
        prhs = prhs.reject { |c| c.empty? }
        prhs = prhs.reject { |c| c==" "}
        rhs = beautify(prhs, rhs)
        return "#{lhs} #{condition_it} #{rhs}"
      end

    end
    i=i+1
  end
  return pars[0]
end
###############################################################################
def simplify2(blk)
  pars = blk[0].split(/\W([><+-^\*\,\.\s]*)/)
  pars = pars.reject { |c| c.empty? }
  pars = pars.reject { |c| c==" "}
  #print "\n``````` #{pars} ``````\n"
  condition_it = "=="
  pars = beautify(pars, blk[0])

  qars = blk[1].split(/\W([><+-^\*\,\.\s]*)/)
  qars = qars.reject { |c| c.empty? }
  qars = qars.reject { |c| c==" "}
  #print "\n``````` #{qars} ``````\n"
  qars = beautify(qars, blk[1])

  return "\t if #{pars} \n \t \t return #{qars} \n \t end \n"
end
###############################################################################
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
  #print kk
  return kk, 3
end
