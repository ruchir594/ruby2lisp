#using all_blocks
require './condhead.rb'
###############################################################################
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
def squash(a)
  if a.class == [].class && a.length() > 2
    print "\n Too big to squash directly \n"
    return "#{a[0]} " + "#{squash(a[1..-1])}"
  end
  if a[0] == "cdr"
    return "#{a[1]}[1..-1]"
  end
  if a[0] == "car"
    return "#{a[1]}[0]"
  end
  if a == "null"
    return "nil"
  end
  return a
end
###############################################################################
def squash2(a)
  print "\n``````````` #{a} `````````\n"
  if a[0] == "car"
    return "#{a[1]}[0]"
  end
  if a[0] == "cdr"
    return "#{a[1]}[1..-1]"
  end
  if a[1] == "cdr"
    return "#{a[0]}(#{a[2]}[1..-1])"
  end
  if a[1] == "car"
    return "#{a[0]}(#{a[2]}[0])"
  end
  if a[0] == "list"
    a=a[1..-1]
    i=0
    gg=""
    while i < a.length
      g = squash2(a[i])
      gg="#{gg} + #{g}"
      i=i+1
    end
    gg=gg[3..-1]
    return gg
  end
  return "#{a[0]} #{a[1]}"
end
###############################################################################
def l_of(a)
  i=0
  b=0
  while i < a.length
    b=b+a[i].length
    i=i+1
    #print "\n \t b #{b}"
  end
  return b
end
###############################################################################
def simplify(bb, ab)
  i=1
  opr=[]
  count=0
  ptr=1
  iend=ab.length()
  while i < iend
    #print "\n #{i} \t #{ab[i]}"
    if ab[i] == '('
      j = extract2(i+1, ab)
      gg = ab[i,j[0]-i]
      #print "\n gg \t #{gg}"
      pas = gg.split(/\W([><+-^\*\,\.\s]*)/)
      pas = pas.reject { |c| c.empty? }
      pas = pas.reject { |c| c==" "}
      #pas = squash(pas)
      opr.push(pas)
      i=j[0]
      count=count+pas.length
      ptr=ptr + j[1]
    elsif ab[i] == ' '
      i=i+1
      next
    elsif ab[i] == ')'
      i=i+1
      next
    else
      #pas = squash(bb[0][count])
      pas=bb[0][count]
      opr.push(pas)
      i=i+bb[0][count].length
      count=count+1
    end
    #print "\n printing opr #{i} \t"
    #print opr
  end
  opr=squash2(opr)
  return opr
end

###############################################################################
def get_if_blk(build_blocks, all_blocks)
  cc=0
  block_len=build_blocks[0].length()
  condition_len=build_blocks[1].length()
  #print "`````````\n",condition_len,"\n````````````"
  condition_check=build_blocks[2].length()
  if build_blocks[1][0] != "* " && build_blocks[1][0] != "> "
    condition_it="=="
    lag=0
  else
    condition_it = build_blocks[1][0]
    lag=1
  end
    if condition_len - condition_check == 1+lag
      condition_lh = build_blocks[1][0+lag]
      condition_lh_len=1
      condition_rh = build_blocks[2]
      condition_rh_len=condition_rh.length()
      opr_if=3+condition_rh_len-2
      opr_else=4+condition_rh_len-2
    else
      condition_lh = build_blocks[2]
      condition_lh_len=condition_lh.length()
      condition_rh = build_blocks[3]
      condition_rh_len=condition_rh.length()
      opr_if=4+condition_rh_len-2
      opr_else=5+condition_rh_len-2
    end

    return_if_bl = build_blocks[opr_if..-1]
    return_else_bl = build_blocks[opr_else..-1]
    #print "\n\t~~",condition_lh_len , condition_rh_len , return_if_bl.length(), "~~", block_len, "\n"
    if condition_lh_len + condition_rh_len + return_if_bl[0].length() == block_len-1
      #lack of else block
      if return_if_bl[0][0] == "if"
        return_if_bl=get_if_blk(build_blocks[opr_if..-1], all_blocks[opr_if..-1])
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      return_if_bl = simplify(return_if_bl, all_blocks[opr_if])
      #print "if #{condition_lh} #{condition_it} #{condition_rh} \n \t #{return_if_bl} \n end \n"
      cc = cc + opr_if + 1
      return "if #{condition_lh} #{condition_it} #{condition_rh} \n \t return #{return_if_bl} \n end \n", cc
    else
      #else block is present
      flag_if_crunch=false
      if return_if_bl[0][0] == "if"
        return_if_bl = get_if_blk(build_blocks[opr_if..-1], all_blocks[opr_if..-1])
        return_if_bl=return_if_bl[0]
        flag_if_crunch=true
      end
      flag_else_crunch=false
      if return_else_bl[0][0] == "if"
        return_else_bl = get_if_blk(build_blocks[opr_else..-1], all_blocks[opr_else..-1])
        cc = cc + return_else_bl[1]
        return_else_bl=return_else_bl[0]
        flag_else_crunch=true
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      if flag_if_crunch == false
        return_if_bl = simplify(return_if_bl, all_blocks[opr_if])
      else
        return_if_bl = squash(return_if_bl)
      end
      if flag_else_crunch == false
        return_else_bl = simplify(return_else_bl, all_blocks[opr_else])
      else
        return_else_bl = squash(return_else_bl)
      end
      cc = cc + opr_else + 1
      return "if #{condition_lh} #{condition_it} #{condition_rh} \n \t return #{return_if_bl} \n else \n \t #{return_else_bl} \n end \n", cc
    end
end



###############################################################################
def consume(build_blocks, all_blocks)
  print "\n in consume \n"
  krieg=[]
  i=0
  kk=[]
  #flag=false
  while i<build_blocks.length
    kk[1]=1
    if build_blocks[i][0] == "if"
      kk = get_if_blk(build_blocks, all_blocks)
      #print "\n #{kk} \n #{count}"
      krieg.push(kk[0])

    end
    if build_blocks[i][0] == "cond"
      print "\n in the cond block"
      kk = get_cond_block(build_blocks, all_blocks)
      krieg.concat kk[0]
      #krieg.push("end\n")
    end
    i=i+kk[1]
  end
  krieg.push("end\n")
  return krieg
end
