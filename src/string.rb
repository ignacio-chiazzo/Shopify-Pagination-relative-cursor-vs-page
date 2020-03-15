class String
  class << self
    def blue(message)
      "\e[34m#{message}\e[0m"
    end

    def red(message)
      "\e[31m#{message}\e[0m"
    end

    def green(message)
      "\e[32m#{message}\e[0m"
    end

    def bg_gray(message)
      "\e[47m#{message}\e[0m"
    end

    def underline(message)
      "\e[4m#{message}\e[24m"
    end

    def bold(message)
      "\e[1m#{message}\e[22m"
    end

    def underline_and_bold(message)
      bold(underline(message))
    end
  end
end
