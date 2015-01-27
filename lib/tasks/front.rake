namespace :front do

  desc "build front application"
  task :build do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "grunt"
      sh "rsync -Pa bin/ ../public/"
    end
  end

  desc "test front application"
  task :test do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install"
      sh "bower install"
      sh "grunt karma:unit"
    end
  end

end
