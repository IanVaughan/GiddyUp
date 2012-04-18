require 'iterm_window'

module GiddupUp
  class TermMe

    def self.open path, project
      puts path
      ItermWindow.current do
        open_tab :my_tab do
          set_title "#{project}"
          write "cd #{path}"
          write "tail -f log/development.log"
        end
      end
    end

  end
end
