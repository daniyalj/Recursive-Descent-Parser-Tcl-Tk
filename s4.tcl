#
#	David Iliaguiev, 210479830, davidili
#	Daniyal Javed, 212654570, cse31034
#	Alesya Orina, 212290987, cse23221
#
#
#	Implementation for a Recursive Descent Parser of the language of EBNF
#		Extended to interpret the language of EBNF and draw a diagram

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
   global group
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
   global group
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
   global group
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
   global group
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
   global group
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

proc drawW {} {
   set linew 100
   set olineh 100
   set clinew 10
   set rlinew 50
   set boxw 50
   set offset 15
   set boxh 30
   set ovalw 50
   set ovalh 30
   set xtexto 10
   set ytexto 7
   set xstart 100
   set ysf 100

   canvas .myCanvas -background white -width 1000 -height 500
   pack .myCanvas
   .myCanvas create line 100 100 200 100 -fill blue
   .myCanvas create line 200 100 210 100 -arrow last -fill black
   .myCanvas create rectangle 210 85 260 115 -outline black
   .myCanvas create line 260 100 270 100 -arrow last -fill black
   .myCanvas create line 270 100 370 100 -fill blue

   .myCanvas create text 230 90 -fill black -justify center -text "a" -font {Helvetica -10 bold}

   .myCanvas create line 270 100 270 200 -fill black
   .myCanvas create line 200 100 200 200 -fill black

   .myCanvas create line 200 200 210 200 -arrow last -fill black
   .myCanvas create rectangle 210 185 260 215 -outline black
   .myCanvas create line 260 200 270 200 -arrow last -fill black

   .myCanvas create text 230 200 -fill black -justify center -text "b" -font {Helvetica -10 bold}

   .myCanvas postscript -file diagram.ps
}

#  Main function
puts "Enter an EBNF rule to parse:"
#read one line of input
gets stdin userinput
#split input into tokens using whitespace as a delimeter
set tokens [split $userinput " "]
set count 0
set nextToken ""
set lexeme ""

while { $count < [llength $tokens] } {
   rule
}

drawW
