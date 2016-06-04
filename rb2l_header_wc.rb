def check_validity(a)
  i=0
  cnt=0
  while i < a.length
    if a[i] == '('
      cnt=cnt+1
    end
    if a[i] == ')'
      cnt=cnt-1
    end
    i=i+1
  end
  if cnt != 0
    return false
  end
  return true
end
###############################################################################



def extract(i, lispfun)
  j=i
  count=1
  #print lispfun[j]
  while count != 0 do
    #print lispfun[j], " ", count, "\n"
    if lispfun[j] == '('
      count=count+1
    end
    if lispfun[j] == ')'
      count=count-1
    end
    j=j+1
  end
  return j
end
###############################################################################
def write_words(parameters, aFile)
  i=0
  while i < parameters.length() do
    aFile.syswrite(parameters[i])
    aFile.syswrite(" ")
    i=i+1
  end
end
###############################################################################
# superlook will actuallt take the the string but give out words to help parse
# and convert defun into ruby function
def superloop(i, lispfun)
  a=[]
  while i < lispfun.length() do
    if lispfun[i] == '('
      j=extract(i+1,lispfun)
      parameters = lispfun[i,j-i+1].split(/\W([><+-^\*\,\.\s]*)/)
      parameters = parameters.reject { |c| c.empty? }
      parameters = parameters.reject { |c| c==" "}
      # observe the output paramerts as follows to see what I exactly mean
      print "\n","parameters 1 ",parameters
      a.push(parameters)
    end
    i=i+1
  end
  #print "\n"
  #print a
  #print "\n"
  return a
end
# this actually return the an array with array at the indices which has words
# of defun. Please observe the parameter output
###############################################################################
# basically, hyperlook will take the full defun string and give another string
# between two brackets. this will help build and parse the ruby function.
def hyperloop(i, lispfun)
  a=[]
  while i < lispfun.length() do
    if lispfun[i] == '('
      j=extract(i+1,lispfun)
      parameters = lispfun[i,j-i]
      # observe the output paramerts as follows to see what I exactly mean
      print "\n","parameters 2 ",parameters
      a.push(parameters)
    end
    i=i+1
  end
  #print "\n"
  #print a
  #print "\n"
  return a
end
# but the hyperloop, unlike superloop returns the string betweek the two brackets '('  ')'
###############################################################################
def squash(a)
  if a.class == [].class && a.length() > 2
    #print "\n Too big to squash \n"
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
###############################################################################
# this function is actually older verison of the function
# get_if_blk in the file "simhead_wc"
# please look at the comments of that fucntion
# I no longer use this function in my code, instead, i call get_if_blk
# which does more or less the same thing, only better.
def get_if_block(build_blocks)
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

    #print "`````````\n",condition_lh,"\n````````````"
    #print "`````````\n",condition_rh,"\n````````````"
    return_if_bl = build_blocks[opr_if]
    return_else_bl = build_blocks[opr_else]
    print condition_lh_len + condition_rh_len + return_if_bl.length(), "!!!!!!!", block_len,"!!!!!!!!!"
    if condition_lh_len + condition_rh_len + return_if_bl.length() == block_len-1
      #lack of else block
      print "`````````\n","yaaayyyyyyy","\n````````````"
      print "`````````\n","yaayyyy","\n````````````"
      if return_if_bl[0] == "if"
        return_if_bl=get_if_block(build_blocks[opr_if..-1])
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      return_if_bl = squash(return_if_bl)
      return "if #{condition_lh} #{condition_it} #{condition_rh} \n \t #{return_if_bl} \n end \n"
    else
      #else block is present
      print "`````````\n","naaayyyyyyy","\n````````````"
      print "`````````\n","naayyyy","\n````````````"
      if return_if_bl[0] == "if"
        return_if_bl = get_if_block(build_blocks[opr_if..-1])
      end
      if return_else_bl[0] == "if"
        print "`````````\n",return_else_bl,"\n````````````"
        return_else_bl = get_if_block(build_blocks[opr_else..-1])
      end
      condition_lh = squash(condition_lh)
      condition_rh = squash(condition_rh)
      return_if_bl = squash(return_if_bl)
      return_else_bl = squash(return_else_bl)
      return "if #{condition_lh} #{condition_it} #{condition_rh} \n \t #{return_if_bl} \n else \n \t #{return_else_bl} \n end \n"
    end
end
###############################################################################
def convert(build_blocks)
  write_block=[]
  i=0
  #while i<build_blocks.length() do
    if build_blocks[i][0] == "if"
      write_block.push(get_if_block(build_blocks))
      i=i+1
    end
  #  i=i+1
  #end
  return write_block
end
