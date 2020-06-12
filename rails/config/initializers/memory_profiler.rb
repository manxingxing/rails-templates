if ENV['RAILS_MEMORY_PROFILE'].present?
  Rails.configuration.middleware.use ::MemoryMiddleware
end
