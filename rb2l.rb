print "Enter a valid lisp defun: \n"
#lispfun=gets()
#lispfun="(defun maxall (x)(if (null (cdr x)) (car x) (if (> (car x) (maxall (cdr x))) (car x) (maxall (cdr x)))))"
lispfun="(defun revlist (x)(if (null (cdr x)) (car x) (list (revlist(cdr x)) (car x))))"
print "lispfun", lispfun, "\n"
words = lispfun.split(/\W+/)
#print "words  ", lispfun.split(/\s([><\,\.\s\(\)]*)/), "\n"

aFile = File.new("ruby_is.rb", "w")
aFile.syswrite("def #{words[2]}")
i=0
count=0

require './rb2l_header.rb'
require './simhead.rb'

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

#writing in File
#write_words(write_block, aFile)
write_words(feel_block, aFile)

#print "words  ", lispfun.split(/\W([><+-^\*\,\.\s]*)/), "\n"

#print "\n",squash(["cdr", "abs"]),"\n"
#if ["maxalllll", "1","2"].class == [].class
#  print "111111111111\n"
#end
