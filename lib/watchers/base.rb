module Watchers
  class Base
    def watch paths
      jobs = []

      paths.each do |path|
        unless File.exist?(path)
          $logger.warn "Path does not exist - #{path} "
          next
        end 
        jobs << Thread.new {
          $logger.info "Watching #{path}"
          guard = Guard::Listener.select_and_init({ :watchdir => path })
          guard.on_change do |changed_paths|
            yield(changed_paths)
          end
          guard.start
        }
      end

      jobs.each { |j| j.join }
    end
  end
end