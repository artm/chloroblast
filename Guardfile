guard 'livereload' do
  watch %r{.+\.rb}
  watch(%r{public/.+\.(css|js|html)})
  watch(%r{views/.+\.(haml|sass|coffee)})
end

guard 'bundler' do
  watch('Gemfile')
end

guard 'rspec', version: 2, cli: '--color' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec" }
end

