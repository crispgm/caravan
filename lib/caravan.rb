require "colorize"
require "listen"

module Caravan
  class << self
    def start(src_path = ".", target_path)
      listener = Listen.to(src_path) do |modified, added, removed|
        unless (modified.empty? && added.empty? && removed.empty?)
          handle_changes(src_path, target_path)

          (added + modified + removed).each do |change|
            puts "#{change} was changed."
          end
        end
      end

      puts "Starting to watch #{src_path}...".green
      listener.start
      
      trap("INT") do
        listener.stop
        puts "\tHalting watching.".green
        exit 0
      end

      sleep_forever
    end

    def handle_changes(src_path, target_path)
      `cp -r #{src_path} #{target_path}`
    end

    def sleep_forever
      loop { sleep 1000 }
    end
  end
end
