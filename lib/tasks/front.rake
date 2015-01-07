namespace :front do

  desc "build front application"
  task :build do 
    Dir.chdir('FrontApp') do
      sh "pwd"
      sh "npm install karma bower"
      sh "npm install"
      sh "bower install"
      sh "grunt"
      sh "rsync -Pa bin/ ../public/"
    end
  end

end
