require_relative 'string'

class BenchmarkPrinter
  def self.benchmark_time(message, highlight_number: false,  &block)
    time = Time.now.utc
    begin
      yield
    ensure
      duration_ms = ((Time.now.utc - time) * 1000).round(2)
      duration_message = highlight_number ?  String.underline_and_bold(duration_ms) : duration_ms
      puts "#{message} #{duration_message} ms \n"
    end
  end
end
