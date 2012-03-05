module Watchers
  class Watcher

    def watch dir
      listener = Guard::Listener.select_and_init({ :watchdir => dir })
      listener.on_change do |files|
        yield(files)
      end
      listener.start
    end
  end
end