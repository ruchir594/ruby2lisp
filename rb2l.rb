print "Enter a valid lisp defun: \n"
#lispfun=gets()
lispfun="(defun maxall (x)(if (null (cdr x)) (car x)(if (> (car x) (maxall (cdr x))) (car x) (maxall (cdr x)))))"
print "lispfun", lispfun, "\n"
words = lispfun.split(/\W+/)
#print "words  ", lispfun.split(/\W+/), "\n"

aFile = File.new("ruby_is.rb", "w")
aFile.syswrite("def #{words[2]}")
i=0
count=0

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

def write_words(parameters, aFile)
  i=0
  while i < parameters.length() do
    aFile.syswrite(parameters[i])
    aFile.syswrite(" ")
    i=i+1
  end
end

def superloop(i, lispfun)
  a=[]
  while i < lispfun.length() do
    if lispfun[i] == '('
      j=extract(i+1,lispfun)
      parameters = lispfun[i,j-i+1].split(/\W+/)
      print "\n","parameters",parameters[1..-1]
      a.push(parameters[1..-1])
    end
    i=i+1
  end
  print "\n"
  print a
  print "\n"
  return a
end

def squash(a)
  if a.class == "Array" && a.length>2
    print "\n Too big to squash \n"
    return a
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
end

def get_if_block(build_blocks)
  condition_len=build_blocks[0].length()
  #print "`````````\n",condition_len,"\n````````````"
  condition_check=build_blocks[1].length()
  if condition_len - condition_check == 1
    condition_lh = build_blocks[0][0]
    condition_rh = build_blocks[1]
    opr_if=2
    opr_else=3
  else
    condition_lh = build_blocks[1]
    condition_rh = build_blocks[2]
    opr_if=3
    opr_else=4
  end
  print "`````````\n",condition_lh,"\n````````````"
  print "`````````\n",condition_rh,"\n````````````"
  return_if_len = build_blocks[opr_if]
  return_else_len = build_blocks[opr_else]
  if return_else_len<return_if_len
end

def convert(build_blocks)
  write_block=[]
  i=0
  #while i<build_blocks.length() do
    if build_blocks[i][0] == "if"
      write_block.push(get_if_block(build_blocks[1..-1]))
      i=i+1
    end
  #  i=i+1
  #end
  return write_block
end

#Putting down parameters into the function name is what this while loop is for.

while i < lispfun.length() do
  if lispfun[i]=='('
    count=count+1
  end
  if count == 2
    #i=i+1
    j=extract(i+1, lispfun)
    #i=j
    #print i, " ", j, "\n"
    #print lispfun[14], lispfun[15], lispfun[16], "\n"
    #print lispfun[i,j-i+1], "\n"
    parameters = lispfun[i,j-i+1].split(/\W+/)
    #print parameters, "\n"
    aFile.syswrite("(")
    write_words(parameters, aFile)
    aFile.syswrite(")\n")
    count=0
    i=j
    break
  end
  i=i+1
end
print i

#it is time for writing body
build_blocks=superloop(i, lispfun)

#Now, what I call, building blocks are stored in array
write_block=convert(build_blocks)

#writing in File
write_words(write_block, aFile)
