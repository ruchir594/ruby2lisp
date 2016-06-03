#using all_blocks
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

def squash(a)
  if a.class == [].class && a.length() > 2
    print "\n Too big to squash directly \n"
    return "#{a[0]} " + squash(a[1..-1])
  end
  if a[0] == "cdr"
    return "#{a[1]}[1]"
  end
  if a[0] == "car"
    return "#{a[1]}[0]"
  end
  if a == "null"
    return "nil"
  end
  return a
end

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
      pas = squash(pas)
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
      pas = squash(bb[0][count])
      opr.push(pas)
      i=i+bb[0][count].length
      count=count+1
    end
    #print "\n printing opr #{i} \t"
    #print opr
  end

  return opr
end

def get_if_blk(build_blocks, all_blocks)
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
    if condition_lh_len + condition_rh_len + return_if_bl.length() == block_len-1
      #lack of else block
      if return_if_bl[0] == "if"
        return_if_bl=get_if_blk(build_blocks[opr_if..-1], all_blocks[opr_if..-1])
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      return_if_bl = simplify(return_if_bl, all_blocks[opr_if])
      return "if #{condition_lh} #{condition_it} #{condition_rh} \n \t #{return_if_bl} \n end \n", 1
    else
      #else block is present
      if return_if_bl[0] == "if"
        return_if_bl = get_if_blk(build_blocks[opr_if..-1], all_blocks[opr_if..-1])
      end
      if return_else_bl[0] == "if"
        return_else_bl = get_if_blk(build_blocks[opr_else..-1], all_blocks[opr_else..-1])
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      return_if_bl = simplify(return_if_bl, all_blocks[opr_if])
      return_else_bl = simplify(return_else_bl, all_blocks[opr_else])
      return "if #{condition_lh} #{condition_it} #{condition_rh} \n \t #{return_if_bl} \n else \n \t #{return_else_bl} \n end \n", 1
    end
end

def consume(build_blocks, all_blocks)
  print "\n in consume \n"
  krieg=[]
  i=0
  while i<build_blocks.length
    count=1
    if build_blocks[i][0] == "if"
      kk, count = get_if_blk(build_blocks, all_blocks)
      #print "\n #{kk} \n #{count}"
      krieg.push(kk)
    end
    i=i+count
  end
  return krieg
end
