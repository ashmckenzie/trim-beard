Dir['lib/providers/**'].each do |f|
  require File.join($APP_ROOT, f)
end