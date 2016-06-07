print "\n \t ~~~~~~~ Project by Ruchir Patel: F002BZ1 ~~~~~~~ \n\n"
print "Enter a valid lisp defun: \n"
#lispfun="(defun revlist (y)(if (null (cdr y)) (car y) (list (revlist(cdr y)) (car y))))"
lispfun=gets()
print "\n\nlispfun entered: ", lispfun, "\n"
words = lispfun.split(/\W+/)
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
    j=extract(i+1, lispfun)

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


print "\n\n~~~~~~ A new file named 'ruby_is.rb' is created"
print " \n in the current directory which has translated \n entered lisp ----> ruby function ~~~~~~~\n\n"
