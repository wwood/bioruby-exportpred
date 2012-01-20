require 'open3'

module Bio
  class ExportPred
    class Wrapper
      # Use ExportPred called locally to predict whether a protein is exported or
      # not.
      # TODO: better doco here, explain options
      def calculate(sequence, options={})
        command = 'exportpred --input=-'
        #--no-RLE and -r seem to fail when running exportpred on the command line, so here I'll just set the thresholds very high instead
        command = "#{command} --KLD-threshold=99999" if options[:no_KLD]
        command = "#{command} --RLE-threshold=99999" if options[:no_RLE]
        
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
          
          return Result.create_from_line(result[0], options)
        end
      end
    end
    
    class Result
      @@all_result_names = [
        :predicted_rle,
        :predicted_kld,
        :score
      ]
      @@all_result_names.each do |rn|
        attr_accessor rn
      end
      
      # Given the STDOUT from the ExportPred program, create a programmatically manipulatable Bio::ExportPred::Result object
      #
      # TODO: explain options={}
      def self.create_from_line(line, options={})
        result = Result.new
        if !line or line == ''
          result.predicted_rle = false unless options[:no_RLE]
          result.predicted_kld = false unless options[:no_KLD]
          return result
        end
        
        # line is going to be something like
        # metoo	RLE	6.44141	[a-met:M][a-leader:AVSTYNNTRRNGLRYVLKRR][a-hydrophobic:TILSVFAVICMLSL][a-spacer:NLSIFENNNNNYGFHCNKRH][a-RLE:FKSLAEA][a-tail:SPEEHNNLRSHSTSDPKKNEEKSLSDEINKCDMKKYTAEEINEMINSSNEFINRNDMNIIFSYVHESEREKFKKVEENIFKFIQSIVETYKIPDEYKMRKFKFAHFEMQGYALKQEKFLLEYAFLSLNGKLCERKKFKEVLEYVKREWIEFRKSMFDVWKEKLASEFREHGEMLNQKRKLKQHELDRRAQREKMLEEHSRGIFAKGYLGEVESETIKKKTEHHENVNEDNVEKPKLQQHKVQPPKVQQQKVQPPKSQQQKVQPPKSQQQKVQPPKVQQQKVQPPKVQKPKLQNQKGQKQVSPKAKGNNQAKPTKGNKLKKN]
        splits = line.split("\t")
        raise Exception, "Badly parsed line: #{line}" if splits.length != 4
        if splits[1] == 'RLE'
          result.predicted_rle = true
        elsif splits[1] = 'KLD'
          result.predicted_kld = true
        end
        result.score = splits[2].to_f
        return result
      end
      
      def predicted?
        @predicted_rle or @predicted_kld
      end
      alias_method :signal?, :predicted?
      alias_method :predicted_rle?, :predicted_rle
      alias_method :predicted_kld?, :predicted_kld
      
      def self.all_result_names
        @@all_result_names
      end
    end
  end
end