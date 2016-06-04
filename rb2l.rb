print "\n \t ~~~~~~~ Project by Ruchir Patel: F002BZ1 ~~~~~~~ \n\n"
print "Enter a valid lisp defun: \n"
lispfun=gets()
#lispfun="(defun maxall (x)(if (null (cdr x)) (car x) (if (> (car x) (maxall (cdr x))) (car x) (maxall (cdr x)))))"
#lispfun="(defun revlist (x)(if (null (cdr x)) (car x) (list (revlist(cdr x)) (car x))))"
#lispfun="(defun dfs (y) (cond ((null y) nil);((atom y) (cons y nil));((consp y) (nconc (dfs(car y)) (dfs(cdr y))))))"
#lispfun="(define fun_name (x1, y2, z3)(if (null (car x1)) (cdr z3)))"
#lispfun="(defun rlen (x)(cond ((null x) 0);((atom x) 0);((consp x) (+ 1 (rlen (cdr x)))))))"
#lispfun="(define fun_name ())"
print "\n\nlispfun entered: ", lispfun, "\n"
words = lispfun.split(/\W+/)
#print "words  ", lispfun.split(/\s([><\,\.\s\(\)]*)/), "\n"
require './rb2l_header.rb'
require './simhead.rb'
flag=false
flag=check_validity(lispfun)
if flag == false
  print "\n\n ~~~~~ Invalid function. Please try again ~~ \n\n"
  return
end

aFile = File.new("ruby_is.rb", "w")
aFile.syswrite("def #{words[2]}")
i=0
count=0

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
    parameters = lispfun[i,j-i+1].split(/\W([><+-^\*\,\.\s]*)/)
    parameters = parameters.reject { |c| c.empty? }
    parameters = parameters.reject { |c| c==" "}
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
build_blocks = superloop(i, lispfun)
all_blocks = hyperloop(i, lispfun)

#Now, what I call, building blocks are stored in array
#write_block=convert(build_blocks)
feel_block=consume(build_blocks, all_blocks)

#print "\n ```````````` \n"
#print build_blocks[4..-1]
#print all_blocks[4]
#print simplify(build_blocks[4..-1], all_blocks[4])
#writing in File
#write_words(write_block, aFile)
write_words(feel_block, aFile)

#print "words  ", lispfun.split(/\W([><+-^\*\,\.\s]*)/), "\n"

#print "\n",squash(["cdr", "abs"]),"\n"
#if ["maxalllll", "1","2"].class == [].class
#  print "111111111111\n"
#end

print "\n\n~~~~~~ A new file named 'ruby_is.rb' is created"
print " \n in the current directory which has translated \n entered lisp ----> ruby function ~~~~~~~\n\n"
