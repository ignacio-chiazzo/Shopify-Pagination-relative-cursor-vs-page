require_relative '../src/utils/string'

class BenchmarkPrinter
  def self.benchmark_time(message, highlight_number: false,  &block)
    time = Time.now.utc
    result = yield
    duration_ms = ((Time.now.utc - time) * 1000)
    duration_ms = duration_ms.round(2)
    duration_message = highlight_number ?  String.underline_and_bold(duration_ms) : duration_ms
    puts "#{message} #{duration_message} ms \n"
    [result, duration_ms]
  end
end
