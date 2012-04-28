Rails.application.config.middleware.use OmniAuth::Builder do
  unless Rails.env.production?
    provider :developer
  else
    provider :github, ENV['OMNIAUTH_GITHUB_ID'], ENV['OMNIAUTH_GITHUB_SECRET']
  end

end
