case ENV['RACK_ENV'] ||= 'development'
when 'test'
  ENV['SEQ_SESSION_SECRET'] ||= "oauYDTwZnSAO4x6SVZF9uMRgKY7aSyVDA528xtm4HVIUX/Z+mkWI20Rvy3It\nYuxi3AryNsUKC9Y39KhjXHo6tw==\n".unpack('m')[0]
  ENV['SEQ_DATABASE_URL'] ||= "postgres://localhost/seq_test?user=seq&password=seq"
when 'production'
  ENV['SEQ_SESSION_SECRET'] ||= "dPWyh3FhWGa0DuROuDjk0+X2B8iWCvCzWensjKLU15fmOqDWA8wjeqbxDRCX\nzButmFCSPYH+F1RYGnDAV6RnGw==\n".unpack('m')[0]
  ENV['SEQ_DATABASE_URL'] ||= "postgres://localhost/seq_production?user=seq&password=seq"
else
  ENV['SEQ_SESSION_SECRET'] ||= "ldje4/yBeP5scpOwGkACZeXq/nVvI1B442cG30USEvDNr8fviaeEbL0GhQZW\ncAq1vxEB7LJvvbYXUwnbqSZ2pw==\n".unpack('m')[0]
  ENV['SEQ_DATABASE_URL'] ||= "postgres://localhost/seq_development?user=seq&password=seq"
end
