require 'open3'

module Bio
  class ExportPred
    class Wrapper
      def calculate(sequence)
        command = 'exportpred --input=-'
        Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
          stdin.puts '>wrapperSeq'
          stdin.puts "#{sequence}"
          stdin.close
          
          result = stdout.readlines
          error = stderr.readlines
          
          unless error.length == 1
            raise Exception, "There appears to be a problem while running ExportPred:\n#{error}"
          end
          parse_error = error[0].strip.match(/^(\d+) sequences read from stdin$/)
          unless parse_error[1].to_i == 1
            raise Exception, "There appears to be a problem while running ExportPred, unexpected output form: \n#{error}"
          end
          
          # Error checking
          unless [0,1].include?(result.length)
            raise Exception, "Unexpected number of lines found in ExportPred output (#{result.length}:\n#{result}"
          end
          
          return Result.create_from_line(result[0])
        end
      end
    end
    
    class Result
      @@all_result_names = [
        :predicted,
        :score
      ]
      @@all_result_names.each do |rn|
        attr_accessor rn
      end
     
      # Given the STDOUT from the ExportPred program, create a programmatically manipulatable Bio::ExportPred::Result object
      def self.create_from_line(line)
        result = Result.new
        if !line or line == '' #possible bug that scores below 2.3 don't work?
          result.predicted = false
          return result
        end
        
        # line is going to be something like
        # metoo	RLE	6.44141	[a-met:M][a-leader:AVSTYNNTRRNGLRYVLKRR][a-hydrophobic:TILSVFAVICMLSL][a-spacer:NLSIFENNNNNYGFHCNKRH][a-RLE:FKSLAEA][a-tail:SPEEHNNLRSHSTSDPKKNEEKSLSDEINKCDMKKYTAEEINEMINSSNEFINRNDMNIIFSYVHESEREKFKKVEENIFKFIQSIVETYKIPDEYKMRKFKFAHFEMQGYALKQEKFLLEYAFLSLNGKLCERKKFKEVLEYVKREWIEFRKSMFDVWKEKLASEFREHGEMLNQKRKLKQHELDRRAQREKMLEEHSRGIFAKGYLGEVESETIKKKTEHHENVNEDNVEKPKLQQHKVQPPKVQQQKVQPPKSQQQKVQPPKSQQQKVQPPKVQQQKVQPPKVQKPKLQNQKGQKQVSPKAKGNNQAKPTKGNKLKKN]
        splits = line.split("\t")
        raise Exception, "Badly parsed line: #{line}" if splits.length != 4
        result.predicted = true
        result.score = splits[2].to_f
        return result
      end
      
      def predicted?
        @predicted
      end
      alias_method :signal?, :predicted?
      
      def self.all_result_names
        @@all_result_names
      end
    end
  end
end