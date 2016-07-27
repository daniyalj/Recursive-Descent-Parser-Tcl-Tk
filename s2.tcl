#
#	David Iliaguiev, 210479830, davidili
#	Daniyal Javed, 212654570, cse31034
#	Alesya Orina, 212290987, cse23221
#

# A lexical analyzer system for EBNF grammar. 
# It parses rules correctly if all tokens in the input are delimited by whitespace
# e.g. A = B [ R , C] ;

#Determine if a token is an operator and what its type is
proc lookup { ch } {
   if { $ch == "(" } {
        return "LEFT_PAREN"
   }
   if { $ch == ")" } {
        return "RIGHT_PAREN"
   }
   if { $ch == "\[" } {
        return "LEFT_BRACKET"
   }
   if { $ch == "\]" } {
        return "RIGHT_BRACKET"
   }
   if { $ch == "\{" } {
        return "LEFT_BRACE"
   }
   if { $ch == "\}" } {
        return "RIGHT_BRACE"
   }
   if { $ch == "|" } {
        return "ALTERNATE_OP"
   }
   if { $ch == "," } {
        return "CONCATENATE_OP"
   }
   if { $ch == "=" } {
        return "EQUALS_OP"
   }
   if { $ch == ";" } {
        return "END_OF_RULE"
   }
   return "ERROR"
}


#Main function
puts "Enter an EBNF rule to parse:"
#read one line of input
gets stdin userinput
#split input into tokens using whitespace as a delimeter
set tokens [split $userinput " "]
set count 0

while { $count < [llength $tokens] } {
   set lexeme [lindex $tokens $count]
   puts -nonewline "Next lexeme is $lexeme . "
   incr count

   if { [regexp -nocase {^[a-z]([a-z]|[0-9]|_)*$} $lexeme] } {
      set nextToken "IDENTIFIER" 
   } elseif { [regexp -nocase {^\"([a-z]|[0-9])+\"$} $lexeme] || [regexp -nocase {^\'([a-z]|[0-9])+\'$} $lexeme] } {
      set nextToken "TERMINAL"
   } else {
      set nextToken [lookup $lexeme]
   }

   puts "Next token is $nextToken"
}
