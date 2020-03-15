class Color
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
  end
end
