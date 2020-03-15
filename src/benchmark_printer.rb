module BenchmarkPrinter
  def benchmark_time(message, &block)
    time = Time.now.utc
    begin
      yield
    ensure
      duration_ms = (Time.now.utc - time) * 1000
      puts "#{message} #{duration_ms.round(2)} ms \n"
    end
  end
end