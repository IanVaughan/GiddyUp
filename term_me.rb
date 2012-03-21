require 'iterm_window'

class TermMe
  def self.go path
    puts path
    ItermWindow.current do
      open_tab :my_tab do
        set_title "#{path}"
        write "cd #{path}"
        write "tail -f log/development.log"
      end
    end
  end
end
