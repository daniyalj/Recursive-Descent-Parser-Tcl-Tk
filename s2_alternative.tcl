#A lexical analyzer system


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


puts "Enter file name e.g. file.txt"
gets stdin filename

set fp [open $filename r]

   set count 0
   set file_data [read $fp]
   set tokens [split $file_data " "]

   while { $count < [llength $tokens] } {
      set lexeme [lindex $tokens $count]
      incr count

      if { [regexp {^[a_zA-Z]([a_zA-Z]|[0-9]|_)*} $lexeme] } {
         set nextToken "IDENTIFIER" 
      } elseif { [regexp {^\"([a-zA-Z]|[0-9]|_)+\"$} $lexeme] || [regexp {^\'([a-zA-Z]|[0-9]|_)+\'$} $lexeme] } {
         set nextToken "TERMINAL"
      } else {
         set nextToken [lookup $lexeme]
      }

      puts -nonewline "Next token is $nextToken. "
      puts "Next lexeme is $lexeme."
   }

close $fp
