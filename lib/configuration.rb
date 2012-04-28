# OMNI_AUTH settings
omniauth_file =  File.expand_path('../../config/omniauth_settings.yml', __FILE__)
if File.exist?(omniauth_file)
  YAML.load_file(omniauth_file).each{|k,v| ENV[k.to_s] = v.to_s}
end