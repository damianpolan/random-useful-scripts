require 'erb'

# Renders a kube template that uses erb and the partial() method

renderer_directory = ARGV[0]
template_paths = Dir[renderer_directory + "*"].select { |path| path.end_with?(".yml.erb") }
puts "template_paths="
pp template_paths

def partial(name, **args)
  bind = binding
  args.each do |k, v|
    bind.local_variable_set(k, v)
  end
  ERB.new(File.read("config/deploy/partials/#{name}.yml.erb")).result(bind)
end

def current_sha
  "e060bd3027ed34782b2719838e2f5e6b9175b6bf"
end

def cluster_location
  'gcp-northamerica-northeast1'
end

output_folder = File.join(renderer_directory, '/rendered')
puts "output_folder=#{output_folder}"
Dir.mkdir(output_folder) unless Dir.exist?(output_folder)

template_paths.each do |path|
  output_file = File.join(output_folder, File.basename(path))
  rendered = ERB.new(File.read(path)).result(binding)
  File.write(output_file, rendered)
end
