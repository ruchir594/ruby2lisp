#using all_blocks

def squash(a)
  if a.class == [].class && a.length() > 2
    print "\n Too big to squash \n"
    return "#{a[0]} " + squash(a[1..-1])
  end
  if a[0] == "cdr"
    return "#{a[1]}[1]"
    ######################### Following is the reason why
    ######## (cdr x) will be x[1] and not x[1..-1]
    ################################      ########
          #$ irb
      #2.1.2 :001 > x=[]
      # => []
      #2.1.2 :002 > x.class
      # => Array
      #2.1.2 :003 > x.push(1)
      # => [1]
      #2.1.2 :004 > x
      # => [1]
      #2.1.2 :005 > x[0]
      # => 1
      #2.1.2 :006 > x[1]
      # => nil
      #2.1.2 :007 > x[1..-1]
      # => []
      #2.1.2 :008 > if x[1..-1] == nil
      #2.1.2 :009?>   print "lol"
      #2.1.2 :010?>   end
      # => nil
      #2.1.2 :011 > if x[1] == nil
      #2.1.2 :012?>   print "lol"
      #2.1.2 :013?>   end
      #lol => nil
      #2.1.2 :014 >
  end
  if a[0] == "car"
    return "#{a[1]}[0]"
  end
  if a == "null"
    return "nil"
  end
  return a
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

    return_if_bl = build_blocks[opr_if]
    return_else_bl = build_blocks[opr_else]
    if condition_lh_len + condition_rh_len + return_if_bl.length() == block_len-1
      #lack of else block
      if return_if_bl[0] == "if"
        return_if_bl=get_if_blk(build_blocks[opr_if..-1], all_blocks[opr_if..-1])
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      return_if_bl = squash(return_if_bl)
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
      return_if_bl = squash(return_if_bl)
      return_else_bl = squash(return_else_bl)
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
