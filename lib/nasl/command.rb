################################################################################
# Copyright (c) 2011, Mak Kolybabi
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

module Nasl
  class Command
    def self.initialize!
      Dir.glob(Nasl.lib + 'nasl/commands/*.rb').each { |f| load(f) }
    end

    def self.all
      (@_all ||= [])
    end

    def self.inherited(cls)
      all << cls
    end

    def self.find(cmd)
      all.each do |cls|
        return cls if cls.binding == cmd
      end

      nil
    end

    def self.banner(title, width=80)
      # Create center of banner.
      middle = "[ #{title} ]"

      # Make sure width is a float.
      width = width.to_f

      # Create bars on either side.
      leftover = (width - middle.length) / 2
      left = '-' * leftover.floor
      right = '-' * leftover.ceil

      left + middle + right
    end

    def self.run(cfg, args)
      # Separate plugins and libraries from the rest of the arguments.
      paths = args.select { |arg| arg =~ /(\/|\.(inc|nasl))$/ }
      args -= paths

      # If we have no paths to process, there's a problem. Special purpose
      # commands that don't require files to be declared should override this
      # method.
      if paths.empty?
        puts "No directories (/), libraries (.inc), or plugins (.nasl) were specified."
        exit 1
      end

      # Collect all the paths together, recursively.
      dirents = []
      paths.each do |path|
        Pathname.new(path).find do |dirent|
          if dirent.file? && dirent.extname =~ /inc|nasl/
            dirents << dirent
          end
        end
      end

      # If the command is capable of handling all the paths at once, send them
      # in a group, otherwise send them individually.
      if self.respond_to? :analyze_all then
        analyze_all(cfg, dirents, args)
      else
        dirents.each { |d| analyze(cfg, d, args) }
      end
    end
  end
end
