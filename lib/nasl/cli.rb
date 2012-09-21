################################################################################
# Copyright (c) 2011-2012, Mak Kolybabi
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
################################################################################

require 'optparse'

module Nasl
  class Cli
    @@Iterations = 1000

    def self.run
      cfg = {
        :iterations => @@Iterations,
        :verbose    => 0
      }

      Command.initialize!

      optparse = OptionParser.new do |opts|
        opts.banner = "Usage: nasl [options] [command [args]]"

        opts.on('-i', '--iterations=ITERS', 'Benchmarking iterations') do |iters|
          cfg[:iterations] = iters.to_i || @@Iterations
        end

        opts.on('-v', '--verbose', 'Output more information') do
          cfg[:verbose] += 1
        end
      end

      optparse.parse!

      # Sanity check the command line arguments.
      if ARGV.empty?
        puts "No command was specified."
        puts
        usage
        exit 1
      end

      cmd = ARGV.shift
      cls = Command.find(cmd)
      if cls.nil? then
        puts "Command '#{cmd}' not supported."
        puts
        usage
        exit 1
      end

      # Run the command.
      cls.run(cfg, ARGV)
    end

    def self.usage
      puts "nasl-parse [flags] [command] [path ...]"
      puts
      puts "Flags:"
      puts "    -i iters    Benchmark the parser running 'iters' iterations, default #@@Iterations."
      puts "                Only valid with the 'benchmark' command."
      puts "    -v          Display more verbose (warning) messages."
      puts "    -vv         Display more verbose (informational) messages."
      puts
      puts "Commands:"
      puts "    benchmark   Benchmarks the parsing of the input path(s)."
      puts "    parse       Parses the input path(s)."
      puts "    test        Runs the specified unit tests, all are selected by default."
      puts "    tokenize    Tokenizes the input path(s)."
      puts "    xml         Parses the input path(s) and displays them as XML."
    end
  end
end
