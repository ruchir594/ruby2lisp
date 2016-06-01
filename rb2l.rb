print "Enter a valid lisp defun: \n"
#lispfun=gets()
lispfun="(defun maxall (x y z)(if (null (cdr x)) (car x)(if (> (car x) (maxall (cdr x))) (car x) (maxall (cdr x)))))"
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
    #print lispfun[j]
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
  while i < lispfun.length() do
    if lispfun[i] == '('
      j=extract(i,lispfun)
      parameters = lispfun[i,j-i+1].split(/\W+/)
      print "\n","parameters",parameters
    end
    i=i+1
  end
end

#Putting down parameters into the function name is what this while loop is for.

while i < lispfun.length() do
  if lispfun[i]=='('
    count=count+1
  end
  if count == 2
    i=i+1
    j=extract(i, lispfun)
    #i=j
    #print i, " ", j, "\n"
    #print lispfun[14], lispfun[15], lispfun[16], "\n"
    #print lispfun[i,j-i+1], "\n"
    parameters = lispfun[i,j-i+1].split(/\W+/)
    #print parameters, "\n"
    aFile.syswrite("(")
    write_words(parameters, aFile)
    aFile.syswrite(")")
    count=0
    i=j
    break
  end
  i=i+1
end
print i

#it is time for writing body
superloop(i, lispfun)
