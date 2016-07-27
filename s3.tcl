# A lexical analyzer with recursive descent parser system for EBNF grammar. 
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


proc lex {} {
   global nextToken
   global lexeme
   global tokens
   global count

   set lexeme [lindex $tokens $count]
   incr count
   puts -nonewline "Next lexeme is $lexeme . "

   if { [regexp -nocase {^[a-z]([a-z]|[0-9]|_)*} $lexeme] } {
      set nextToken "IDENTIFIER" 
   } elseif { [regexp -nocase {^\"([a-z]|[0-9])+\"$} $lexeme] || [regexp -nocase {^\'([a-z]|[0-9])+\'$} $lexeme] } {
      set nextToken "TERMINAL"
   } else {
      set nextToken [lookup $lexeme]
   }

   puts "Next token is $nextToken"
}

# rule -> lhs = rhs ;
proc rule {} {
   global nextToken
   puts "Enter rule"
   lhs
   lex
   if { $nextToken == "EQUALS_OP" } {
      rhs
      if { $nextToken == "END_OF_RULE" } {
         puts "Exit rule"
      } else {
         puts "Error: ; is expected in the end of rule. Terminating program."
         exit
      }
   } else {
      puts "Error: = is expected after lhs in rule. Terminating program."
      exit
   }
}

# lhs -> identifier
proc lhs {} {
   global nextToken
   puts "Enter lhs"
   lex
   if {$nextToken == "IDENTIFIER"} {
      puts "Exit lhs"
      return
   } else {
      puts "Error: identifier is expected in lhs. Terminating program."
      exit
   }
}


# rhs -> term | rhs
#      | term , rhs
#      | term
proc rhs {} {
   global nextToken
   puts "Enter rhs"
   term
   lex
   if {$nextToken == "ALTERNATE_OP" || $nextToken == "CONCATENATE_OP"} {
      rhs
      puts "Exit rhs"
      return
   }
   puts "Exit rhs"
}


# term -> identifier 
#       | terminal 
#       | [ rhs ] 
#       | ( rhs ) 
#       | { rhs }
proc term {} {
   global nextToken
   global count
   puts "Enter term"
   lex
   if {$nextToken == "IDENTIFIER"} {
      puts "Exit term"
      return
   }
   if {$nextToken == "TERMINAL"} {
      puts "Exit term"
      return
   }
   if {$nextToken == "LEFT_BRACKET"} {
      rhs
      if {$nextToken == "RIGHT_BRACKET"} {
         puts "Exit term"
         return
      }
   }
   if {$nextToken == "LEFT_BRACE"} {
      rhs
      if {$nextToken == "RIGHT_BRACE"} {
         puts "Exit term"
         return
      }
   }
   if {$nextToken == "LEFT_PAREN"} {
      rhs
      if {$nextToken == "RIGHT_PAREN"} {
         puts "Exit term"
         return
      }
   }
}


#  Main function
proc runs3 { userinput } {
   #split input into tokens using whitespace as a delimeter
   set tokens [split $userinput " "]
   set count 0
   set nextToken ""
   set lexeme ""

   while { $count < [llength $tokens] } {
      rule
   }
}
