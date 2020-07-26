class MemoryProfileMiddleware
  RSS_THRESHOLD = 1024 * 1024 # 1024 MB

  def initialize(app)
    @app = app
    @counter = 0
    @enable_print_rss = false
  end

  def call(env)
    @counter = (@counter + 1) % 20
    start_objects = GC.stat :total_allocated_objects
    status, headers, body = @app.call(env)
    finish_objects = GC.stat :total_allocated_objects

    log(start_objects, finish_objects)

    [status, headers, body]
  end

  def log(start_objects, finish_objects)
    msg = 'rss %s allocated_objects delta %s total %s heap_slots available %s live %s free %s' % [
      rss_sample,
      finish_objects - start_objects,
      finish_objects,
      GC.stat[:heap_available_slots],
      GC.stat[:heap_live_slots],
      GC.stat[:heap_free_slots]
    ]
    Rails.logger.info(msg)
  end

  # 每间隔一些请求，打印内存占用
  def rss_sample
    return 0 unless @counter == 0 || @enable_print_rss

    rss_value = rss
    @enable_print_rss = rss_value > RSS_THRESHOLD
    rss_value
  end

  def rss
    `ps -o rss= -p #{$$}`.to_i
  end
end
